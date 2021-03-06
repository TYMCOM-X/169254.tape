program tstsqt;
var
  short, delta, long: real;
  x: real;
  y, z : minimum(real)..maximum(real) prec 16;
begin
  rewrite (tty); open (tty);
  loop begin
    write (tty,'SQRT of: '); break; readln (tty);
    read (tty,x);
    y := x;
    short := sqrt (x);
    z := sqrt (y);
    long := z;
    delta := short - long;
    writeln (tty);
    writeln (tty,'SQRT (',x,') = ',short,' (single), ',long,' (double)');
    writeln (tty);
    writeln (tty,'Delta = ',delta);
    exception
      math_error:
	exception_message;
  end end;
end.
  