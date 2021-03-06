program hpdump;

type
  foo = ^ ech;
  ech = record
    data: string[10];
    next: foo
    end;

var
  head, temp: foo;

external function hpload
( string [10] ): foo;

begin
  rewrite (ttyoutput);
  head := hpload ('###ECH.ECH');
  temp := head;
  while temp <> nil do begin
    write (tty, 'Pointer val = ', ord (temp):6:o, '     ');
    writeln (tty, '[', temp^.data, ']');
    temp := temp^.next
    end
end.
 