program qed;

$INCLUDE QERR.TYP
$INCLUDE QSTR.TYP
$INCLUDE QSPAT.TYP
$INCLUDE QSPRED.TYP
$INCLUDE CMDUTL.TYP
$INCLUDE QEDLN.TYP
$INCLUDE QEDLN.INC
$INCLUDE QED.TYP
$INCLUDE QLD.TYP
$INCLUDE QED.INC
$INCLUDE RLB:QUERY.INC


(* front-end initialization for QED *)

var
  buffer:	qbuffer;			(* working buffer *)

begin
  open (tty, '');
  rewrite (ttyoutput, '', false);
  qinitexec( buffer );				(* init buffer and 
						   editor parameters *)
  writeln(tty, 'QED Version 1.7');
  repeat
    qedcl (buffer, [minimum (qedcmds)..maximum (qedcmds)])
  until (not buffer.changes) orif query ('Unwritten changes, OK')
end.						(* start-up *)
  