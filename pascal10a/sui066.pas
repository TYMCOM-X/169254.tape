
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  66*)
(*TEST 6.4.2.2-7, CLASS=IMPLEMENTATIONDEFINED*)
(* The Pascal Standard states that the value of maxint is
  dependent on the implementation.
  This program prints out the implementation defined value
  of maxint. *)
program t6p4p2p2d7;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #066');
   writeln(' THE IMPLEMENTATION DEFINED VALUE OF MAXINT IS ',
            maximum(integer))
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   