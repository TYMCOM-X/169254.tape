
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 298*)
(*TEST 6.9.4-5, CLASS=IMPLEMENTATIONDEFINED*)
(* This program determines the implementation defines value which
  represents the number of digit characters written in an exponent. *)
program t6p9p4d5;
var
   f:text;
   c:char;
   i:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #298');
   rewrite(f);
   writeln(f,1.0:10,'ABC');
   reset(f);
   repeat
      read(f,c);
   until (c='E');
   read(f,c);
   i:=-1;
   repeat

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      read(f,c);
      i:=i+1;
   until (c='A');
   writeln(' THE NUMBER OF DIGITS WRITTEN IN AN EXPONENT IS',i:5);
end.
 