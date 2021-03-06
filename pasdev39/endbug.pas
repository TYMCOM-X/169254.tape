program endbug;

(* PCR 362 says

      When EOF is true, EOLN should be false, in order to be consistent
   with the documentation, and with the Pascal implementation on the M68000.
   On TYMSHARE and the VAX, EOLN retruns TRUE when EOF is TRUE.

   This program is a testbed for finding that error. *)

var
  f : text;

begin
rewrite (f, 'test.tmp');
rewrite (ttyoutput);

writeln (f, 'now is the time');
writeln (f, 'for all good men');
close (f);
reset (f, 'test.tmp');
while not EOF (f) do
  begin
  while not EOLN (f) do
    begin
    write (ttyoutput, f^);
    get (f);
    end;
  writeln (ttyoutput);
  writeln (ttyoutput, 'EOLN = ', EOLN (f));
  break (tty);
  get (f);
  end;
writeln (ttyoutput, 'EOLN = ', EOLN (f), ', EOF = ', EOF (f));
end.
 