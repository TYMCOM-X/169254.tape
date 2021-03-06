
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  78*)
(*TEST 6.4.3.2-4, CLASS=QUALITY*)
(* As mentioned in 6.4.3.2-3, an index type is an ordinal type,
  thus INTEGER may appear as an index type. However on most
  machines this would represent an unusually large array, and
  thus may not be allowed by the compiler.
  This program tests if such a declaration is permitted, and if
  not, is the diagnostic appropriate. *)
program t6p4p3p2d4;
type
   everything = array[integer] of integer;
var
   all   : everything;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #078');
   all[maximum(integer)]:=1;
   all[0]:=1;
   all[-maximum(integer)]:=1;
   writeln(' QUALITY...6.4.3.2-4: -->INTEGER BOUNDS PERMITTED')
end.
    