program bomb;

var
  file_var : text;
  int_var : 0 .. 2 ** 32 - 1;

begin
  reset (file_var, 'JUNK.TMP');
  readln (file_var, int_var:8:h);
end.
    