$OPTIONS MAIN, SPECIAL, NOCHECK

VAR
    IX: INTEGER;
    COUNT: INTEGER;
    STR: STRING;
    CH: CHAR;

TYPE SIXBIT = PACKED ARRAY[0..5] OF 0..77B;
     HALFWORD = 0..777777B;
     REC = PACKED RECORD
	CASE INTEGER OF
	1: (INT: INTEGER);
	2: (ARR: SIXBIT);
	3: (LEFT: HALFWORD; RIGHT: HALFWORD)
	END;
VAR F: FILE OF REC;
    FNAME, UFD: REC;
PROCEDURE OUT (S: SIXBIT);
VAR I: INTEGER;
BEGIN
  FOR I := 0 TO 5 DO BEGIN
  EXIT IF S[I] = 0;
    WRITE (TTY,CHR (S[I]+40B));
  END;
END;
BEGIN
  REWRITE (TTY);
  OPEN (TTY);
  LOOP
    WRITE (TTY,'FILE: '); BREAK;
    READLN (TTY);
  EXIT IF EOLN (TTY);
    STR := '';
    WHILE NOT EOLN (TTY) DO BEGIN
      READ (TTY,CH);
      STR := STR || CH;
    END;
    RESET (F,'.REL '||STR);
    IF EOF (F) THEN
      WRITELN (TTY,'Can''t open file ',STR)
    ELSE BEGIN
      WRITELN (TTY); BREAK;
      REPEAT
	COUNT := F^.RIGHT;
	IF F^.LEFT = 17B THEN BEGIN
	  GET (F);
	  FOR IX := 1 TO COUNT DIV 3 DO BEGIN
	    GET (F);
	    FNAME := F^;
	    GET (F);
	    UFD := F^;
	    GET (F);
	    IF F^.LEFT <> 0 THEN BEGIN
	      OUT (F^.ARR);
	      WRITE (TTY,':');
	    END;
	    OUT (FNAME.ARR);
	    IF UFD.INT <> 0 THEN WRITE (TTY,'[',UFD.LEFT:6:O,',',UFD.RIGHT:6:O,']');
	    WRITELN (TTY);
	  END;
	END
	ELSE BEGIN
	  FOR IX := 1 TO COUNT+1 DO
	    GET (F);
	END;
	GET (F);
      UNTIL EOF(F);
      WRITELN (TTY);
    END;
  END;
END.
  