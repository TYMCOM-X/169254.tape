
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  43*)
(*TEST 6.2.2-3,CLASS=CONFORMANCE*)
(* This program is similar to 6.2.2-4, however a type identifier,
  say T, which specifies the domain of a pointer type ^T, is
  permitted to have its defining occurence anywhere in the type
  definition part in which ^T occurs.
  Thus in this example, (node=real)s' scope is excluded from the
  type definition of ouch.
  The compiler fails if the program does not compile or fails at
  run time. *)
program t6p2p2d3;
type
   node = real;
procedure ouch;
type
   p = ^node;
   node = boolean;
var
   ptr : p;
begin

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   new(ptr);
   ptr^:=true;
   writeln(' PASS...6.2.2-3')
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #043');
   ouch;
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 