(* TST004 - intrinsic functions RANDOM, DATE and TIME.  *)

program tst004;
var
  s: string;
  f: text;
  date_string: string[ 9 ];
  x: real;
  dx: 0.0..1.0 prec 16;
  dy: 0..1.0 prec 16;
  i: integer;
begin
  date_string := date;
  i := time;
  i := runtime;
  dx := random ( dx );
  x := random ();
  dx := random ();
  x := random ( x );
  x := random ( dx );
  s := filename ( f );
end.
 