
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 211*)
(*TEST 6.7.1-1, CLASS=CONFORMANCE*)
(* This program tests that the precedence of the boolean operators
  is as described in the Pascal Standard.
  The compiler fails if the program does not compile, or the
  program states that this is so. *)
program t6p7p1d1;
var
   a, b, c, w, x : boolean;
   counter:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #211');
  counter := 0;
   for a := false to true do
      for b:= false to true do
         for c := false to true do
         begin
            w := (a and b) < c;
            x := c > b and a;
            if (w=x) then counter := counter+1;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

         end;
   if (counter=8) then
      writeln(' PASS...6.7.1-1')
   else
      writeln(' FAIL...6.7.1-1')
end.
  