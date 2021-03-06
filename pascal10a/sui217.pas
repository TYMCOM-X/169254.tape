
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 217*)
(*TEST 6.7.2.2-5, CLASS=CONFORMANCE*)
(* This program checks that maxint satisfies the conditions laid
  down in the Pascal Standard.
  The compiler fails if the program does not compile, or does
  not print pass. *)
program t6p7p2p2d5;
var
   i : integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #217');
   i:=-(-maximum(integer));
   i:=-maximum(integer);
   if odd(maximum(integer)) then
      i:=(maximum(integer)-((maximum(integer) div 2)+1))*2
   else
      i:=(maximum(integer)-(maximum(integer) div 2))*2;
   if i<=maximum(integer) then
      writeln(' PASS...6.7.2.2-5')
   else

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      writeln(' FAIL...6.7.2.2-5: MAXINT')
end.
   