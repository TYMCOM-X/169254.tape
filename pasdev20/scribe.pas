$LENGTH 43
$OPTIONS STORAGE=2400
PROGRAM SCRIBE;

$INCLUDE cmdutl.typ

EXTERNAL PROCEDURE DO_SCRIBE (LINE: CMDLINE);
EXTERNAL PROCEDURE PASSCC;

VAR
  LINE: CMDLINE;				(* input line *)
  CMDFILE: BOOLEAN;				(* tells whether to prompt for  command input *)
  CMDIN: TEXT;					(* for reading command lines *)

BEGIN
  PASSCC;					(* tell runtime to pass control characters *)

  OPEN (CMDIN, '###scr.tmp');			(* open input, check first for cmd file *)
  IF EOF (CMDIN) THEN BEGIN
    OPEN (CMDIN, 'tty:');
    CMDFILE := FALSE;				(* read commands from the terminal  *)
  END
  ELSE CMDFILE := TRUE;
  REWRITE (TTY); OPEN (TTY);			(* to handle explicit tty I/O *)
  IF NOT CMDFILE THEN				(*write version information*)
    WRITELN(TTY,'SCRIBE Version 3.1 ',COMPDATE);

  LOOP
    IF NOT CMDFILE THEN BEGIN			(* reading commands from the terminal *)
     WRITE (TTY, '*');
     BREAK
    END;
    READLN (CMDIN);				(* advance to next line of input *)
  EXIT IF EOLN (CMDIN) OR EOF (CMDIN);		(* blank line or end of file *)
    LINE := '';					(* get command line *)
    WHILE NOT EOLN (CMDIN) DO BEGIN
      LINE := LINE || CMDIN^;
      GET (CMDIN)
    END;
  EXIT IF LINE = '';				(* nonnull line, but all blank *)
    DO_SCRIBE (LINE)				(* interpret command line, and process *)
  END;

  IF CMDFILE THEN BEGIN				(* delete the command file *)
    REWRITE (CMDIN); CLOSE (CMDIN);
  END;
END.
  