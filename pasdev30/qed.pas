$page QED -- Front End and Initialization for Our Glorious QEDitor
(* QED.PAS - modified 09/17/81 by djm to change Version number *)
(*           modified 05/04/82 by djm to change Version number *)

program qed
  options storage(3072);

var
  buffer:	qbuffer;			(* working buffer *)

begin
  open (tty,[ascii]);
  rewrite (tty);
  tty^ := cr;					(* Initialize fake line end	*)
  qinitexec( buffer );				(* init buffer and 
						   editor parameters *)
  writeln (tty, 'FILQED Version 1.0, Compiled on ',compdate);
  repeat
    qedcl (buffer, [minimum (qedcmds)..maximum (qedcmds)])
  until (not buffer.changes) orif query ('Unwritten changes, OK');
  qtmpscratch(buffer)  (* scratch any TMP files left around *)
end.						(* start-up *)
   