
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 218*)
(*TEST 6.7.2.2-6, CLASS=ERRORHANDLING*)
(* This program causes an error to occur as the result of a binary
  integer operation is not in the interval 0 -> +maxint. *)
program t6p7p2p2d6;
var
   i : integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #218');
   i:=(maximum(integer)-(maximum(integer) div 2))*2+2;
   writeln(' ERROR NOT DETECTED...6.7.2.2-6')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   