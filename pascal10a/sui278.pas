
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 278*)
(*TEST 6.8.3.9-19, CLASS=DEVIANCE*)
(* This test checks that compilers that permit the deviation
  (extension?) of allowing non-local control variables do so
  responsibly and do not introduce new insecurities.
  This test checks that a nested for statement using the same control
  variable is detected. It is similar to test 6.8.3.9-14 but
  requires a degree of sophistication to detect this condition.
  The compiler deviates if the program prints DEVIATES.
  The program may loop endlessly under some compilers. *)
program t6p8p3p9d19;
var
   i:integer;
procedure p;
   procedure q;
      procedure r;
         procedure s(var i:integer);
         begin
            writeln(i);
         end;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      begin
         for i:= 5 downto 2 do
            s(i);
      end;
   begin
      r
   end;
begin
   q
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #278');
   for i:= 1 to 6 do
      p;
   writeln(' DEVIATES...6.8.3.9-19, FOR')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    