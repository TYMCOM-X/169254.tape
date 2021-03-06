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
$PAGE substring parameters
procedure substr_param ;

var string_arg : string[11];

  procedure test_string_1 (str : packed array [1..5] of char);
    
    begin
      if str <> 'HELLO'
        then error ( 1 );
    end;

  procedure test_string_2 (var str : packed array [1..5] of char);
  
    begin
      if str <> 'HELLO'
        then error ( 2 );
    end;

  begin
    string_arg := 'HELLO THERE';
    test_string_1 ( substr( string_arg, 1, 5) );
    test_string_2 ( substr ( string_arg, 1, 5) );
  end;
$PAGE Wrapup
procedure wrapup;
  begin
    writeln (tty, 'End EXE017');
  end;
$PAGE Main
begin
  init;
  wrapup;
end.
    