(**************************************************************)
(*                                                            *)
(*   Program for Jim to learn ODMS with                       *)
(*                                                            *)
(**************************************************************)

program test ; 

external procedure testa ;

(* external procedure testb ; *)

begin

   rewrite( tty );
   writeln( tty, ' Last compilation : ', compdate, '   ', comptime ) ;

   writeln( tty, ' entering main ' ) ;
   testa ;
   writeln( tty, ' in middle of main (after a, before b) ' ) ;
(* testb ; *)
   writeln( tty, ' exiting main ' ) ;

end .
 