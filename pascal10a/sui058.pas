
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  58*)
(*TEST 6.4.1-2, CLASS=DEVIANCE*)
(* This program tests that attempts to use types in their
  own definitions are detected.  Two examples are
  attempted. Both should fail. *)
program t6p4p1d2;
type
   x  = record
            xx : x
        end;
   y  = array[0..1] of y;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #058');
   writeln(' DEVIATES...6.4.1-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   