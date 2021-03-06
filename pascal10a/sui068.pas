
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  68*)
(*TEST 6.4.2.3-2, CLASS=CONFORMANCE*)
(* The Pascal Standard states that the ordering of the values
  of the enumerated type is determined by the sequence in which
  the constants are listed, the first being before the last.
  The compiler fails if the program does not compile. *)
program t6p4p2p3d2;
var
   suit : (club,spade,diamond,heart);
   a    : boolean;
   b    : boolean;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #068');
   a:=(succ(club)=spade) and
      (succ(spade)=diamond) and
      (succ(diamond)=heart);
   b:=(club < spade) and
      (spade < diamond) and
      (diamond < heart);
   if a and b then

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      writeln(' PASS...6.4.2.3-2')
   else
      writeln(' FAIL...6.4.2.3-2')
end.
  