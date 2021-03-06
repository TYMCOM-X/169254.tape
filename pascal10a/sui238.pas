
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 238*)
(*TEST 6.8.2.4-3, CLASS=DEVIATES*)
(* This test checks whether jumps between branches of a
  case statement are allowed. The compiler deviates if the
  program compiles and the program prints DEVIATES. *)
program t6p8p2p4d3;
label
   4;
var
   i:1..3;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #238');
   for i:=1 to 2 do
      case i of
      1:  ;
      2: goto 4;
      3:4:
         writeln(' DEVIATES...6.8.2.4-3');
      end;
end.
  