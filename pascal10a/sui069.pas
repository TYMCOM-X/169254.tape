
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  69*)
(*TEST 6.4.2.4-1, CLASS=CONFORMANCE*)
(* This program tests that a type may be defined as a subrange
  of another ordinal-type (host-type).
  The compiler fails if one or more of the cases below are rejected. *)
program t6p4p2p4d1;
type
   colour      = (red,pink,orange,yellow,green,blue);
   somecolour  = red..green;
   century     = 1..100;
   twentyone   = -10..+10;
   digits      = '0'..'9';
   zero        = 0..0;
   logical     = false..true;
var
   tf : logical;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #069');
   tf:=true;
   writeln(' PASS...6.4.2.4-1')

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

end.
    