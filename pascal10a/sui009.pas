
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number   9*)
(*TEST 6.1.5-2, CLASS=CONFORMANCE*)
(* This program simply tests if very long numbers are permitted.
  The value should be representable despite its length. *)
program t6p1p5d2;
const
   reel = 123.456789012345678901234567890123456789;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #009');
   writeln(' PASS...6.1.5-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 