program runme;
var s: file_name;
a: boolean;
$INCLUDE RUN.INC[52250,220]
begin rewrite (ttyoutput); open (tty);
write (tty, 'File to run: '); break (tty); readln (tty);
read (tty, s); write (tty, 'Autorun? '); break (tty); readln (tty);
a := eoln (tty);
close;
run (s, a)
end.
  