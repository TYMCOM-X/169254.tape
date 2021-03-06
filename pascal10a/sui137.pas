
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 137*)
(*TEST 6.6.1-1, CLASS=CONFORMANCE*)
(* This program simply tests the syntax for procedures as defined
  by the Pascal Standard.
  The compiler fails if the program does not compile. *)
program t6p6p1d1;
var
   a : integer;
   b : real;
procedure withparameters(g : integer; h : real);
var
   c : integer;
   d : real;
begin
   c:=g;
   d:=h
end;
procedure parameterless;
begin
   write(' PASS')

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #137');
   a:=1;
   b:=2;
   withparameters(a,b);
   parameterless;
   writeln('...6.6.1-1')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   