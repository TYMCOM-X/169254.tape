program iots43;

var
  f: text;
  userfn, pathfn: string[100];

begin
  open (tty); rewrite (ttyoutput);
  loop
    write (tty, 'File: '); break (tty); readln (tty);
    read (tty, userfn);
  exit if userfn = '';
    open (f, userfn);
    pathfn := filename (f);
    writeln (tty, '(', userfn, ') opened as (', pathfn, ').');
    close (f)
  end
end.
 