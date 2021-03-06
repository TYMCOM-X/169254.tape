
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 268*)
(*TEST 6.8.3.9-9, CLASS=DEVIANCE*)
(* This program tests whether a non local variable at an intermediate
  level can be used as a for statement control variable.
  The program deviates if the program compiles and prints
  DEVIATES. *)
program t6p8p3p9d9;
procedure p;
var
   i:integer;
   procedure loop_;
   var
      j:integer;
   begin
      j:=0;
      for i:=1 to 10 do
         j:=j+1;
   end;
begin
   loop_

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #268');
   p;
   writeln(' DEVIATES...6.8.3.9-9, FOR');
end.
    