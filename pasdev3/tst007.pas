(* TST007 - round, float and trunc operations. *)

program tst007;

var
  i,j,k: integer;
  x,y,z: real;
  dx,dy,dz: minimum(real)..maximum(real) prec 14;

begin
  i := round ( x );
  z := round ( y, 3 );
  z := round ( z, i );
  i := round ( dx );
  x := round ( dx, j );
  x := round ( dx, 3 );
  dx := round ( z, k );

  x := i;
  x := dx;
  dx := i;
  dx := x;
  i := trunc ( x );
  i := trunc ( dx );
end.
    