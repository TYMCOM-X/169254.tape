
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 232*)
(*TEST 6.7.2.5-4, CLASS=DEVIANCE*)
(* Are relational operators permitted to concatenate?
  The compiler deviates if the program compiles and
  prints DEVIATES. *)
program t6p7p2p5d4;
var
   x,y,z:integer;
  b:boolean;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #232');
   x:=1;
   y:=2;
   z:=3;
   b:=(x<y<z);
   writeln(' DEVIATES...6.7.2.5-4, REL. OPS. ')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   