
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 309*)
(*TEST 6.9.5-1, CLASS=CONFORMANCE*)
(* This program checks the implementation of procedure writeln.
  The compiler fails if the program prints FAIL or the program
  does not compile. *)
program t6p9p5d1;
var
   f:text;
   a,b:packed array[1..10] of char;
   i:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #309');
   rewrite(f);
   writeln(f,1:5,'ABCDE');
   write(f,1:5,'ABCDE');
   writeln(f);
   reset(f);
   for i:=1 to 10 do
      read(f,a[i]);
   reset(f);

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   for i:=1 to 10 do
      read(f,b[i]);
   if (a=b) then
      writeln(' PASS...6.9.5-1, WRITELN')
   else
      writeln(' FAIL...6.9.5-1, WRITELN');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 