$TITLE VAXALC - VAX 11 storage allocation

module vaxalc;

$HEADER ptmalc.hdr
$PAGE declarations
$SYSTEM pascal.inc
$SYSTEM pasist.inc
$SYSTEM ptmtal.inc
$SYSTEM ptmprm.inc
$SYSTEM pasmth.inc



const
    address_size = 4 (* storage unit *);
$PAGE alc_sym
(*  ALC SYM is called with a symbol and a location counter.  It sets the ItemAddr
    of the symbol to the location counter, and increments the location counter
    by the number of storage units required to store the symbol.  
    Since local storage is accessed by negative offsets from the VAX
    frame pointer, the location counter (or stack offset) must be 
    incremented by the required size before assigning the item's addr. *)

procedure alc_sym ( vsym: sym; var counter: unit_range ; local: boolean );

var
    align: align_range;
    bit_size: bit_range;

begin
  with vsym^ do begin
    alc_data (type_desc, bit_size, align);
    if not local then begin	(* positive offset *)
      counter := ngm (counter, align div byte_size);	(* force alignment in stack *)
      item_addr := counter;
    end;
    counter := counter + (bit_size div byte_size);
    if local then begin	(* negative offset *)
      counter := ngm (counter, align div byte_size);
      item_addr := counter;
    end;
  end;
end (* alc_sym *);
$PAGE alc_pass_1
(*  ALC PASS 1 scans the symbol table for each block of the program, assigning
    each local symbol a location relative to the start of its stack frame,
    and assigning a low-segment address to each initialized static variable.
    The local stack area size for each block is saved.  *)

procedure alc_pass_1;

var
    local_offset: unit_range;
    block: blk;
    symbols: sym;
    parmlist_size: unit_range;
    parm: sym;

begin
  block := root_block;
  while block <> nil do  with block^ do begin
    local_offset := 0;

    if return_sym <> nil then begin
      if passed_by_address (return_sym)
	then return_sym^.item_addr := 4
        else alc_sym (return_sym, local_offset, true);
    end;

    symbols := id_list.first;
    while symbols <> nil do  with symbols^ do begin
      if kind in [vars, values] then begin
	if dcl_class = local_sc then
	  alc_sym (symbols, local_offset, true)
	else if (dcl_class = static_sc) andif (init_value.kind <> no_value) then
	  alc_sym (symbols, lowseg_break, false);
      end (* if kind in [vars, values] *);
      symbols := next;
    end (* while symbols <> nil *);
    local_size := local_offset;

    block := downward_call_thread;
  end (* while block <> nil *);
end (* alc_pass_1 *);
$PAGE compute_block_offsets
(*  COMPUTE BLOCK OFFSETS computes StackBegin and StackEnd for each program and
    subroutine block in the program.  StackBegin is the offset of the first
    variable in a block's stack frame from the start of its owner's stack
    frame.  StackEnd is the maximum, for a block and for all the blocks with
    the same owner which can be called by it (directly or indirectly), of the
    sum of the StackBegin and LocalSize values.  That is, StackEnd is one
    greater than the largest offset in the stack frame of the block's owner
    which can be used during execution of the block.  *)

procedure compute_block_offsets;

var
    block, last_block: blk;
    call_list: call_link;

begin

  (*  Compute StackBegin for each block.  StackEnd will be StackBegin + localSize.  *)

  block := root_block;
  while block <> nil do  with block^ do begin
    if kind in [program_blk, subr_blk] then begin

      (* Suppress quick blocks. *)

      owner := block;
      apparent_level := level;

      if owner = block then
	if (kind = subr_blk) andif (children <> nil) andif
	   ( (parm_list.first <> nil) or
	     ( (return_sym <> nil) andif (passed_by_address(return_sym)) ) )
	    then stack_begin := 12	(* reserve word for saved parameter list address *)
	    else stack_begin := 8;

      stack_end := stack_begin + local_size;

      call_list := calls;
      while call_list <> nil do  with call_list^ do begin
	if (called_subr^.owner = owner) and (called_subr <> block) then
	  called_subr^.stack_begin := max (called_subr^.stack_begin, stack_end);
	call_list := rlink;
      end (* while call_list <> nil *);

    end (* if kind in [program_blk, subr_blk] *);
    last_block := block;
    block := downward_call_thread;
  end (* while block <> nil *);

  (*  Compute StackEnd for each block.  *)

  block := last_block;
  while block <> nil do  with block^ do begin
    if kind in [program_blk, subr_blk] then begin
      call_list := calls;
      while call_list <> nil do  with call_list^ do begin
	if called_subr^.owner = owner then
	  stack_end := max (stack_end, called_subr^.stack_end);
	call_list := rlink;
      end (* while call_list <> nil *);
    end (* if kind in [program_blk, subr_blk] *);
    block := upward_call_thread;
  end (* while block <> nil *);
end (* compute_block_offsets *);
$PAGE alc_pass_2
(*  ALC PASS 2 scans the symbol table for each block of the program, assigning
    each local symbol a location relative to the start of its owner's stack
    frame, and assigning a low-segment address to each uninitialized static
    variable.  *)

procedure alc_pass_2;

var
    block: blk;
    symbols: sym;
    parm: sym;

begin
  block := root_block;
  while block <> nil do  with block^ do begin
    if return_sym <> nil then
      if not passed_by_address (return_sym) then
	return_sym^.item_addr := return_sym^.item_addr + stack_begin;
    symbols := id_list.first;
    while symbols <> nil do  with symbols^ do begin
      if kind in [vars, values] then begin
	if dcl_class = local_sc then
	  item_addr := item_addr + stack_begin
	else if (dcl_class = static_sc) andif (init_value.kind = no_value) then
	  alc_sym (symbols, lowseg_break, false);
      end (* if kind in [vars, values] *);
      symbols := next;
    end (* while symbols <> nil *);
    block := downward_call_thread;
  end (* while block <> nil *);
end (* alc_pass_2 *);
$PAGE allocate_storage
(*  ALLOCATE STORAGE assigns a memory address to each variable or parameter
    symbol in the program.  *)

public procedure allocate_storage;

begin
  lowseg_break := 0;
  alc_pass_1;
  compute_block_offsets;
  alc_pass_2;
end (* allocate_storage *).
  