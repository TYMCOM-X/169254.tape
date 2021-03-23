$OPTIONS NOCHECK

$LENGTH 44

PROGRAM CALLS2;

(*      This package summarizes the data collected by the STATS facility
	in PASCAL.TMP, producing a listing of procedures and statistics
	in CALLS.LST.                                                   *)

$INCLUDE RND:STATS.INC

TYPE
    INTEGER = -377777777777B..377777777777B; (* FULL 36-BIT WORD *)
    HALFWORD= 0..777777B; (* 18-BIT HALFWORD *)
    PROC_PTR = ^PROC_RECORD;
    PROC_RECORD = PACKED RECORD (* ONE FOR EACH PROCEDURE NAME ENCOUNTERED *)
      PROC_NAME: ALFA; (* TEN CHARACTER ASCII *)
      LEFT, RIGHT: PROC_PTR; (* UNBALANCED BINARY TREE *)
      ADDRESS: HALFWORD; (* OF ENTRY POINT TO PROCEDURE *)
      TIMES_CALLED: HALFWORD;
      ACTIVE_CALLS: HALFWORD;
      INTERNAL_CALLS: HALFWORD; (* NUMBER OF PROCEDURE CALLS WHILE THIS ONE ACTIVE *)
      NET_TIME: INTEGER; (* TIME ONLY IN THIS ROUTINE *)
      HOLD_TIME: INTEGER (* TOTAL TIME IN ROUTINE, INCLUDING INTERNAL CALLS *)
    END;
    LINK_PTR = ^LINK_RECORD;
    LINK_RECORD= PACKED RECORD (* LINKS "ACTIVE" ROUTINES *)
      PREVIOUS: ^LINK_RECORD; (* SINGLY LINKED LIST *)
      CALL_COUNT: INTEGER; (* TRACK NUMBER OF PROCEDURE CALLS *)
      THIS_PROC: PROC_PTR (* INDICATES PROCEDURE CALLED *)
    END;

CONST
    VERSION_NUMBER := '1.0';
    NO_FILE := '?Can''t find statistics file PASCAL.TMP';
    HEADER :=
      'Procedure  Address  Calls  Net stmts  %    Gross stmts  %   Internal calls'
	;
    NEST_MAX := '  Max nesting of procedure calls = ';
    MIN_INTERVAL := '  Min recorded clock interval = ';
    MAX_INTERVAL := '  Max recorded clock interval = ';





VAR
    STATFILE: FILE OF STATRECORD;
    PROC: PROC_PTR; (* INDICATES SYMBOL TABLE ENTRY FOR CURRENT PROCEDURE *)
    LOC: INTEGER; (* TEMP ADDRESS *)
    NESTING_LEVEL: INTEGER; (* DEPTH OF CALLS *)
    MAX_NESTING_LEVEL: INTEGER; (* MAX DEPTH *)
    PREV_TIME: INTEGER; (* PREVIOUS TIMER VALUE *)
    MIN_CLOCK_INTERVAL, MAX_CLOCK_INTERVAL: INTEGER;
    TOTAL_TIME: INTEGER; (* DELTA OF LAST AND FIRST TIMER VALUES *)
    FIRST_PULSE: INTEGER; (* FIRST TIMER VALUE READ *)
    LAST_PULSE: INTEGER; (* LAST TIMER VALUE *)
    LINK: LINK_PTR; (* USED IN PROCESSING LINK_RECORD CHAIN *)
    CURRENT_PROC: LINK_PTR; (* INDICATES LINK RECORD FOR CURRENT ROUTINE *)
    PROC_COUNT: INTEGER; (* NUMBER OF DISTINCT PROCEDURES ENCOUNTERED *)
    TOTAL_CALLS: INTEGER; (* TOTAL NUMBER OF CALLS *)
    PROC_TIME: INTEGER; (* TIME SPENT IN ALL ROUTINES *)
    HEAD: PROC_PTR; (* HEAD OF SYMBOL TABLE TREE*)
    NEW_PROC: PROC_PTR; (* TEMP *)





PROCEDURE INITIALIZE;

BEGIN
  MAX_NESTING_LEVEL := 0;
  NESTING_LEVEL := 0;
  PREV_TIME := 0;
  MIN_CLOCK_INTERVAL := MAXIMUM(INTEGER);
  MAX_CLOCK_INTERVAL := MINIMUM(INTEGER);
  CURRENT_PROC := NIL;
  PROC_COUNT := 0;
  TOTAL_CALLS := 0;
  PROC_TIME := 0;
  HEAD := NIL;
END;

FUNCTION WIDTH (I: INTEGER): INTEGER;

(*      Returns the minimum number of character positions required
	to print I      *)




VAR
    VALUE: INTEGER;

BEGIN
  IF I < 0 THEN BEGIN
    WIDTH := 1;
    VALUE := -I;
  END
  ELSE BEGIN
    WIDTH := 0;
    VALUE := I;
  END;
  REPEAT
    VALUE := VALUE DIV 10;
    WIDTH := WIDTH + 1;
  UNTIL VALUE = 0;
END;

FUNCTION FIND_NAME(ADDR: INTEGER): BOOLEAN;

(*      Searches the symbol table for the name just read from STATFILE *)




VAR
    LAST_PROC: PROC_PTR;

BEGIN
  LAST_PROC := HEAD;
  PROC := HEAD;
  FIND_NAME := FALSE;
  WITH STATFILE^ DO
    WHILE (PROC <> NIL) AND NOT FIND_NAME DO
      WITH PROC^ DO BEGIN
	LAST_PROC := PROC;
        IF (PROC_NAME = NAME) ANDIF (ADDR = ADDRESS) THEN
	  FIND_NAME := TRUE
	ELSE IF NAME < PROC_NAME THEN
	  PROC := LEFT
	ELSE
	  PROC := RIGHT;
      END;
  IF NOT FIND_NAME THEN
    PROC := LAST_PROC;
END;

PROCEDURE TABLE (ENTRY: PROC_PTR);

BEGIN
  IF ENTRY <> NIL THEN BEGIN
    IF ENTRY^.LEFT <> NIL THEN
      TABLE (ENTRY^.LEFT); (* PRINT LOWER NAMES FIRST *)
    WITH ENTRY^ DO BEGIN
      WRITE (PROC_NAME,'  ',ADDRESS:6:O,TIMES_CALLED:6,'  ');
      TOTAL_CALLS := TOTAL_CALLS + TIMES_CALLED;
      PROC_TIME := PROC_TIME + HOLD_TIME;
      IF HOLD_TIME > 0 THEN BEGIN
	WRITE (HOLD_TIME:8);
	WRITE (' ',HOLD_TIME*100.0/TOTAL_TIME:5:1,'%')
      END
      ELSE
	WRITE (' ':15);
      IF NET_TIME > 0 THEN BEGIN
	WRITE ('   ',NET_TIME:8);
	WRITE (' ',NET_TIME*100.0/TOTAL_TIME:5:1,'%');
      END
      ELSE
	WRITE (' ':18);
      WRITELN (INTERNAL_CALLS:9);
      PROC_COUNT := PROC_COUNT + 1;
    END;
    IF ENTRY^.RIGHT <> NIL THEN
      TABLE (ENTRY^.RIGHT);
  END;
END;

PROCEDURE CHECK_TIME;

BEGIN
  WITH STATFILE^ DO BEGIN
    IF PREV_TIME <> 0 THEN BEGIN (* IF NOT THE FIRST TIMER VALUE READ *)
      IF TIMER - PREV_TIME < MIN_CLOCK_INTERVAL THEN
	MIN_CLOCK_INTERVAL := TIMER - PREV_TIME
      ELSE IF TIMER - PREV_TIME > MAX_CLOCK_INTERVAL THEN
	MAX_CLOCK_INTERVAL := TIMER - PREV_TIME;
    END
    ELSE
      FIRST_PULSE := TIMER;
    PREV_TIME := TIMER;
  END;
END;

BEGIN
  REWRITE (TTY);
  WRITELN (TTY);
  WRITELN (TTY,'CALLS2 Version ',VERSION_NUMBER);
  BREAK;
  RESET (STATFILE,'PASCAL.TMP');
  IF NOT EOF (STATFILE) THEN BEGIN
    WRITELN (TTY);
    BREAK;
    INITIALIZE;
    REWRITE (OUTPUT,'CALLS.LST');
    REPEAT
      WITH STATFILE^ DO BEGIN
	IF WHAT IN [CALLING,RETURNING] THEN BEGIN
          IF WHAT = RETURNING THEN PROC := CURRENT_PROC^.THIS_PROC
          ELSE IF NOT FIND_NAME(LOCATION) THEN BEGIN
	    NEW (NEW_PROC); (* NOT PREVIOUSLY ENCOUNTERED *)
	    IF HEAD = NIL THEN
	      HEAD := NEW_PROC
	    ELSE IF NAME < PROC^.PROC_NAME THEN
	      PROC^.LEFT := NEW_PROC
	    ELSE
	      PROC^.RIGHT := NEW_PROC;
	    WITH NEW_PROC^ DO BEGIN
	      PROC_NAME := NAME;
	      LEFT := NIL;
	      RIGHT := NIL;
	      ADDRESS := LOCATION;
	      TIMES_CALLED := 0;
	      ACTIVE_CALLS := 0;
	      NET_TIME := 0;
	      INTERNAL_CALLS := 0;
	      HOLD_TIME := 0;
	    END;
	    PROC := NEW_PROC;
	  END; (* IF NOT FIND_NAME *)
	  WITH PROC^ DO BEGIN
	    CHECK_TIME;
	    CASE WHAT OF
	      CALLING: BEGIN
		NESTING_LEVEL := NESTING_LEVEL + 1;
		IF NESTING_LEVEL > MAX_NESTING_LEVEL THEN
		  MAX_NESTING_LEVEL := NESTING_LEVEL;
		TIMES_CALLED := TIMES_CALLED + 1;
		ACTIVE_CALLS := ACTIVE_CALLS + 1;
		NEW (LINK);
		WITH LINK^ DO BEGIN
		  PREVIOUS := CURRENT_PROC;
		  THIS_PROC := PROC;
		  CALL_COUNT := 0;
		END;
		IF CURRENT_PROC <> NIL THEN
		  WITH CURRENT_PROC^ DO
		    THIS_PROC^.HOLD_TIME := THIS_PROC^. HOLD_TIME+ TIMER;
		HOLD_TIME := HOLD_TIME - TIMER;
		CURRENT_PROC := LINK;
		IF ACTIVE_CALLS = 1 (* NOT RECURSING *)THEN
		  NET_TIME := NET_TIME - TIMER;
	      END;
	      RETURNING: BEGIN
		NESTING_LEVEL := NESTING_LEVEL - 1;
		ACTIVE_CALLS := ACTIVE_CALLS - 1;
		LAST_PULSE := TIMER;
		IF CURRENT_PROC = NIL THEN BEGIN
		  (* EXTRA RETURN? *)
		  WRITELN (TTY,' Warning: Missing "calling" record for ',
			NAME[1:INDEX(NAME,' ',11)-1]);
		  BREAK;
		END
		ELSE BEGIN
		  WITH CURRENT_PROC^ DO BEGIN
		    THIS_PROC^.HOLD_TIME := THIS_PROC^. HOLD_TIME+ TIMER;
		    IF ACTIVE_CALLS = 0 (* NOT RECURSING *)THEN BEGIN
		      THIS_PROC^.NET_TIME := THIS_PROC^. NET_TIME + TIMER;
		      THIS_PROC^.INTERNAL_CALLS := THIS_PROC^. INTERNAL_CALLS +
			CALL_COUNT;
		    END;
		    LINK := CURRENT_PROC;
		    CURRENT_PROC := PREVIOUS;
		  END;
		  IF CURRENT_PROC <> NIL THEN
		    WITH CURRENT_PROC^ DO BEGIN
		      THIS_PROC^.HOLD_TIME := THIS_PROC^ .HOLD_TIME -TIMER;
		      CALL_COUNT := CALL_COUNT + LINK^.CALL_COUNT+1;
		    END;
		  DISPOSE (LINK);
		END; (* IF CURRENT_PROC <> NIL *)
	      END (* CASE RETURNING *)
	    END; (* CASE WHAT OF *)
	  END; (* WITH PROC^ *)
	END (* IF WHAT IN [CALLING,RETURNING] *)
	ELSE
	  ; (* IGNORE OTHER CASES *)
      END; (* WITH STATFILE^ *)
      GET (STATFILE);
    UNTIL EOF (STATFILE);
    IF HEAD <> NIL THEN BEGIN
      WRITELN (HEADER);
      WRITELN;
      TOTAL_TIME := LAST_PULSE-FIRST_PULSE;
      TABLE (HEAD);
      WRITELN;
      IF CURRENT_PROC <> NIL THEN
	WRITELN (TTY,' Warning: Missing "return" records');
      WRITELN ('  ',PROC_COUNT:WIDTH(PROC_COUNT)
	,' procedures, ', TOTAL_CALLS:WIDTH(TOTAL_CALLS),' calls');
      WRITELN (TTY,'  ',PROC_COUNT:WIDTH(PROC_COUNT)
	,' procedures, ', TOTAL_CALLS:WIDTH(TOTAL_CALLS),' calls');
      WRITELN ('  ',TOTAL_TIME:8,
	' statements executed in procedures, ',TOTAL_TIME-PROC_TIME:8,
	  ' in MAIN');
      WRITELN (NEST_MAX,MAX_NESTING_LEVEL:WIDTH( MAX_NESTING_LEVEL) ,' deep');
      WRITELN (MIN_INTERVAL,MIN_CLOCK_INTERVAL:WIDTH( MIN_CLOCK_INTERVAL));
      WRITELN (MAX_INTERVAL,MAX_CLOCK_INTERVAL:WIDTH( MAX_CLOCK_INTERVAL));
    END;
  END (* IF NOT EOF(STATFILE) *)
  ELSE
    WRITELN (TTY,NO_FILE);
END.
   