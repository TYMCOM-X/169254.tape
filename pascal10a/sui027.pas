
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  27*)
(*TEST 6.1.8-1, CLASS=CONFORMANCE*)
(* The Pascal Standard states that a comment is considered to
  be a token separator. This program tests if the compiler
  allows this.
  The compiler fails if the program cannot be compiled. *)
program(* Is this permitted to be here? *)t6p1p8d1(* Or here? *);
var
   i(* control variable *):(* colon *)integer(* type *);
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #027');
   for(* This is a FOR loop *)i(* control variable *):=(* assignment *)
      1(* initial value *)to(* STEP 1 UNTIL *)1(* repetitions *)do(* go *)
      writeln(* write statement *)(' PASS...6.1.8-1')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    