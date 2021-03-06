
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 300*)
(*TEST 6.9.4-7, CLASS=CONFORMANCE*)
(* This test checks that boolean variables are correctly written
  to text files. The compiler fails if the program does not compile
  or the program prints FAIL. *)
program t6p9p4d7;
var
   f:text;
   b,c:boolean;
   a:packed array[1..10] of char;
   i:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #300');
   (* This treatement is believed to be very dubious and may be
     altered in the future versions of the standard:
     A.H.J. Sale 1979 June 1 *)
   rewrite(f);
   b:=true;
   c:=not b;
   writeln(f,b:5,c:5);

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   reset(f);
   for i:=1 to 10 do
      read(f,a[i]);
   if (a='TRUE FALSE') then
      writeln(' PASS...6.9.4-7, WRITE BOOLEAN')
   else
      writeln(' FAIL...6.9.4-7, WRITE BOOLEAN');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 