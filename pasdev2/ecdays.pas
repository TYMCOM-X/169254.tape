module ec_days
  options nolibrary;

$header ecdays.hdr

$SYSTEM idtime.typ

public function ec_days ( days_since_base: days ): date_int;

begin
  ec_days.d := days_since_base;
  ec_days.t := 0;
end.
  