$PAGE value_check
  
(* VALUE CHECK generates code for value and subscript range check tuples.  *)

procedure value_check (value_chk_op: tuple; rts: rt_symbol);
  
var
  reg:	registers;
  low_addr, high_addr:	addr_desc;
  const_value, const_lowbound, const_highbound:	boolean;
  value,       lowbound,       highbound:	int_type;
  need_highcheck, need_lowcheck: boolean;
  
begin
  (* fetch addresses of bounds - even if not used they must be fetched to keep
     the tuple reference counts right  *)
  
  low_addr := fetch_fullword (value_chk_op^.operand[2]);
  high_addr := fetch_fullword (value_chk_op^.operand[3]);
  (* might as well load up the value now - the check tuple wouldn't exist if
     it was detectable as useless at compile time (but note that it might be
     guaranteed to fail!)  *)
  reg := nond_load (value_chk_op^.operand[1], 36);
  
  (* determine what is and isn't known at compile time *)
  
  const_value := iconstp (value_chk_op^.operand[1], value);
  const_lowbound := aconstp (low_addr, lowbound);
  const_highbound := aconstp (high_addr, highbound);
  need_lowcheck := (not const_value or not const_lowbound) orif (value < lowbound);
  need_highcheck := (not const_value or not const_highbound) orif (value > highbound);
  
  if need_lowcheck then
    if need_highcheck then
      gen_rm (cam+ltc, reg, low_addr)
    else
      gen_rm (cam+gec, reg, low_addr);
  if need_highcheck then
    gen_rm (cam+lec, reg, high_addr);
  gen_rt (jsp, 1, rts);
  
  decr_reg_usages (reg);
  free (low_addr);
  free (high_addr)
end;
$PAGE pointer_check

(* POINTER CHECK generates code for a pointer or file check tuple.  Tests
   for NIL and zero are generated.  *)
  
procedure pointer_check (ptr_check_tpl: tuple; rts: rt_symbol);
  
var 
  reg: registers;
  
begin
  reg := nond_load (ptr_check_tpl^.operand[1], 36);
  gen (jump + eqc, reg, 0, 2, dot);
  gen_ri (cai + nec, reg, 377777B);
  gen_rt (jsp, 1, rts);
  decr_reg_usages (reg)
end;
$PAGE perform_check
(* PERFORM CHECK merely dispatches a check tuple to the appropriate routine. *)

procedure perform_check (check_tuple: tuple);

begin
  case check_tuple^.opcode of

    val_range_chk:
      value_check (check_tuple, rt_val_chk);

    file_chk:
      pointer_check (check_tuple, rt_fil_chk);

    ptr_chk:
      pointer_check (check_tuple, rt_ptr_chk);

    sub_range_chk:
      value_check (check_tuple, rt_sub_chk);

    str_range_chk:
      substring_check (check_tuple);

    compat_chk:
      compatibility_check (check_tuple)

  end;
end;
$PAGE do_check
(* DO CHECK forces evaluation of a delayed check tuple, given one of its
   operands. The result field of the operand indicates its check tuple. *)

public procedure do_check (exp: expr);

var
  tpl: tuple;

begin
  tpl := exp^.result;
  exp^.result := nil;   (* to allow evaluation *)
  exp^.ref_fre := 0;
  perform_check (tpl);
end;
$PAGE attach_check_op
(* ATTACH CHECK OP links a check tuple and one of its operands for
   evaluation when the operand is to be used. If the operand has already
   been evaluated, the check is performed now. *)

procedure attach_check_op (
        check_tpl: tuple;       (* the check tuple *)
        operand: expr);         (* the operand to be tagged *)

begin
  if operand^.result <> nil then        (* already evaluated, do the check *)
    perform_check (check_tpl)
  else begin
    operand^.result := check_tpl;
    operand^.ref_fre := 1;              (* mark as linked *)
  end;
end;
   