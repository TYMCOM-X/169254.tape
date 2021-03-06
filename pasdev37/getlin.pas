	    (************************************
	     *                                  *
	     * SCRIBE-10  PROCESSED LINE READER *
	     *                                  *
	     * PERFORMS CENTERING/JUSTIFICATION *
	     *                                  *
	     ************************************)

$INCLUDE STDTYP.inc

EXTERNAL PROCEDURE JUSTLINE(VAR F:TEXT; LENGTH:LINEPTR; VAR RDLINE:LINE;
  VAR RDLEN:LINEPTR; VAR CMDLINE:LINE; VAR CMDLEN:LINEPTR; CURSTATE:STATE);
EXTERNAL PROCEDURE READLINE(VAR F:TEXT; VAR RDLINE:LINE; VAR RDLEN:LINEPTR;
  VAR CMDFLG:BOOLEAN);

PUBLIC FUNCTION GETLINE(VAR F:TEXT; LENGTH:LINEPTR; CURSTATE:STATE; VAR RDLINE: LINE;
VAR RDLEN:LINEPTR; VAR CMDLINE: LINE; VAR CMDLEN:LINEPTR): BOOLEAN;

CONST
  SPACE: CHTYPE := (CHR(#O40), []);

VAR
  INSERT,INDEX: LINEPTR; CMDFLG:BOOLEAN;
  I: LINEPTR;

BEGIN
  IF (CURSTATE=CENTERING)OR(CURSTATE=RIGHTJUST)OR(CURSTATE=READING) THEN
  BEGIN
    READLINE(F,RDLINE,RDLEN,CMDFLG);
    IF NOT CMDFLG THEN
    BEGIN
     IF (RDLEN>0) AND (CURSTATE<>READING) THEN
     BEGIN
      CASE CURSTATE OF
      CENTERING: INSERT:= (LENGTH-RDLEN) DIV 2;
      RIGHTJUST: INSERT:= LENGTH-RDLEN
      END;
      IF INSERT>0 THEN
      BEGIN
	FOR INDEX:= RDLEN DOWNTO 1 DO RDLINE[INDEX+INSERT]:= RDLINE[INDEX];
	FOR INDEX:=1 TO INSERT DO RDLINE[INDEX]:= SPACE;
	RDLEN:= RDLEN+INSERT
      END
     END;
      CMDLEN:= 0; GETLINE:= TRUE		(*NO CMD, GOT LINE*)
    END
    ELSE
    BEGIN
      CMDLINE:= RDLINE; CMDLEN:= RDLEN;
      GETLINE:= FALSE				(*GO CMD, BUT NO LINE*)
    END
  END
  ELSE
  BEGIN
    JUSTLINE(F,LENGTH,RDLINE,RDLEN,CMDLINE,CMDLEN,CURSTATE);
    IF RDLEN>0 THEN GETLINE:= TRUE		(*GOT LINE, MAY HAVE CMD*)
    ELSE GETLINE:= FALSE			(*NO LINE, HAVE CMD*)
  END;
END.						(*GETLINE*)
 