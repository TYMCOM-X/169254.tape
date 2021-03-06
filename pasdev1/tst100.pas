program tst100;

 type color = (red, orange, yellow, green, blue, violet);
 type smallint = -32..31;

 var  a: array[orange..green, red..blue] of smallint;
 var  b: packed array [color] of smallint;
 var  q: packed array [2..7] of 1..5;

 var i: 0..31;
 var c1, c2: color;

 type flexrec =
   packed record
     field1, field2: 0..777777B;
     field3: smallint;
     arr: array[1..*] of smallint
   end;

 var p: ^ flexrec;

 procedure tester (var a: array[red..*] of smallint; b: packed array[*] of smallint);
 var c: color;
 begin
  i := dimension (a, 1);
  i := dimension (b, 1);

  for c := lowerbound (a, 1) to upperbound (a, 1) do begin
    a [c] := b [ord (c)];
  end;
 end;

begin
  a[color (i + 1 - 4), blue] := 14;
  b[c1] := a [c1,c2];
  q[i] := 3;

  i := pred (i);
  i := succ (i);

  i := i + 3;
  i := i - 3;

  i := i ** 4;
  i := i ** 7;

  i := ord (address (i));

  new (p, 27);
  i := p^.field1;
  i := p^.field2;
  i := p^.field3;
  i := upperbound (p^.arr, 1);
  i := lowerbound (p^.arr, 1);
  i := p^.arr [i+2];

  i := dimension (a,2);
end.
 