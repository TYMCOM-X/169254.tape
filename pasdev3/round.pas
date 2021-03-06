(* ROUND - test program for 2 operand ROUND function of Pascal.
   Allows user to interactively enter 2 parameters of round,
   calls ROUND and prints the result.  *)

program round;

public var
  real_string: string;
  integer_parameter: integer;
  i: 1..128;
  mantissa_digits: 0..40;
  single: boolean;
  singl_real: real;
  double_real: minimum(real)..maximum(real) prec 16;

begin
  open ( tty );
  rewrite ( ttyoutput );

  (* For each iteration of the following loop, 1 pair of parameters
     is read, ROUND is called and the result is printed.  *)

  loop

    (* Read the parameters.  *)

    write ( ttyoutput, 'Enter real parameter: ' );
    break ( ttyoutput );
    if eoln ( tty ) then readln ( tty );
    read ( tty, real_string );

  exit if real_string = '';

    write ( ttyoutput, 'Enter integer parameter: ' );
    break ( ttyoutput );
    read ( tty, integer_parameter );

    (* Determine if a single or double precision real was read.  The
       presence of more than 6 digits in the mantissa indicates double
       precision.  *)

    i := 1;
    mantissa_digits := 0;

    while ( i <= length ( real_string ) ) andif
	  ( uppercase ( real_string[ i ] ) <> 'E' ) do begin
      if real_string[ i ] in ['0'..'9'] then
        mantissa_digits := mantissa_digits + 1;
      i := i + 1;
    end;

    single := mantissa_digits <= 6;

    (* Convert the real to binary, in either single or double precision,
       call the ROUND function and print the result.  *)

    if single then begin
      getstring ( real_string, singl_real );
      singl_real := round ( singl_real, integer_parameter );
      writeln ( ttyoutput, singl_real:20:9:e );
    end
    else begin
      getstring ( real_string, double_real );
      double_real := round ( double_real, integer_parameter );
      writeln ( ttyoutput, double_real:30:20:e );
    end;

  end  (* loop *) ;

end.
 