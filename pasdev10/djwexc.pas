program djwexc;
  
  exception
    my_own_1, my_own_2;
  public exception
    my_own_3;
  external exception
    someone_elses_1;
  label
    1;
  var
    z: integer;
    rec_ptr: ^record
		f1: integer
	      end;
    init_stat: array [1..20] of integer :=
	(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20);
    init_stat2: boolean := true;
    uninit_stat: array [1..20] of integer;
    uninit_stat2: boolean;
  external var
      extvar: integer;

  procedure except;
    label
      2;
    var
      x, y: integer;
      bool: boolean;
      rec_ptr: ^record
	      f1: integer
	    end;
      sub_math: math_status;
      sub_io: io_status;
      sub_prog: program_status;
      sub_spcl: special_status;

    begin
      with rec_ptr^ do begin
	bool := masked (attention);
	if masked (attention) then
	  bool := true
	else
	  bool := false;
        loop begin
	 2:
	  write (ttyoutput, 'inside loop');
	  mask (attention);
	  bool := pending (attention);
	  if bool then begin
	    x := x + 1;
	    exception
	      my_own_1: y := y + 1;
	      my_own_2: goto 2;
	      others:   signal ()
	  end;
	  exit if rec_ptr = nil;
	  unmask (attention);
	  exception
	    my_own_2: begin
	      x := x - 1;
	      exception
		my_own_2: y := y - 1
	    end;
	    my_own_1: y := y - 2;
	    stack_overflow: y := y div 2;
	    math_error:
	      sub_math := mathstatus;
	    io_error:
	      sub_io := exiostatus;
	    program_error:
	      sub_prog := programstatus;
	    special_error:
	      sub_spcl := specialstatus
        end end;
	exception
	  my_own_1: goto 1;
	  my_own_2: signal (my_own_3);
	  allconditions: x := x * 2
      end
    end;
  
begin
 1:
  with rec_ptr^ do begin
    except;
    except;
    exception
      my_own_1: z := z * z;
      my_own_3: z := z div z;
      someone_elses_1: signal ();
      allconditions: exception_message
  end;
  
  init_stat [1] := 0;
  init_stat2 := false;
  uninit_stat [1] := 0;
  uninit_stat2 := false;
end.
 