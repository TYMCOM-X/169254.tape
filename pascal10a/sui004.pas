
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number   4*)
(*TEST 6.1.2-3, CLASS=CONFORMANCE*)
(* This test checks the implementation of identifiers
  and reserved words to see that the two are correctly distinguished.
  The compiler fails if the program does not compile and
  print PASS. *)
program t6p1p2d3;
var
   procedurex,procedurf,procedur:char;
   functionx,functiom,functio:integer;
   iffy:boolean;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #004');
   procedurex:='0';
   procedurf:='1';
   procedur:='2';
   functionx:=0;
   functiom:=1;
   functio:=2;
   iffy:=true;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   writeln(' PASS...6.1.2-3, IDENTIFIERS')
end.
  