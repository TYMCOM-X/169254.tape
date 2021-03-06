
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 136*)
(*TEST 6.5.4-2, CLASS=ERRORHANDLING*)
(* Similarly to 6.5.4-1, an error occurs if a pointer variable
  has an undefined value when it is dereferenced. *)
program t6p5p4d2;
type
   rekord = record
               a : integer;
               b : boolean
            end;
var
   pointer : ^rekord;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #136');
   pointer^.a:=1;
   pointer^.b:=true;
   writeln(' ERROR NOT DETECTED...6.5.4-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   