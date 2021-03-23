$OPTIONS MAIN, SPECIAL, NOCHECK

TYPE
    SETOFCHAR = SET OF CHAR;

CONST
    INTERSECT := '+';
    ALPHA: SETOFCHAR := ['A'..'Z','$','_','0'..'9'];
    DEF_LIP := 4;
    DEF_ARM := 2;
    DEF_INDENT := 3;
    BOXCHAR := '*';
    VERTCHAR := '|';
    HORIZCHAR := '-';
    MIN := 1;
    MAX := 1000;
    DEF_MAXLEN := 100;
    MIN_LIP := 2;
    MIN_ARM := 2;
    MIN_INDENT := 0;

TYPE
    PTR = ^ENTRY;
    HALFWORD = 0..777777B;
    ENTRY = PACKED RECORD
      NAME: ALFA;
      LLINK, RLINK: PTR;
      LEFT, RIGHT: PTR;
      RIGHTCOUNT, LEFTCOUNT: HALFWORD;
      CHECKFLAG: BOOLEAN
    END;
    LINER= PACKED ARRAY[1..DEF_MAXLEN] OF CHAR;
    PAGEREC = PACKED RECORD
      PAGE: ARRAY[1..1] OF LINER
    END;

PUBLIC VAR
    SUBTREES: BOOLEAN;
    PASS1: BOOLEAN;
    NAMING, BOXING: BOOLEAN;
    LIP, ARM, INDENT, MAXLEN: INTEGER;
    MAXLEVEL: INTEGER;
    IDCOUNT: INTEGER;
    WEIGHT: INTEGER;
    LEN: INTEGER;
    FIRST, P, PT, HEAD: PTR;
    SYM: ALFA;
    CH: CHAR;
    FIRSTLINE: BOOLEAN;
    MAXLINE, CENTER: INTEGER;
    LEFTPTR, RIGHTPTR: PTR;
    PAGER: ^PAGEREC;
    BLANKLINE: LINER :=
      '                                                                                     '
	;
    BASE, CURRENTLINE, TOLEFT, TORIGHT, I, J, K: INTEGER;

PUBLIC PROCEDURE DROP (LINE: INTEGER; POSITION: INTEGER; VALUE: INTEGER);

VAR
    I, J: INTEGER;
    VAL, LEN: INTEGER;

BEGIN
  LEN := 0;
  VAL := VALUE;
  REPEAT
    LEN := LEN + 1;
    VAL := VAL DIV 10
  UNTIL VAL = 0;
  I := LEN - 1;
  WITH PAGER^ DO
    REPEAT
      IF POSITION+I <= MAXLEN THEN
	PAGE[LINE,POSITION+I] := CHR (VALUE MOD 10+ORD('0'));
      I := I - 1;
      VALUE := VALUE DIV 10;
    UNTIL VALUE = 0;
END;

PUBLIC FUNCTION COUNTREE (ID: PTR; LEVEL: INTEGER): INTEGER;

VAR
    I: INTEGER;

BEGIN
  COUNTREE := 0;
  IF ID <> NIL THEN
    WITH ID^ DO BEGIN
      IF PASS1 THEN BEGIN
	IF CHECKFLAG THEN BEGIN
	  WRITELN (TTY,' Illegal tree.');
	  BREAK;
	  STOP;
	END;
	IF (LLINK <> NIL) ANDIF (LLINK^.NAME >= NAME) ORIF (RLINK <> NIL) ANDIF
	  (RLINK^.NAME <= NAME) THEN BEGIN
	    WRITELN (TTY,' Tree nodes not correctly ordered');
	    BREAK;
	    STOP;
	  END;
	WEIGHT := WEIGHT + LEVEL;
	CHECKFLAG := TRUE;
	IF LEVEL > MAXLEVEL THEN
	  MAXLEVEL := LEVEL;
	LEFTCOUNT := COUNTREE (ID^.LLINK, LEVEL+1);
	RIGHTCOUNT := COUNTREE (ID^.RLINK, LEVEL+1);
	COUNTREE := LEFTCOUNT + RIGHTCOUNT + 1;
      END
      ELSE BEGIN
	IF NOT CHECKFLAG THEN BEGIN
	  WRITELN (TTY,' Tree error');
	  BREAK;
	  STOP;
	END;
	I := COUNTREE (LEFT,LEVEL+1);
	I := COUNTREE (RIGHT,LEVEL+1);
      END;
    END;
END;

PUBLIC FUNCTION ASSIGN (ID: PTR; LEVEL: INTEGER): INTEGER;

VAR
    BASE, START, TORIGHT, TOLEFT, CENTER: INTEGER;

BEGIN
  ASSIGN := CURRENTLINE;
  IF ID <> NIL THEN
    WITH ID^, PAGER^ DO BEGIN
      IF RLINK = NIL THEN
	TORIGHT := CURRENTLINE
      ELSE BEGIN
	TORIGHT := ASSIGN (RLINK,LEVEL+1);
      END;
      CENTER := CURRENTLINE;
      BASE := LEVEL*(LIP+INDENT)+1;
      IF BASE <= MAXLEN THEN
	PAGE[CENTER,BASE] := INTERSECT;
      FOR I := BASE+1 TO BASE+LIP-1 DO
	IF I <= MAXLEN THEN
	  PAGE[CENTER,I] := HORIZCHAR;
      LEN := INDEX(NAME,' ',11)-1;
      IF BASE+LIP <= MAXLEN THEN
	PAGE[CENTER,BASE+LIP] := BOXCHAR;
      IF BOXING THEN
	IF BASE+LIP+3+LEN <= MAXLEN THEN
	  PAGE[CENTER,BASE+LIP+3+LEN] := BOXCHAR;
      IF NAMING THEN
	IF BASE+LIP+2+LEN <= MAXLEN THEN
	  PAGE[CENTER,BASE+LIP+2:LEN] := NAME[1:LEN];
      IF BOXING THEN BEGIN
	FOR I := CENTER-1 TO CENTER+1 BY 2 DO
	  FOR J := BASE+LIP TO BASE+LIP+LEN+3 DO
	    IF J <= MAXLEN THEN
	      PAGE[I,J] := BOXCHAR;
	IF SUBTREES THEN
	  IF RIGHTCOUNT > 0 THEN
	    DROP (CENTER-2,BASE+LIP+INDENT+1,RIGHTCOUNT);
	IF SUBTREES THEN
	  IF LEFTCOUNT > 0 THEN
	    DROP (CENTER+2,BASE+LIP+INDENT+1,LEFTCOUNT);
      END;
      IF BASE+LIP+INDENT <= MAXLEN THEN BEGIN
	IF BOXING THEN
	  START := CENTER-2
	ELSE
	  START := CENTER-1;
	FOR I := TORIGHT+1 TO START DO
	  PAGE[I,BASE+LIP+INDENT] := VERTCHAR;
      END;
      CURRENTLINE := CURRENTLINE + ARM + 2;
      IF LLINK <> NIL THEN BEGIN
	TOLEFT := ASSIGN (LLINK,LEVEL+1);
	IF BASE+LIP+INDENT <= MAXLEN THEN BEGIN
	  IF BOXING THEN
	    START := CENTER+2
	  ELSE
	    START := CENTER+1;
	  FOR I := START TO TOLEFT-1 DO
	    PAGE[I,BASE+LIP+INDENT] := VERTCHAR;
	END;
      END;
      ASSIGN := CENTER;
      IF CURRENTLINE > MAXLINE THEN
	MAXLINE := CURRENTLINE;
    END;
END;

PUBLIC FUNCTION FINDID (ID: ALFA): BOOLEAN;

VAR
    LP: PTR;

BEGIN
  P := HEAD;
  LP := NIL;
  FINDID := FALSE;
  WHILE (P <> NIL) AND NOT FINDID DO
    WITH P^ DO BEGIN
      LP := P;
      IF ID = NAME THEN
	FINDID := TRUE
      ELSE IF ID < NAME THEN
	P := LEFT
      ELSE
	P := RIGHT;
    END;
  IF NOT FINDID THEN
    P := LP;
END;

BEGIN
  FIRSTLINE := TRUE;
  MAXLINE := 0;
  HEAD := NIL;
  NAMING := TRUE;
  BOXING := TRUE;
  REWRITE(TTY);
  WRITELN (TTY);
  OPEN (TTY);
  WRITE (TTY,' <lip><arm><indent><max line>/<options>? ');
  BREAK;
  READLN (TTY);
  LIP := DEF_LIP;
  ARM := DEF_ARM;
  INDENT := DEF_INDENT;
  SUBTREES := FALSE;
  MAXLEN := DEF_MAXLEN;
  IF EOLN (TTY) ORIF (TTY^ <> '/') THEN
    CH := ' '
  ELSE
    READ (TTY,CH);
  IF (CH <> '/') ANDIF NOT EOLN (TTY) THEN BEGIN
    READ (TTY,LIP);
    IF LIP < MIN_LIP THEN
      LIP := MIN_LIP;
    IF TTY^ = '/' THEN
      READ (TTY,CH);
    IF NOT EOLN (TTY) ANDIF (CH <> '/') THEN BEGIN
      READ (TTY,ARM);
      IF ARM < MIN_ARM THEN
	ARM := MIN_ARM;
      IF TTY^ = '/' THEN
	READ (TTY,CH);
      IF NOT EOLN (TTY) ANDIF (CH <> '/') THEN BEGIN
	READ (TTY,INDENT);
	IF INDENT < MIN_INDENT THEN
	  INDENT := MIN_INDENT;
	IF TTY^ = '/' THEN
	  READ (TTY,CH);
	IF NOT EOLN (TTY) ANDIF (CH <> '/') THEN BEGIN
	  READ (TTY,MAXLEN);
	  IF (MAXLEN <= 0) ORIF (MAXLEN > DEF_MAXLEN) THEN
	    MAXLEN := DEF_MAXLEN;
	END;
      END;
    END;
  END;
  WHILE NOT EOLN (TTY) AND (CH = ' ') DO
    READ (TTY,CH);
  IF CH = '/' THEN BEGIN
    REPEAT
      READ (TTY,CH);
      CH := UPPERCASE (CH);
      CASE CH OF
	'N':
	  BOXING := FALSE;
	'O':
	  NAMING := FALSE;
	'S':
	  SUBTREES := TRUE
      END;
    UNTIL EOLN (TTY);
    IF NOT BOXING THEN
      ARM := ARM-3;
  END;
  RESET (INPUT,'TREE.TXT');
  REWRITE (OUTPUT,'TREE.LST');
  IF EOF (INPUT) THEN
    STOP;
  REPEAT
    READ (CH);
    IF CH = ' ' THEN
      LEFTPTR := NIL
    ELSE BEGIN
      CH := UPPERCASE (CH);
      SYM := '          ';
      I := 1;
      WHILE CH IN ALPHA DO BEGIN
	SYM[I] := CH;
	I := I + 1;
	READ (CH);
	CH := UPPERCASE (CH);
      END;
      IF FINDID (SYM) THEN BEGIN
	LEFTPTR := P;
      END
      ELSE BEGIN
	NEW (LEFTPTR);
	WITH LEFTPTR^ DO BEGIN
	  NAME := SYM;
	  LEFT := NIL;
	  RIGHT := NIL;
	  LLINK := NIL;
	  RLINK := NIL;
	  CHECKFLAG := FALSE;
	END;
	IF P = NIL THEN
	  HEAD := LEFTPTR
	ELSE IF SYM < P^.NAME THEN
	  P^.LEFT := LEFTPTR
	ELSE
	  P^.RIGHT := LEFTPTR;
      END;
    END;
    READ (CH);
    SYM := '          ';
    I := 1;
    CH := UPPERCASE (CH);
    WHILE CH IN ALPHA DO BEGIN
      SYM[I] := CH;
      I := I + 1;
      IF EOLN THEN
	CH := ' '
      ELSE BEGIN
	READ (CH);
	CH := UPPERCASE (CH);
      END;
    END;
    IF NOT FINDID (SYM) THEN BEGIN
      NEW (PT);
      WITH PT^ DO BEGIN
	NAME := SYM;
	LEFT := NIL;
	RIGHT := NIL;
	CHECKFLAG := FALSE;
      END;
      IF P = NIL THEN
	HEAD := PT
      ELSE IF SYM < P^.NAME THEN
	P^.LEFT := PT
      ELSE
	P^.RIGHT := PT;
      IF FIRSTLINE THEN BEGIN
	FIRST := PT;
	FIRSTLINE := FALSE;
      END;
    END
    ELSE
      PT := P;
    IF EOLN THEN
      RIGHTPTR := NIL
    ELSE BEGIN
      READ (CH);
      CH := UPPERCASE (CH);
      I := 1;
      SYM := '          ';
      WHILE CH IN ALPHA DO BEGIN
	SYM[I] := CH;
	I := I + 1;
	IF EOLN THEN
	  CH := ' '
	ELSE BEGIN
	  READ (CH);
	  CH := UPPERCASE (CH);
	END;
      END;
      IF NOT FINDID (SYM) THEN BEGIN
	NEW (RIGHTPTR);
	WITH RIGHTPTR^ DO BEGIN
	  NAME := SYM;
	  RIGHT := NIL;
	  LEFT := NIL;
	  LLINK := NIL;
	  RLINK := NIL;
	  CHECKFLAG := FALSE;
	END;
	IF P = NIL THEN
	  HEAD := RIGHTPTR
	ELSE IF SYM < P^.NAME THEN
	  P^.LEFT := RIGHTPTR
	ELSE
	  P^.RIGHT := RIGHTPTR;
      END
      ELSE
	RIGHTPTR := P;
    END;
    PT^.LLINK := LEFTPTR;
    PT^.RLINK := RIGHTPTR;
    READLN;
  UNTIL EOF;
  WEIGHT := 0;
  MAXLEVEL := 0;
  PASS1 := TRUE;
  IDCOUNT := COUNTREE (FIRST, MAXLEVEL+1);
  PASS1 := FALSE;
  I := COUNTREE (FIRST, MAXLEVEL+1);
  NEW (PAGER:(IDCOUNT+3)*(ARM+2));
  WITH PAGER^ DO
    FOR I := MIN TO (IDCOUNT+3)*(ARM+2) DO
      PAGE[I] := BLANKLINE;
  CURRENTLINE := 2;
  I := ASSIGN (FIRST,0);
  WITH PAGER^ DO
    FOR I := MIN TO MAXLINE DO
      WRITELN (PAGE[I]);
  WRITELN (TTY,IDCOUNT:4,' entries, max level = ',MAXLEVEL:3);
  WRITELN (TTY,' Unweighted average search = ',WEIGHT/IDCOUNT:6:2);
  BREAK;
END.
   