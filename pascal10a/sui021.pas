
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  21*)
(*TEST 6.1.7-6, CLASS=DEVIANCE*)
(* Again, a character string is a constant of the type
      packed array[1..n] of char.
  This program tests that strings are not compatible
  with bounds other than 1..n.
  The compiler conforms if the program fails to compile. *)
program t6p1p7d6;
var
   string1 : packed array[1..4] of char;
   string2 : packed array[0..3] of char;
   string3 : packed array[2..5] of char;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #021');
   string1:='STR1';
   string2:='STR2';
   string3:='STR3';
   writeln(' DEVIATES...6.1.7-6')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    