
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  92*)
(*TEST 6.4.3.3-13, CLASS=CONFORMANCE*)
(* This test checks that nested variants are allowed
  with the appropriate syntax. The compiler fails if the
  program does not compile and print PASS. *)
program t6p4p3p3d13;
type
   a=record
       case b:boolean of
       true: (c:char);
       false: (case d:boolean of
               true: (e:char);
               false: (f:integer))
      end;
var
   g:a;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #092');
   g.b:=false;
   g.d:=false;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   g.f:=1;
   writeln(' PASS...6.4.3.3-13, VARIANTS')
end.
   