$header ecdtim.hdr

$INCLUDE DTIME.TYP

EXTERNAL PROCEDURE EC_DATE(VAR DTIME_ERR;DATEREC;
   VAR DATE_INT);
EXTERNAL PROCEDURE EC_TIME(VAR DTIME_ERR; TIMEREC;
   VAR TIME_INT);
EXTERNAL FUNCTION DT_COMBINE(DATE_INT;TIME_INT):DTIME_INT;

PUBLIC PROCEDURE EC_DTIME(VAR ERR_CODE: DTIME_ERR;
   DTIMEBIN: DTIMEREC; VAR DTIME: DTIME_INT);

VAR
   DATE_BIN: DATEREC;
   TIME_BIN: TIMEREC;
   DATE: DATE_INT;
   TIME: TIME_INT;

BEGIN

   WITH DTIMEBIN DO

   BEGIN

      DATE_BIN.YEAR := YEAR;
      DATE_BIN.MONTH := MONTH;
      DATE_BIN.DAY := DAY;

      EC_DATE(ERR_CODE, DATE_BIN, DATE);
  
      IF ERR_CODE = DT_NOERR THEN

      BEGIN
         TIME_BIN.HOURS := HOURS;
         TIME_BIN.MINS := MINS;
         TIME_BIN.SECS := SECS;

         EC_TIME(ERR_CODE,TIME_BIN, TIME);

         IF ERR_CODE = DT_NOERR THEN
            DTIME := DT_COMBINE(DATE,TIME)
      END

   END (* WITH *)

END.
 