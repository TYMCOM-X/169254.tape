
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 102*)
(*TEST 6.4.4-1, CLASS=CONFORMANCE*)
(* This program simply tests that pointer types as described in the
  Pascal Standard are permitted. *)
program t6p4p4d1;
type
   sett     = set of 1..2;
   urray    = array[1..3] of integer;
   rekord   = record
               a : integer;
               b : boolean
              end;
   ptr9     = ^sett;
   pureptr  = ^pureptr;
var
   ptr1  : ^integer;
   ptr2  : ^real;
   ptr3  : ^boolean;
   ptr4  : ^sett;
   ptr5  : ^urray;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   ptr6  : ^rekord;
   ptr7  : pureptr;
   ptr8  : ptr9;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #102');
   new(ptr1);
   new(ptr2);
   new(ptr3);
   new(ptr4);
   new(ptr5);
   new(ptr6);
   new(ptr7);
   new(ptr8);
   writeln(' PASS...6.4.4-1')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    