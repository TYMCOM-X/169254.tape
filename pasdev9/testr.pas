program test;
type dreal = minimum(real)..maximum(real) prec 16;
var r: dreal;
external function hexreal (dreal): string;
begin
  rewrite (tty); open (tty);
  loop
    write (tty,'# '); break; readln (tty);
  exit if eoln (tty);
    read (tty,r);
    writeln (tty,hexreal (r));
  end;
end.
  