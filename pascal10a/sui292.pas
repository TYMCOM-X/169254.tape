
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 292*)
(*TEST 6.9.2-5, CLASS=ERRORHANDLING*)
(* This test checks that an error is produced when an attempt
  is made to read a real but the sequence of characters
  on the input file does not form a valid real. *)
program t6p9p2d5;
var
   f:text;
   r:real;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #292');
   rewrite(f);
   writeln(f,'ABC123.456');
   reset(f);
   read(f,r);      (*should cause an error*)
   writeln(' ERROR NOT DETECTED...6.9.2-5');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    