program iots32;

var
  f, g, thing: text;
  chars, lines: -1..1000000;
  filename: string[50];

begin
  open (f, 'tty:'); rewrite (g, 'tty:');
  write (g, 'Enter file name to count: '); break (g); readln (f);
  filename := '';
  while not eoln (f) do begin
    filename := filename || f^;
    get (f)
    end;
  open (thing, filename);
  if eof (thing) then writeln (g, 'Can''t get it.')
  else begin
    chars := 0; lines := 0; get (thing);
    repeat
      while not eoln (thing) do begin
	get (thing);
	chars := chars + 1
	end;
      lines := lines + 1;
      readln (thing)
    until eof (thing);
    close (thing);
    writeln (g, 'Total of ', chars, ' characters in ', lines, ' lines.')
    end
end.
   