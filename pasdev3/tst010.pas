(* TST010 - real and integer arithemetic.  *)

program tst010;

var
  i,j,k: integer;
  x,y,z: real;
  dx,dy,dz: minimum(real).. maximum(real) prec 14;

begin
  i := -j + abs ( k );
  i := j mod k;
  i := j mod 3;
  i := 3 mod j;
  i := -j mod k;
  i := (i mod j) mod -k;
  i := j mod (k + 1);
  x := abs ( y );
  x := abs ( k );
  x := abs ( dx );
  dx := -abs ( z );
  x := -dx;
  dx := -x;
  i := i - 1;
  i := i + 1;
  i := i + (j div k);
  i := (i - j) + k;
  i := ( (i - j) * (k div i) ) - (-j);
  x := (x + y) / (dx * z);
  dx := (x - y) / (-dx + dy) * (dz * z);
  x := x * y;
  x := x * (y + 1);
  x := -x * y;
  dx := -dy * y;
end.
    