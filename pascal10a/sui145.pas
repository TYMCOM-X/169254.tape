
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 145*)
(*TEST 6.6.2-4, CLASS=DEVIANCE*)
(* This program tests the compilers actions when the type of
  result returned by a function is not a simple type.
  All the cases should be rejected by the compiler if it
  conforms to the Standard. *)
program t6p6p2d4;
type
   wrekord = record
               a : integer;
               b : boolean
             end;
   sett    = set of 0..3;
   urray   = array[1..3] of char;
var
   record1 : wrekord;
   set1    : sett;
   array1  : urray;
function one : sett;
begin

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   one:=[0..3]
end;
function two : urray;
begin
   two:='ABC'
end;
function three : wrekord;
var
   rekord : wrekord;
begin
   rekord.a:=1;
   rekord.b:=true;
   three:=rekord
end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #145');
   record1:=one;
   set1:=two;
   array1:=three;
   writeln(' DEVIATES...6.6.2-4')

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

end.
   