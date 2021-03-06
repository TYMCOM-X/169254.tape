
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 275*)
(*TEST 6.8.3.9-16, CLASS=DEVIANCE*)
(* This test checks the type of error produced when a for statement
  control variable value is read during the execution of the for
  statement. The compiler deviates if the program compiles and
  prints DEVIATES. *)
program t6p8p3p9d16;
var
   f:text;
   i,j:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #275');
   j:=0;
   rewrite(f);
   writeln(f,5,5,5,5,5);
   reset(f);
   for i := 1 to 10 do
   begin
      if (i<5) then
         read(f,i);

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      j:=j+1;
   end;
   writeln(' DEVIATES...6.8.3.9-16, FOR');
end.
    