
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 291*)
(*TEST 6.9.2-4, CLASS=ERRORHANDLING*)
(* This test checks that an error is produced when an attempt
  is made to read an integer but the sequence of characters
  on the input file does not form a valid signed integer. *)
program t6p9p2d4;
var
   f:text;
   i:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #291');
   rewrite(f);
   writeln(f,'ABC123');
   reset(f);
   read(f,i);      (*should cause an error*)
   writeln(' ERROR NOT DETECTED...6.9.2-4');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 