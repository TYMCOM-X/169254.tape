program test54 options dump;

  condition cproc (b: boolean);
  condition cfunc (s: string): char;

  var c: char;

begin
  cproc (2);
  c := cfunc ('message');
end.
   