
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 287*)
(*TEST 6.9.1-1, CLASS=CONFORMANCE*)
(* This program checks that the functions eoln and eof are
  correctly implemented. The compiler fails if the program does
  not compile or the program prints FAIL. *)
program t6p9p1d1;
var
   f:text;
   counter:integer;
   c:char;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #287');
   rewrite(f);
   counter:=0;
   writeln(f,1);
   writeln(f,'A');
   reset(f);
   while not eoln(f) do
      read(f,c);
   read(f,c);

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   if (c=' ') then
      counter:=counter+1;
   read(f,c);
   if (c='A') then
      counter:=counter+1;
   if eoln(f) then
     counter:=counter+1;
   read(f,c);
   if eof(f) then
      counter:=counter+1;
   if (counter=4) then
      writeln(' PASS...6.9.1-1, EOLN AND EOF')
   else
      writeln('FAIL...6.9.1-1, EOLN AND EOF');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    