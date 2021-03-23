
		    (* COMMAND PARSER *)

PROCEDURE GETCMD;
LABEL 1;
VAR CURTOK:TOKENDESC; BADLINE:BOOLEAN; I:INTEGER; SAVECMD:COMMAND;
    NEWTABS: TABARRAY; NEWTABCNT: 0..MAXTABS;

  PROCEDURE ERROR;
  VAR LNUM:LINENUM; LCNT:INTEGER;
  BEGIN
    IF NOT BADLINE THEN
    BEGIN
      GETLNR(LNUM,LCNT);
      IF LNUM='-----' THEN WRITE(TTY,LCNT:5)
      ELSE WRITE(TTY,LNUM);
      WRITE(TTY,' ');
      WRTLINE(TTYOUTPUT,CMDLN,CMDLEN,FALSE,FALSE, MAP, TERMINAL);
      WRITELN(TTY);
      WRITELN(TTY,' ':CURTOK.TOKPOS+5,'^');
      WRITELN(TTY,'ERROR IN COMMAND');
      BREAK(TTY);
      BADLINE:= TRUE
    END
  END;						(*ERROR*)



  PROCEDURE MAKE_MAPPING;			(* handles translate command *)

    VAR
      STRINGTO,					(* domain string *)
      STRINGFROM: PSTRGDESC;			(* domain string *)


    BEGIN
      STRINGTO := NIL;
      STRINGFROM := NIL;
      WITH CURTOK DO
      IF TOKTYP = EOL THEN			(* reinitialize translation vector *)
	INIT_TABLE
      ELSE
      IF TOKTYP <> STRTOK THEN
      BEGIN
	ERROR;
	RETURN
      END
      ELSE
      BEGIN
	NEW(STRINGFROM);
	STRINGFROM^ := STRINFO;
	SCAN(CURTOK);
	IF TOKTYP <> STRTOK THEN
	BEGIN
	  ERROR;
	  RETURN
	END;
	NEW(STRINGTO);
	STRINGTO^ := STRINFO;
	IF STRINGFROM^.STRLEN < STRINGTO^.STRLEN THEN	(* first string len must be greater *)
	BEGIN
	  ERROR;
	  RETURN
	END;
	FOR I := 1 TO STRINGTO^.STRLEN DO
	  MAP[STRINGFROM^.STRVAL[I].VALUE] := STRINGTO^.STRVAL[I].VALUE
      END
    END;
  PROCEDURE GETHDRTRLR(OLDHDR:PSTRGDESC; VAR NEWHDR:PSTRGDESC);
  VAR NEWHT: PSTRGDESC;

    PROCEDURE GETAHDR(VAR P:PSTRGDESC);
    VAR JUST:JUSTYPE;

    BEGIN
      P:= NIL;
      WITH CURTOK DO
	IF NOT ((TOKTYP = EOL) OR (TOKTYP = CMD)) THEN BEGIN
	  IF TOKTYP=WRD THEN BEGIN
	    IF WRDTYP=RIGHTWD THEN JUST:= JUSRIGHT
	    ELSE IF WRDTYP=LEFTWD THEN JUST:= JUSLEFT
	    ELSE IF WRDTYP=OFFWD THEN
	    BEGIN SCAN(CURTOK);
	      IF NOT ((TOKTYP = EOL) OR (TOKTYP = CMD)) THEN ERROR;
	      RETURN
	    END
	    ELSE BEGIN ERROR; RETURN END;
	    SCAN(CURTOK)
	  END
	  ELSE JUST:= JUSCENTER;
	  IF TOKTYP<>STRTOK THEN
	    BEGIN ERROR; RETURN END
	  ELSE BEGIN
	     NEW(P); P^:= STRINFO;
	    WITH P^ DO BEGIN
	      STRGJUST:= JUST;
	      SCAN(CURTOK);
	      GETAHDR(NEXTSTRG)
	    END
	  END					(*STRTOK*)
	END					(*NOT EOL*)
    END (*GETAHDR*);

  BEGIN						(*GETHDRTRLR*)
    GETAHDR(NEWHT);
    IF BADLINE THEN FREEHDRTRLR(NEWHT)
    ELSE BEGIN
      IF NEWHDR<>OLDHDR THEN FREEHDRTRLR(NEWHDR);
      IF NEWHT<>NIL THEN WITH NEWHT^ DO
	IF (NEXTSTRG=NIL)AND(STRLEN=0)AND(STRGJUST=JUSCENTER)THEN
	BEGIN					(*SINGLE NULL STRTOK SAME AS OFF*)
	  DISPOSE(NEWHT); NEWHT:= NIL
	END;
      NEWHDR:= NEWHT
    END
  END (*GETHDRTRLR*);

BEGIN						(*GETCMD*)
  BADLINE:= FALSE;
  INITSCAN(CMDLN,CMDLEN);
  SCAN(CURTOK);
  WITH CURTOK DO
  BEGIN
    REPEAT
    IF TOKTYP<>CMD THEN ERROR
    ELSE
    BEGIN
      SAVECMD:= CMDTYP;
      SCAN(CURTOK);				(*GET NEXT TOKEN NOW*)
      CASE SAVECMD OF
      PAGE: BEGIN PAGE_TOP := TRUE; DOPAGE END;
      JUSTIFY:
	IF (TOKTYP = EOL) OR (TOKTYP = CMD) THEN CURSTATE:= JUSTIFYING
	ELSE IF (TOKTYP=WRD)AND(WRDTYP=LEFTWD) THEN
	  CURSTATE:= LEFTJUST
	ELSE ERROR;
      CENTER: CURSTATE:= CENTERING;
      RIGHT: CURSTATE:= RIGHTJUST;
      VERBATIM: CURSTATE:= READING;
      PARAGRAPH:
	IF NOT ((TOKTYP = EOL) OR (TOKTYP = CMD)) THEN
	  IF (TOKTYP<>INTGR) AND (TOKTYP<>SINTGR) THEN ERROR
	  ELSE PINDENT:= INTVAL
	ELSE PINDENT:= 0;
      SKIP:
	IF (ATTOP AND PAGE_TOP) OR (NOT ATTOP) THEN
	BEGIN
	  IF (TOKTYP = EOL) OR (TOKTYP = CMD) THEN
	    BEGIN IF ATTOP THEN DOTOP; WRITENL END
	  ELSE
	    IF TOKTYP<>INTGR THEN ERROR
	    ELSE IF INTVAL>0 THEN
	    BEGIN
	      IF ATTOP THEN DOTOP; WRITENL;
	      FOR I:= 1 TO INTVAL-1 DO IF NOT ATTOP THEN WRITENL
	    END
	END;
      ENDOFFILE: DONE:= TRUE;
      TITLE:GETHDRTRLR(CTITLE,NTITLE);
      FOOTNOTES: GETHDRTRLR(CFOOT,NFOOT);
      DECAP:
	IF TOKTYP<>WRD THEN ERROR
	ELSE IF WRDTYP=OFFWD THEN OFFDECAP
	ELSE IF WRDTYP=ONWD THEN ONDECAP
	ELSE ERROR;
      UNDER:
	IF TOKTYP<>WRD THEN ERROR
	ELSE IF WRDTYP=OFFWD THEN OFFUNDER
	ELSE IF WRDTYP=ONWD THEN ONUNDER
	ELSE ERROR;
      INDENT:
	IF TOKTYP<>WRD THEN 
	BEGIN
	  IF TOKTYP = INTGR THEN CLINDENT := INTVAL
	  ELSE IF TOKTYP = SINTGR THEN CLINDENT := CLINDENT + INTVAL
	  ELSE IF TOKTYP = EOL THEN CLINDENT := 0
	  ELSE ERROR
	END
	ELSE IF WRDTYP=RIGHTWD THEN
	BEGIN
	  SCAN(CURTOK);
	  IF TOKTYP=INTGR THEN CRINDENT:= INTVAL
	  ELSE IF TOKTYP=SINTGR THEN CRINDENT:= CRINDENT+INTVAL
	  ELSE IF (TOKTYP = EOL) OR (TOKTYP = CMD) THEN CRINDENT:= 0
	  ELSE ERROR
	END
	ELSE IF WRDTYP=LEFTWD THEN
	BEGIN
	  SCAN(CURTOK);
	  IF TOKTYP=INTGR THEN CLINDENT:= INTVAL
	  ELSE IF TOKTYP=SINTGR THEN CLINDENT:= CLINDENT+INTVAL
	  ELSE IF (TOKTYP = EOL) OR (TOKTYP = CMD) THEN CLINDENT:= 0
	  ELSE ERROR
	END;
      SPACING:
	IF (TOKTYP = EOL) OR (TOKTYP = CMD) THEN CSPACING:= 0
	ELSE IF TOKTYP=INTGR THEN CSPACING:= INTVAL-1
	ELSE ERROR;
      WIDTH:
	IF TOKTYP=WRD THEN
	  IF WRDTYP<>TERWD THEN ERROR
	  ELSE
	  BEGIN
	    WRITE(TTY,'WIDTH: ');BREAK(TTY);
	    READLN(TTY); READ(TTY,NWIDTH)
	  END
	ELSE IF TOKTYP=INTGR THEN NWIDTH:= INTVAL
	ELSE ERROR;
      MARGIN:
	IF TOKTYP=WRD THEN
	  IF WRDTYP<>TERWD THEN ERROR
	  ELSE
	  BEGIN
	    WRITE(TTY,'MARGIN: ');BREAK(TTY);
	    READLN(TTY); READ(TTY,NMARGIN)
	  END
	ELSE IF TOKTYP=INTGR THEN NMARGIN:= INTVAL
	ELSE ERROR;
      TOP:
	IF TOKTYP=WRD THEN
	  IF WRDTYP<>TERWD THEN ERROR
	  ELSE
	  BEGIN
	    WRITE(TTY,'TOP: ');BREAK(TTY);
	    READLN(TTY); READ(TTY,NTOP)
	  END
	ELSE IF TOKTYP=INTGR THEN NTOP:= INTVAL
	ELSE ERROR;
      BOTTOM:
	IF TOKTYP=WRD THEN
	  IF WRDTYP<>TERWD THEN ERROR
	  ELSE
	  BEGIN
	    WRITE(TTY,'BOTTOM: ');BREAK(TTY);
	    READLN(TTY); READ(TTY,NBOTTOM)
	  END
	ELSE IF TOKTYP=INTGR THEN NBOTTOM:= INTVAL
	ELSE ERROR;
      LENCMD:
	IF TOKTYP=WRD THEN
	  IF WRDTYP<>TERWD THEN ERROR
	  ELSE
	  BEGIN
	    WRITE(TTY,'LENGTH: ');BREAK(TTY);
	    READLN(TTY); READ(TTY,NLENGTH)
	  END
	ELSE IF TOKTYP=INTGR THEN NLENGTH:= INTVAL
	ELSE ERROR;
      NUMBER:
	WITH NNUMBER DO
	BEGIN
	  ALTRNT := FALSE;
	  IF TOKTYP=WRD THEN BEGIN
	    IF WRDTYP=BOTTOMWD THEN
	      BEGIN WHERE:= NUMBOT; SCAN(CURTOK) END
	    ELSE IF WRDTYP=TOPWD THEN
	      BEGIN WHERE:= NUMTOP; SCAN(CURTOK) END
	    ELSE IF WRDTYP=OFFWD THEN
	      BEGIN WHERE:= NONUM; GOTO 1 END
	    ELSE WHERE:= NUMBOT			(*DEFAULT*)
	  END
	  ELSE IF TOKTYP<>INTGR THEN
	    BEGIN ERROR; GOTO 1 END;

	  IF TOKTYP=WRD THEN
	  BEGIN
	    IF WRDTYP = ALTERWD THEN
	    BEGIN
	      ALTRNT := TRUE;
	      SCAN(CURTOK)
	    END
	  END;
	  IF TOKTYP=WRD THEN
	  BEGIN
	    IF WRDTYP=RIGHTWD THEN JUST:= JUSRIGHT
	    ELSE IF WRDTYP=LEFTWD THEN JUST:= JUSLEFT
	    ELSE BEGIN ERROR; GOTO 1 END;
	    SCAN(CURTOK)
	  END
	  ELSE JUST:= JUSCENTER;
	  IF TOKTYP=INTGR THEN NUM:= INTVAL;
1:
	END;					(*NUMBER CASE*)
      NEED:
	IF TOKTYP <> INTGR THEN ERROR
	ELSE
	  IF ((INTVAL+LINECNT) > (CLENGTH-CBOTTOM)) AND (CLENGTH>0)
	    THEN DOPAGE;
      TABS: BEGIN
	NEWTABCNT:= 0;
	WHILE (TOKTYP=INTGR) AND (NOT BADLINE) DO
	  IF NEWTABCNT<MAXTABS THEN
	  BEGIN
	    IF NEWTABCNT>0 THEN
	      IF INTVAL<=NEWTABS[NEWTABCNT] THEN ERROR;
	    NEWTABCNT:= NEWTABCNT+1;
	    NEWTABS[NEWTABCNT]:= INTVAL;
	    SCAN(CURTOK);
	    IF (TOKTYP=SPECIAL) AND (SPECCHAR=',') THEN
	    BEGIN SCAN(CURTOK);
	      IF TOKTYP<>INTGR THEN ERROR
	    END
	  END
	  ELSE ERROR;				(*TOO MANY TABS*)
	IF (TOKTYP = EOL) OR (TOKTYP = CMD) THEN
	BEGIN
	  IF NOT BADLINE THEN
	    BEGIN CURTABCNT:= NEWTABCNT; CURTABS:= NEWTABS END
	END
	ELSE ERROR				(*JUNK ON END OF LINE*)
      END;					(*TABS*)

      TRANSLATE: MAKE_MAPPING;

      CONTROL:
      IF TOKTYP <> WRD THEN ERROR
      ELSE IF WRDTYP=OFFWD THEN OFFCONTROL
      ELSE IF WRDTYP=ONWD THEN ONCONTROL
      ELSE ERROR

      END;					(*CASE COMMAND*)
      IF NOT ((TOKTYP = EOL) OR (TOKTYP = CMD)) THEN
      BEGIN
	SCAN(CURTOK);
	IF NOT ((TOKTYP = EOL) OR (TOKTYP = CMD)) THEN
	  ERROR
      END
    END						(*COMMAND PARSING*)
      UNTIL (TOKTYP = EOL) OR (BADLINE = TRUE)
  END						(*WITH CURTOK*)
END;						(*GETCMD*)
  