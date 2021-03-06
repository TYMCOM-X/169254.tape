
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  44*)
(*TEST 6.2.2-4, CLASS=DEVIANCE*)
(* The Pascal Standard says that the defining occurrence of an
  identifier or label precedes all corresponding occurrences of
  that identifier or label in the program text (except for specific
  pointercase). The scope of an identifier or label also includes
  the whole block in which it is defined, thereby disallowing
  any references to an outer identifier of the same name preceeding
  the defining occurrence.  Some compilers may not conform
  to this and allow some scope overlap.
  The compiler conforms if the program does not compile and objects
  to the use of 'red' in ouch preceding its definition. *)
program t6p2p2d4;
const
   red = 1;
   violet = 2;
procedure ouch;
const
   m = red;
   n = violet;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

type
   a = array[m..n] of integer;
var
   v : a;
   colour : (yellow,green,blue,red,indigo,violet);
begin
   v[1]:=1;
   colour:=red;
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #044');
   ouch;
   writeln(' DEVIATES...6.2.2-4 --> SCOPE ERROR NOT DETECTED')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 