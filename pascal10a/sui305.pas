
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 305*)
(*TEST 6.9.4-12, CLASS=DEVIANCE*)
(*This program checks whether an unpacked array of characters
  can be output. The compiler deviates if the program prints
  DEVIATES. *)
program t6p9p4d12;
var
   s:array[1..3] of char;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #305');
   s[1]:='R'; s[2]:='A'; s[3]:='N';
   writeln(' RAN=',s);
   writeln(' DEVIATES...6.9.4-12, WRITE');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 