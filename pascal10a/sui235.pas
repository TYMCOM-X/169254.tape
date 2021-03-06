
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 235*)
(*TEST 6.8.2.2-2, CLASS=IMPLEMENTATIONDEFINED*)
(* This program is similar to 6.8.2.2-1, except that the
  selection of the variable involves the dereferencing of
  a pointer. *)
program t6p8p2p2d2;
type
   rekord=record
            a : integer;
            b : boolean;
            link : ^rekord
         end;
   poynter=^rekord;
var
   temp, ptr : poynter;
function sideeffect(var p : poynter) : integer;
begin
   p:=p^.link;
   sideeffect:=2;
end;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #235');
   writeln(' TEST OF BINDING ORDER (P^ := EXP)');
   new(ptr);
   ptr^.a:=1;
   ptr^.b:=true;
   new(temp);
   ptr^.link:=temp;
   temp^.a:=0;
   temp^.b:=false;
   temp:=ptr;
   ptr^.a:=sideeffect(ptr);
   if temp^.a=2 then
      writeln(' SELECTION THEN EVALUATION...6.8.2.2-2')
   else
      if temp^.link^.a=2 then
         writeln(' EVALUATION THEN SELECTION...6.8.2.2-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    