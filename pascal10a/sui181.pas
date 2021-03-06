
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 181*)
(*TEST 6.6.5.3-7, CLASS=ERRORHANDLING*)
(* This program causes an error to occur, as a variable
  created by the use of the variant form of new is used
  as an operand in an expression.
  The error should be detected by the compiler, or at
  run-time. *)
program t6p6p5p3d7;
type
   two      = (a,b);
   rekord   = record
               case tagfield:two of
                  a : (m : boolean);
                  b : (n : char)
              end;
var
   ptr      : ^rekord;
   r        : rekord;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #181');

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   new(ptr,a);
   ptr^.m:=true;
   r:=ptr^;
   writeln(' ERROR NOT DETECTED...6.6.5.3-7')
end.
  