program iots49;

var
  f: text;
  fn: string[100];
  st, xt: integer;

begin
  open (tty); rewrite (ttyoutput);
  loop
    write (tty, 'File: '); break (tty); readln (tty);
    read (tty, fn);
  exit if length (fn) = 0;
    open (f, fn, [retry]);
    st := ord (iostatus (f));
    if st = 0 then writeln (tty, 'Got ', filename (f), ' open.')
    else begin
      xt := extstatus;
      writeln (tty, 'Error ', st:0, ' status ', xt:0)
      end;
    close (f)
  end
end.
  