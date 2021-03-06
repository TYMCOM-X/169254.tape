program invert;

var
  f, g: text;
  h, j: file of *;
  i, len: integer;
  filename: string[60];
  unit: integer;
  temprec: array [1..128] of integer;


begin
  open (f, 'tty:'); rewrite (g, 'tty:');
  write (g, 'File to invert: '); break (g); readln (f);
  read (f, filename);
  reset (h, filename, [seekok]);
  write (g, 'Output: '); break (g); readln (f);
  read (f, filename);
  rewrite (j, filename);
  write (g, 'Unit size: '); break (g); readln (f);
  read (f, unit);
  if unit > 128 then begin
    writeln (g, 'Unit too big, operation cancelled.');
    stop
    end;
  len := extent (h) - unit + 1;
  repeat
    seek (h, len); read (h, temprec: unit);
    write (j, temprec: unit); len := len - unit;
  until len <= 0;
  close
end.
  