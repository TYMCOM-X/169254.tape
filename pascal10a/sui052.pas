
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  52*)
(*TEST 6.3-2, CLASS=DEVIANCE*)
(* This program checks that signed chars are not permitted.
  Note that minus may have a worse effect than plus. *)
program t6p3d2;
const
   dot = '.';
   plusdot = + dot;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #052');
   writeln(' DEVIATES...6.3-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 