program agg_ass;

var r1 : record x : integer; case b : boolean of
	true : ( y : char ); false : ( z : string [2] ) end;
    a1 : array [1..3] of integer;
    a2 : ^ array [1..*] of integer;
    i : integer;

begin
  r1 := (i, true, 'A');
  r1 := (i, false, 'B');
  a1 := (1, i, 1);
  a2^ := (i, 1, i);
end.
   