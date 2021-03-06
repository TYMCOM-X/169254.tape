$PAGE globals
program rats options debug;
const
   input_length = 160;

type
   input_string = string[input_length];

var
   continue_flag : boolean;

   input_line : input_string;
$PAGE initialize
procedure initialize;
begin
   open(tty);
   rewrite(tty);
   continue_flag:=true;
end;
$PAGE process_command
procedure process_command;
begin
   write(tty,'Command: ');
   break(tty);
   readln(tty);
   read(tty,input_line);
   if length(input_line)<>4 then
      writeln(tty,input_line)
   else
      if input_line<>'stop' then
         writeln(tty,input_line)
      else
         continue_flag:=false;
end;
$PAGE main
begin
   initialize;
   while continue_flag do
   begin
      process_command;
   end;
end.
  