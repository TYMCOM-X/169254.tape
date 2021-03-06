
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 173*)
(*TEST 6.6.5.2-6, CLASS=ERRORHANDLING*)
(* This program causes an error to occur by changing the
  current file position of a file f, while the buffer
  variable is an actual parameter to a procedure.
  The error should be detected by the compiler, or at
  run-time. *)
program t6p6p5p2d6;
var
   fyle : text;
procedure naughty(f : char);
   begin
      if f='G' then
         put(fyle)
   end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #173');
   rewrite(fyle);
   fyle^:='G';
   naughty(fyle^);

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   writeln(' ERROR NOT DETECTED...6.6.5.2-6')
end.
   