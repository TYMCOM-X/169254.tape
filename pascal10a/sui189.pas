
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 189*)
(*TEST 6.6.6.2-4, CLASS=ERRORHANDLING*)
(* This program causes an error to occur as an expression
  with a negative value is used as an argument for the
  arithmetic function ln.
  The error should be detected at run-time. *)
program t6p6p6p2d4;
var
   m : real;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #189');
   m:=-2.71828;
   m:=ln(m*2);
   writeln(' ERROR NOT DETECTED...6.6.6.2-4')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   