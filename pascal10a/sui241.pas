
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 241*)
(*TEST 6.8.3.5-1, CLASS=CONFORMANCE*)
(* This test checks that a minimal case statement will compile.
  The compiler fails if the program does not compile. *)
program t6p8p3p5d1;
var
   i:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #241');
   i:=1;
   case i of
   1:
   end;
   writeln(' PASS...6.8.3.5-1, CASE');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 