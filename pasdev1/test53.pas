program test53 options dump;

  external var a: undef1;
  external var b: undef2;

  external procedure p1 (undef3; boolean);
  external procedure p2 (undef4; boolean);

  type p = ^ fortype;

  procedure inner;
   var x: p;
   var c: char;
   begin
     x := x;
     c := x^;
   end;

  type fortype = 'A'..'Z';

  var x: p; c: char;
  var bad1: undef4;
  var bad2: undef5;

begin
  x := x;
  c := x^;
  b := b;
  p2 ('a', false);
end.
   