$page QED -- Front End and Initialization for Our Glorious QEDitor
program qed
  options storage(3072);

const	cr = chr (#o15);			(* Carriage Return	*)

var
  buffer:	qbuffer;			(* working buffer *)

begin
  open (tty,[ascii]);
  rewrite (tty);
  tty^ := cr;					(* Initialize fake line end	*)
  qinitexec( buffer );				(* init buffer and 
						   editor parameters *)
  writeln(tty, 'QED Version 1.74(OPT-OPS)');
  repeat
    qedcl (buffer, [minimum (qedcmds)..maximum (qedcmds)])
  until (not buffer.changes) orif query ('Unwritten changes, OK')
end.						(* start-up *)
 