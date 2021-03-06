
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 247*)
(*TEST 6.8.3.5-7,CLASS=ERRORHANDLING*)
(* This test contains an invalid real case-constant with an integer
  case expression. If the program compiles the effect at run-time
  could be curious. *)
program t6p8p3p5d7;
var
   a,i:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #247');
   for i:=1 to 4 do
      case i of
      1,2: a:=1;
      2.5: writeln(' DEVIATES...6.8.3.5-7. CASE');
      3:   a:=2;
      4e0: writeln(' DEVIATES...6.8.3.5-7, CASE');
      end;
   writeln(' DEVIATES...6.8.3.5-7, CASE');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

  