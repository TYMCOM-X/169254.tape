program djw;

external procedure test (carray:string [11]) options fortran;

var
  c: string [11];

begin
  test (c)
end.
   