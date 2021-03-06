
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 144*)
(*TEST 6.6.2-3, CLASS=CONFORMANCE*)
(* The Pascal Standard specifies that the result type of a function
  can only be a simple type or a pointer type.
  This program checks that the simple types and pointer types are
  permitted.
  The compiler fails if the program does not compile. *)
program t6p6p2d3;
type
   subrange = 0..3;
   enumerated = (red,yellow,green);
   rectype = record
               a : integer
             end;
   ptrtype = ^rectype;
var
   a : real;
   b : integer;
   c : boolean;
   d : subrange;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   e : enumerated;
   f : char;
   g : ptrtype;
function one : real;
begin
   one:=2.63
end;
function two : integer;
begin
   two:=2
end;
function three : boolean;
begin
   three:=false
end;
function four : subrange;
begin
   four:=2
end;
function five : enumerated;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

begin
   five:=yellow
end;
function six : char;
begin
   six:='6'
end;
function seven : ptrtype;
begin
   seven:=nil
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #144');
   a:=one;
   b:=two;
   c:=three;
   d:=four;
   e:=five;
   f:=six;
   g:=seven;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   writeln(' PASS...6.6.2-3')
end.
  