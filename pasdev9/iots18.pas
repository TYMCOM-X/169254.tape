program iots18;

var
  f, g: text;
  i: -10000..10000;
  s: string[200];

begin
  open (f, 'tty:');
  rewrite (g, 'tty:');

  loop
    write (g, 'enter string:');
    break (g); readln (f);  read (f, s);
writeln (g, '[', s, ']');
  exit if s = '';
    getstring (s, i:10);
    writeln (g, 'FW=10, i= ', i);
    getstring (s, i: 3);
    writeln (g, 'FW=3,  i= ', i);
    getstring (s, i);
    writeln (g, 'NO FW, i= ', i)
  end
end.
    