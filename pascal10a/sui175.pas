
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 175*)
(*TEST 6.6.5.3-1, CLASS=CONFORMANCE*)
(* This program checks that the procedure new has
  been implemented. Both forms of new are tested
  and both should pass. *)
program t6p6p5p3d1;
type
   two      = (a,b);
   recone   = record
               i : integer;
               j : boolean
              end;
   rectwo   = record
               c : integer;
               case tagfield : two of
                  a : (m : integer);
                  b : (n : boolean)
              end;
   recthree = record
               c : integer;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

               case tagfield : two of
                  a : (case tagfeeld : two of
                           a : (o : real);
                           b : (p : char));
                  b : (q : integer)
              end;
var
   ptrone : ^recone;
   ptrtwo : ^rectwo;
   ptrthree : ^recthree;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #175');
   new(ptrone);
   new(ptrtwo,a);
   ptrtwo^.tagfield:=a;
   new(ptrthree,a,b);
   ptrthree^.tagfield:=a;
   ptrthree^.tagfeeld:=a;
   writeln(' PASS...6.6.5.3-1')
END.
    