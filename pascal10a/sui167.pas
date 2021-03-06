
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 167*)
(*TEST 6.6.4.1-1, CLASS=CONFORMANCE*)
(* This program tests that predefined standard procedures may
  be redefined with no conflict.
  The compiler fails if the program does not compile and run. *)
program t6p6p4p1d1;
var
   i : integer;
procedure write(var a : integer);
   begin
      a:=a+2
   end;
procedure get(var a : integer);
   begin
      a:=a*2
   end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #167');
   i:=0;
   write(i);

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   get(i);
   if i=4 then
      writeln(' PASS...6.6.4.1-1')
   else
      writeln(' FAIL...6.6.4.1-1')
end.
  