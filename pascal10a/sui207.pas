
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 207*)
(*TEST 6.6.6.4-7, CLASS=ERRORHANDLING*)
(* This test evokes an error by pushing chr past the
  limits of the char type. It assumes that no char type has more
  than 10000+ord('0') values. *)
program t6p6p6p4d7;
var
   i:0..10000;
   c:char;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #207');
   for i:=0 to 10000 do
      c:=chr(i+ord('0'));
   writeln(' ERROR NOT DETECTED...6.6.6.4-7, CHR')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 