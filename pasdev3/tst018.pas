(*  TST018 - procedure variables.  *)

program tst018;

external procedure extern;
external var ext_proc_var: procedure;
var int_proc_var: procedure;
var i: integer;

procedure intern;
  begin
  end;

procedure oof_son ( proc_arr: array [1..3] of procedure );
  begin
    proc_arr[ i ];
  end;

begin
  extern;
  intern;
  ext_proc_var;
  int_proc_var;
end.
   