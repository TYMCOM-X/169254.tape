module test58 options dump;

type
  snf = packed array[1..10] of char;
  sff = packed array[1..*] of char;
  snv = string [10];
  sfv = string [*] ;

external procedure p1 (var a: snf);
external procedure p2 (var a: sff);
external procedure p3 (var a: snv);
external procedure p4 (var a: sfv);


public procedure test (var v1: snf; var v2: sff; var v3: snv; var v4: sfv);
begin
  p1 (v1);
  p1 (v2);
  p1 (v3);
  p1 (v4);

  p2 (v1);
  p2 (v2);
  p2 (v3);
  p2 (v4);

  p3 (v1);
  p3 (v2);
  p3 (v3);
  p3 (v4);

  p4 (v1);
  p4 (v2);
  p4 (v3);
  p4 (v4);
end.
  