program iots29;

var
  f, g: text;
  i: -10000 .. 10000;

begin
  open (f, 'tty:');
  rewrite (g, 'tty:');
  repeat
    if eoln (f) then begin
      write (g, 'enter integer(s) :'); break (g); readln (f)
      end;
    read (f, i:6);
    writeln (g, '[', i, '] [', i:0, '] [', i:4, ']');
  until i = 0
end.
 