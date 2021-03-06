
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 186*)
(*TEST 6.6.6.2-1, CLASS=CONFORMANCE*)
(* This program tests the implementation of the arithmetic
  function abs. Both real and integer expressions are used.
  The compiler fails if the program does not compile and run. *)
program t6p6p6p2d1;
const
   pi = 3.1415926;
var
   i, counter : integer;
   r : real;
function myabs1(i : integer):integer;
   begin
      if i<0 then
         myabs1:=-i
      else
         myabs1:=i
   end;
function myabs2(r:real):real;
   begin

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      if r<0 then
         myabs2:=-r
      else
         myabs2:=r
   end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #186');
   counter:=0;
   for i:=-10 to 10 do
   begin
      if abs(i)=myabs1(i) then
         counter:=counter+1
   end;
   r:=-10.3;
   while r<10.3 do
   begin
      if abs(r)=myabs2(r) then
         counter:=counter+1;
      r:=r+0.9
   end;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   if counter=44 then
      writeln(' PASS...6.6.6.2-1')
   else
      writeln(' FAIL...6.6.6.2-1:ABS')
end.
   