
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  28*)
(*TEST 6.1.8-2, CLASS=CONFORMANCE*)
(* The Pascal Standard permits an open curly bracket to
  appear in a comment. This program tests that the
  compiler will allow this.
  The compiler fails if the program will not compile. *)
program t6p1p8d2;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #028');
   (* Is a (* permitted in a comment? *)*)
   writeln(' PASS...6.1.8-2')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

  