program iotst5;

var
  f, g: text;

begin
  open (f, 'FOO.INP');
  get (f);
  rewrite (g, 'FOO.OUT');

  while not eof (f) do begin
    while not eoln (f) do begin
      g^ := f^;
      get (f);
      put (g)
      end;
    writeln (g);
    if eopage (f) then page (g);
    readln (f)
    end;
  close (f);
  close (g);
  rewrite (f, 'TTY:');
  f^ := '&';
  put (f);
  close (f)
end.
    