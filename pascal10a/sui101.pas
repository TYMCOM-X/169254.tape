
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 101*)
(*TEST 6.4.3.5-4, CLASS=CONFORMANCE*)
(* This program tests if an end-of-line marker is inserted at
  the end of the line on the predefined file output, if
  not explicitly done in the program (i.e. is the buffer
  flushed). See also test 6.4.3.5-3. *)
program t6p4p3p5d4;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #101');
   write(' PASS...6.4.3.5-4')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    