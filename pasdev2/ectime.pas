MODULE ECTIME
  OPTIONS NOLIBRARY;

$HEADER ECTIME.HDR[31024,320220]

$SYSTEM IDTIME.TYP
$SYSTEM DTIMEI.INC[31024,320156]

PUBLIC PROCEDURE EC_TIME(VAR ERR_CODE: DTIME_ERR;
   TIME_BIN: TIMEREC;  VAR TIME: TIME_INT);

CONST
   SECS_PER_DAY = 86400;

VAR
   TIME_SECS: INTEGER;

BEGIN
   WITH TIME_BIN DO
   BEGIN
      IF (HOURS < 0) ORIF
         (HOURS > 23) ORIF
         (MINS < 0) ORIF
         (MINS > 59) ORIF
         (SECS < 0) ORIF
         (SECS > 59)
      THEN ERR_CODE := DT_ERR

      ELSE

      BEGIN
         ERR_CODE := DT_NOERR;
         TIME_SECS := HOURS * 3600 + MINS * 60 + SECS;
	 TIME := EC_SECS ( TIME_SECS );
      END

   END (* WITH *)

END.
    