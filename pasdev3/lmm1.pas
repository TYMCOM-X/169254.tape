(* LMM1 - Vax link management test program module. *)

module lmm1
$IF LMM1V2  options debug
;

external procedure main_proc ( string );

external var
  pub_var: ^string;
  ttyoutput: ^text;

var
$IF LMM1V1  ovl_var: string := 'Initialized static var of module LMM1V1';
$IF LMM1V2  ovl_var: string := 'Initialized static var of module LMM1V2';

$IF LMM1V2  space: set of 0..47;


public procedure lmm1;

begin
$IFNONE (LMM1V1,LMM1V2) Turn one of the flags on!!!!

$IF LMM1V1  writeln ( ttyoutput^, 'Begin LMM1V1' );
$IF LMM1V2  writeln ( ttyoutput^, 'Begin LMM1V2' );

$IF LMM1V2  space := [3..7,11];

  writeln ( ttyoutput^, ovl_var );
  ovl_var := 'OVL_VAR is now garbage!!!!';
  writeln ( ttyoutput^, pub_var^ );
  writeln ( ttyoutput^, random );
$IF LMM1V1  main_proc ( 'LMM1V1 calling' );
$IF LMM1V2  main_proc ( 'LMM1V2 calling' );
  writeln ( ttyoutput^, sin( arccos(-1) / 6 ) );

$IF LMM1V1  writeln ( ttyoutput^, 'End LMM1V1' );
$IF LMM1V2  writeln ( ttyoutput^, 'End LMM1V2' );

end  (* proc LMM1 *) .
  