(* MTMOD - source code for ALL of the overlay modules of MTEST -
   the Pascal overlay system's test program.  

   Each of the modules prompts for the number of the next procedure to
   call.  Entering an invalid procedure number will cause a return
   to the caller.

   Certain bells and whistles (specialized tests) are conditionally
   generated in certain modules only.  *)

module
$IF mt02a mt02a
$IF mt03a mt03a
$IF mt11a mt11a
$IF mt11b mt11b
$IF mt12a mt12a
$IF mt13a mt13a
$IF mt21a mt21a
$IF mt22a mt22a
$IF mt23a mt23a
$IF mtalt0 mtalt0
$IF mtalt1 mtalt1
	options overlay;

$IFANY (USER_CONDITION, SIGNALUSERCOND) external exception user_condition;

  type  
    local_pub_rec = record
      f1: char;
      f2: 0..255;
      f3: boolean;
    end;


$IF public public var local_pub: local_pub_rec := ('Z', 117, true);
$IF external external var local_pub: local_pub_rec;


    procedure write_proc_name;
      begin
	write (  ttyoutput,
$IF mt02a 'MT021'
$IF mt03a 'MT031'
$IF mt11a 'MT111'
$IF mt11b 'MT112'
$IF mt12a 'MT121'
$IF mt13a 'MT131'
$IF mt21a 'MT211'
$IF mt22a 'MT221'
$IF mt23a 'MT231'
$IF mtalt0 'MTALT0'
$IF mtalt1 'MTALT1'
	  );
      end;


  public procedure
$IF mt02a mt021
$IF mt03a mt031
$IF mt11a mt111
$IF mt11b mt112
$IF mt12a mt121
$IF mt13a mt131
$IF mt21a mt211
$IF mt22a mt221
$IF mt23a mt231
$IF mtalt0 mt021
$IF mtalt1 mt111
	  ;


  var
    cmd_line: cmd_string;
    proc_index: procedure_index;

$IF causeheapoverflow p: ^array [1..4096] of integer;


  begin

$IF causeheapoverflow
    while true do new ( p );
$ENDIF

$IF signalusercond  signal( user_condition );


$IFANY (public, external)
    with local_pub do begin
      if (f1 <> 'Z') or (f2 <> 117) or (f3 <> true) then begin
	writeln ( ttyoutput, '*********' );
	writeln ( ttyoutput, '* ERROR *  in static storage initialization.' );
	writeln ( ttyoutput, '*********' );
      end;
    end;
$ENDIF


    loop
      begin
	write_proc_name;
	write ( ttyoutput, ' - enter proc number: ' );
	break ( ttyoutput );
	if eoln ( tty ) then readln ( tty );
	read ( tty, cmd_line );

	if (length(cmd_line) > 0) andif (uppercase(cmd_line[1]) = 'C') then
	  cmd_line := substr ( cmd_line, 2 );

	proc_index := get_proc_index ( cmd_line );
      exit if not valid_index ( proc_index );
	procs[ proc_index ];

        (* Declare exception handlers for loop body *)

$IFANY (attention, storage_overflow, user_condition, others_handler) exception

$IF attention
	attention:
	  begin
	    clear( tty );
	    clear( ttyoutput );
	    writeln ( ttyoutput );
	    write( ttyoutput, 'Attention signalled. Resuming execution in procedure: ' );
	    write_proc_name;
	    writeln ( ttyoutput );
	  end;
$ENDIF

$IF storage_overflow
	storage_overflow:
	  begin
	    writeln ( ttyoutput );
	    write ( ttyoutput, 'Heap overflow. Resuming execution in procedure: ' );
	    write_proc_name;
	    writeln ( ttyoutput );
	  end;
$ENDIF

$IF user_condition
	user_condition:
	  begin
	    writeln ( ttyoutput );
	    write ( ttyoutput, 'User condition signalled. Resuming execution in Procedure: ' );
	    write_proc_name;
	    writeln ( ttyoutput );
	  end;
$ENDIF

$IF others_handler
	others:
	  begin
	    writeln ( ttyoutput );
	    write ( ttyoutput, 'In others clause of handler for procedure: ' );
	    write_proc_name;
	    writeln ( ttyoutput );
	    break ( ttyoutput );
	    exception_message;
	    signal();
	  end;
$ENDIF
    end;
  end  (* loop *) ;

  write ( ttyoutput, 'Exit ' );
  write_proc_name;
  writeln ( ttyoutput );


end.
    