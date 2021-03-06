
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 308*)
(*TEST 6.9.4-15, CLASS=CONFORMANCE*)
(* This test checks that a write that does not specify the file
  always writes on the default file at the program level, not
  any local variable with the same name. *)
program t6p9p4d15;
   procedure p;
   var
      output:text;
   begin
      rewrite(output);       writeln('suite program #308');
      writeln(output,' FAIL...6.9.4-15');
      writeln(' PASS...6.9.4-15')
   end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #308');
   p
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    