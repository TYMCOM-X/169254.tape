
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 210*)
(*TEST 6.6.6.5-3, CLASS=DEVIANCE*)
(* This test checks that the function odd is restricted to
  integer parameters. Ths compiler deviates if the program compiles
  and prints DEVIATES. *)
program t6p6p6p5d3;
var
   x:real;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #210');
   x:=1.0;
   if odd(x) then
      writeln(' DEVIATES...6.6.6.5-3, REAL ODD')
   else
      writeln(' DEVIATES...6.6.6.5-3, MESS')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   