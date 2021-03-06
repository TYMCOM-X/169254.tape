
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 143*)
(*TEST 6.6.2-2, CLASS=CONFORMANCE*)
(* Similarly to 6.6.1-2, functions may be declared as forward.
  This program tests that forward declaration and recursion in
  functions is permitted.
  The compiler fails if the program does not compile. *)
program t6p6p2d2;
var
   c : integer;
function one(a : integer) : integer;
   forward;
function two(b : integer) : integer;
var
   x : integer;
begin
   x:=b+1;
   x:=one(x);
   two:=x
end;
function one;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

var
   y : integer;
begin
   y:=a+1;
   if y=1 then y:=two(y);
   one:=y
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #143');
   c:=0;
   c:=one(c);
   if c = 3 then
      writeln(' PASS...6.6.2-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   