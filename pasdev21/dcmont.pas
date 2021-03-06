$header dcmont.hdr

TYPE
   MONTH_IDX = 1..12;
   EXT_MONTH = STRING[3];


PUBLIC FUNCTION DC_MONTH(MTH: MONTH_IDX): EXT_MONTH;

TYPE
   EXT_MTH_TAB = ARRAY [1..12] OF EXT_MONTH;

CONST
   MONTH_TAB: EXT_MTH_TAB := ('Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' );


BEGIN
   IF (MTH < 1) OR (MTH > 12) THEN
      DC_MONTH := ''
   ELSE DC_MONTH := MONTH_TAB[MTH]

END.
    