program iots44;

var
  s: string[200];

begin
  reset (input);
  rewrite (output);

  while not eof do begin
    read (s);  writeln (s);
    readln 
    end;
end.
   