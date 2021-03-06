program proc_vars;

type
     proc_name = (Proc_Main, Proc_A_level1, Proc_B_level1, Proc_C_level1, Proc_D_level1,
                  Proc_B1_level2, Proc_B2_level2, 
                  Proc_B2a_level3, Proc_B2b_level3 );
     proc_1 = procedure (called_from : proc_name);
     proc_2 = procedure (called_from : proc_name; proc : proc_1);
     proc_3 = procedure (called_from : proc_name; var proc : proc_1);
var
     procedure_1 : proc_1;
     procedure_2 : proc_2;
     procedure_3 : proc_3;
     count       : integer;

  procedure error (error_num : integer );
    begin
      writeln ( tty, 'Error ', error_num);
      break (tty);
    end;

$PAGE procedure A_level1
  procedure A_level1 (called_from : proc_name);
    begin
      case called_from of
        Proc_Main : if count <> 1
                   then error ( 1 );
        Proc_C_level1    : if count <> 3
                   then error ( 3 );
        Proc_D_level1    : if count <> 5
                   then error ( 5 );
        Proc_B2a_level3  : if count <> 10
                   then error ( 10 );
      end;
      count := count + 1;
    end;
$PAGE procedure B_level1
  procedure B_level1 (called_from : proc_name);
    (* this procedure has many nested procedures, to test nested calls
       of procedure variables
    *)

       procedure B1_level2 (called_from : proc_name);

	 begin
	   if count <> 7 
	     then error ( 7 );
	   count := count + 1;
	 end;
$PAGE procedure B2_level2 and B2a_level3


       procedure B2_level2 (called_from : proc_name);

	    var proc : proc_1;

	    procedure B2a_level3 (called_from : proc_name);

	      var proc : proc_1;

	      begin
		case called_from of
		  Proc_B2b_level3 : begin
			    if count <> 8
			      then error ( 8 );
			    count := count + 1;
			    proc := B2a_level3;
                            proc ( Proc_B2a_level3 );      (* Recursive call *)
			  end;
		  Proc_B2a_level3 : begin
			    if count <> 9
			      then error ( 9 );
			    count := count + 1;
			    proc := A_level1;
                            proc ( Proc_B2a_level3 );      (* Call to procedure 2 levels up *)
			  end;
		end;
	      end;
$PAGE procedure B2b_level3 and body of B2_level2 and B_level1
	    procedure B2b_level3 (called_from : proc_name);

	      var proc : proc_1;

	      begin
		case called_from of
		  Proc_B2_level2 : begin
			   if count <> 6
			     then error ( 6 );
			   count := count + 1;
			   proc := B1_level2;
                           proc ( Proc_B2b_level3 );      (* Call to procedure 1 level up *)
			   proc := B2a_level3;
                           proc ( Proc_B2b_level3 );      (* Call to procedure at same level *)
			 end;
		end;
	      end;


	 begin (* body of B2_level2 *)
	   if count <> 5
	     then error ( 5 );
	   count := count + 1;
	   proc := B2b_level3;
           proc ( Proc_B2_level2 );      (* Call to own procedure *)
	 end;


    begin (* body of B_level1 *)
      if count <> 4
        then error ( 4 );
        count := count + 1;
        B2_level2 ( Proc_B_level1);
    end;

$PAGE procedures C_level1 and D_level_1
  procedure C_level1 (called_from : proc_name; proc : proc_1);
    begin
      if count <> 2 
        then error ( 2 );
      count := count + 1;
      proc ( Proc_C_level1 );
    end;

  procedure D_level1 (called_from : proc_name; var proc : proc_1);
    begin
      if count <> 4
        then error ( 4 );
      count := count + 1;
      (*proc ( Proc_D_level1 );*)
      proc := B_level1;
    end;
$PAGE Test address(procedure)
procedure test_address;
  var addr : ptr;
  begin
    addr := address ( A_level1 );

    exception
      program_error : if programstatus = program_assertion
                        then error ( 20 )
                        else error ( 21 );
      allconditions : error ( 22 );
  end;
$PAGE Main
begin
  rewrite(tty);
  writeln (tty, 'Begin EXE019');
  break (tty);
  count := 1;
  procedure_1 := A_level1;
  procedure_1 (Proc_Main);    (* Test calling a level-1 procedure *)

  procedure_2 := C_level1;
  procedure_2 (Proc_Main, A_level1);    (* Test passing a procedure var as a param *)

  procedure_3 := D_level1;
  (*procedure_3 (Proc_Main, procedure_1);*)   (* Test passing a procedure var as 
                                          a var parameter *)

  procedure_1 := B_level1;
  procedure_1 (Proc_Main);                (* procedure_1 should be B_level1, now *)
                                       (* Test nested and recursive calls *)
  test_address;
  writeln (tty, 'End EXE019');
  break (tty);
end.
   