program iots21;

var
  f, g: text;
  i: -10000..10000;

begin
  open (f, 'TTY:');
  rewrite (g, 'TTY:');

  loop
    read (f, i);
  exit if i = 0;
    writeln (g, i);
    break (g)
  end
end.
 