program dag002;

var
    i, j, k: integer;
    p, q, r: ^ integer;

begin
  p^ := i;
  q := p;
  j := p^;
  k := q^;
  r^ := 1;
  i := p^;
end.
  