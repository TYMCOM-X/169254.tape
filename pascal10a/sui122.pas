
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 122*)
(*TEST 6.4.6-5, CLASS=ERRORHANDLING*)
(* This program is similar to 6.4.6-4, except that parameter
  assignment compatibility is tested.
  The program causes an error to occur which should be detected. *)
program t6p4p6d5;
type
   subrange = 0..5;
var
   i : subrange;
procedure test(a : subrange);
begin
   a:=5
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #122');
   i:=5;
   test(i*2);      (* error *)
   writeln(' ERROR NOT DETECTED...6.4.6-5')
end.
  