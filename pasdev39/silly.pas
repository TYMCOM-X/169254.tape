program silly;

var
   sillyfile : file of string[80];
   sillyname : file_name;
   lineno : integer;

function readterm () : string [80];

begin
if eoln (tty) then readln (tty);
read (tty, readterm);
end;

begin;
open (tty); rewrite (ttyoutput);
write (ttyoutput, 'File name?');
break (ttyoutput);
sillyname := readterm;
reset (sillyfile, sillyname);
lineno := 1;
while not eof (sillyfile) do
   begin
   writeln (ttyoutput, lineno:5, '   ', sillyfile^);
   lineno := lineno + 1;
   get (sillyfile);
   end;
end.
   