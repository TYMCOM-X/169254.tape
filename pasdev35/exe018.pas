program exe017 options check,trace;  (* test the check and nocheck options *)

public procedure init;
  begin
    rewrite (tty);
    writeln (tty, 'Begin EXE017');
    break (tty);
  end;
$PAGE Error
procedure error (error_number : integer);
  begin
    writeln (tty, 'Error ', error_number);
    break(tty);
  end;
$PAGE Scalar_coercion
procedure test_scalar_coercion;

  type scalar_type = ( sc0, sc1, sc2, sc3, sc4, sc5 );

  var  integer_1 : integer;
       scalar    : scalar_type;

  procedure scalar_test_1 (coerced_integer : scalar_type);
    
    var scalar : scalar_type;

    begin
      scalar := pred (coerced_integer);
      if scalar <> sc3
        then error ( 2 );
    end;

  procedure scalar_test_2 ( var coerced_integer : scalar_type);
  
    var scalar : scalar_type;

    begin
      scalar := succ (coerced_integer);
      if scalar <> sc5 
        then error ( 3 );
    end;

  begin (* test_scalar_conversion_main *)
    
    integer_1 := 4;
    scalar := scalar_type (integer_1);
    if scalar <> sc4 
       then error ( 1 );

    (* Pass the coerced scalar as a value parameter *)
    scalar_test_1 (scalar);

    (* Pass the coerced scalar as a var parameter *)
    scalar_test_2 (scalar);

  end;
$PAGE Wrapup
procedure wrapup;
  begin
    writeln (tty, 'End EXE017');
  end;
$PAGE Main
begin
  init;
  test_scalar_coercion;
  wrapup;
end.
   