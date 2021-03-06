module extr_date;

$HEADER nst1.hdr

$SYSTEM idtime.typ

external function ec_days ( days ): date_int;
external function dc_days ( dtime_int ): days;	(* declare explicitly because DC_DAYS parameter *)
						(* is declared in DTIMEI.INC to be a DATE_INT *)

public function extr_date ( dtime: dtime_int ): date_int;

var
  num_days_since_base: days;

begin

  num_days_since_base := dc_days ( dtime );

  extr_date := ec_days ( num_days_since_base );

end.
  