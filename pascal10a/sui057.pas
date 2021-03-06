
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  57*)
(*TEST 6.4.1-1, CLASS=CONFORMANCE*)
(* This program tests to see that pointer types can be
  declared anywhere in the type part.  This freedom
  is explicitly permitted in the standard. *)
program t6p4p1d1;
type
   ptr1     = ^ polar;
   polar    = record r,theta : real end;
   purelink = ^ purelink;
   ptr2     = ^ person;
   ptr3     = ptr2;
   person   = record
                  mother,father : ptr2;
                  firstchild    : ptr2;
                  nextsibling   : ptr3
              end;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #057');
   writeln(' PASS...6.4.1-1')

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

end.
  