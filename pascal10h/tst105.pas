program tst105;
 var a: array[4..12] of integer;
 var i, j: 0..30;
 var p: ^ integer;
 var c: char;
 var s: packed array[1..40] of char;
 var pa: packed array [6..15] of 0..77B;
 var b: packed record
	  f1: 0..777777B;
	  f2: -4..6;
	  f3: boolean;
	  f4: 1..5
	end;
 begin
  a[i] := i + j;
  i := a[i+2];
  a[i+6] := i + j;
  j := b.f1;
  a[4] := b.f2;
  a[5] := b.f4;
  b.f1 := 23B;
  b.f2 := j + 2;
  a[j+3] := p^;
  p^ := 3;
  c := s[j];
  pa [i+j] := pa[j];
 end.
    