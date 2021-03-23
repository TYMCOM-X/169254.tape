$TITLE vaxcgu - code generator utilities
module vaxcgu;
$PAGE includes
$INCLUDE pascal.inc
$INCLUDE pasist.inc
$INCLUDE paspt.typ
$INCLUDE pasif.typ
$INCLUDE pastal.inc
$INCLUDE vaxcg.typ
$INCLUDE vaxopc.inc
$INCLUDE pasmth.inc
$INCLUDE vaxutl.inc
$INCLUDE vaxgen.inc
$INCLUDE vaxrel.inc
$SYSTEM ptmcon.inc
$PAGE public, static variables
  
public var
  code_area: code_list;                 (* chain of code records for code area *)
  static_area: code_list;               (* chain for static area image *)
  cst_area: code_list;                  (* chain for constant pool area *)
  
  loc_code: code_address;               (* location counter for code area *)
  loc_static: code_address;             (* location counter for static area *)
  loc_cst: code_address;                (* location counter for constant area *)

  def_lists: array [def_class] of def;  (* start of chains of internal definitions *)

static var
  defnum: array[def_class] of id_range;         (* next number to assign to internal symbol
                                           of type constant_def, code_def *)
$PAGE gen_emit
(* GEN EMIT chains an arbitrary code record ("cr") onto the end of
   the area denoted by "area list".  *)
  
public procedure gen_emit ( var area_list: code_list; cr: code);
  
  begin
    if area_list.first = nil
      then area_list.first := cr
      else area_list.last^.next := cr;
    area_list.last := cr;
    cr^.next := nil
  end;
$PAGE runtime symbol names

type rts_name_array = array [rt_symbol] of string [publics_length];
public var
  rts_name: rts_name_array :=
      ( 'PAX_MON.MAINFRA',
        'PAX_MON.UNWIND',
        'PAX_MON.UNWMAIN',
        'PAX_MTH.POWJJ',
        'PAX_MTH.POWRJ',
        'PAX_MTH.POWDJ',
        'PAX_MTH.POWRR',
        'PAX_MTH.POWDD',
        'PAX_ROUND.2',  'PAX_ROUND.2D',
        'MTH$SQRT',     'MTH$DSQRT',
        'MTH$ALOG',     'MTH$DLOG',
        'MTH$ALOG10',   'MTH$DLOG10',
        'MTH$EXP',      'MTH$DEXP',
        'MTH$SIN',      'MTH$DSIN',
        'MTH$ASIN',     'MTH$DASIN',
        'MTH$SINH',     'MTH$DSINH',
        'MTH$COS',      'MTH$DCOS',
        'MTH$ACOS',     'MTH$DACOS',
        'MTH$COSH',     'MTH$DCOSH',
        'MTH$TAN',      'MTH$DTAN',
        'MTH$TANH',     'MTH$DTANH',
        'PAX_MTH.CTN',  'PAX_MTH.DCTN',
        'MTH$ATAN',     'MTH$DATAN',
        'PAX_MTH.ATAN2','PAX_MTH.DATAN2',
        'PAX_MTH.RANDOM',
        'PAX_MTH.RANDOM',
        'PAX_UTL.NEW',
        'PAX_UTL.DSPOS',
        'PAX_UTL.EXTENT',
        'PAX_MON.SUBER',
        'PAX_MON.STRER',
        'PAX_MON.OVLER',
        'PAX_MON.VALER',
        'PAX_MON.PTRER',
        'PAX_MON.FVERR',
        'PAX_MON.FLDER',
        'PAX_MON.CMERR',
        'PAX_MON.ASSER',
        'PAX_MON.CASERR',
        'PAX_UTL.SRCH_L',
        'PAX_UTL.SRCH_UL',
        'PAX_UTL.SRCH_O',
        'PAX_UTL.SRCH_UO',
        'PAX_UTL.VRFY_L',
        'PAX_UTL.VRFY_UL',
        'PAX_UTL.VRFY_O',
        'PAX_UTL.VRFY_UO',
        'PAX_UTL.GENSET',
        'PAX_MON.STMT',
        'PAX_FVM.OPEN', 'PAX_FVM.REWRT',        'PAX_FVM.RESET',        (****  input / output  ****)
        'PAX_FVM.INITYP',       'PAX_FVM.INIBIN',
        'PAX_NTX.GET',
        'PAX_TXT.GETCH',
        'PAX_NTX.PUT',
        'PAX_TXT.PUTCH',
        'PAX_NTX.RDBIN',        'PAX_NTX.WRBIN',
        'PAX_TXT.RDIMG',        'PAX_TXT.WRIMG',
        'PAX_FVM.CLOSE',        'PAX_FVM.CLOSD',        'PAX_FVM.CLOSA',
        'PAX_NTX.EXTENT',                       (* extent for files *)
        'PAX_FIO.BREAK',
        'PAX_FIO.EMPTY',
        'PAX_TXT.PAGE',
        'PAX_TXT.CLEAR',
        'PAX_FIO.STATF',
        'PAX_FIO.STATL',
        'PAX_FIO.EXTST',
        'PAX_TXT.READ',
        'PAX_TXT.WRITE',
        'PAX_TXT.GSTR',
        'PAX_TXT.PSTF',
        'PAX_TXT.PSTV',
        'PAX_TXT.PSTD',
        'PAX_TXT.RDLN',
        'PAX_TXT.WRLN',
        'PAX_NTX.SEEK',
        'PAX_MON.STOP',
        'PAX_UTL.LCTOUC',
        'PAX_UTL.UCTOLC',
        'PAX_EXC.SET',  'PAX_EXC.RESTORE',
        'PAX_EXC.MASK', 'PAX_EXC.UNMASK',
        'PAX_EXC.TSTMASK',      'PAX_EXC.TSTPEND',
        'PAX_EXC.SIGNAL',       'PAX_EXC.RESIGNAL',
        'PAX_EXC.MATHSTAT',     'PAX_EXC.PROGSTAT',
        'PAX_EXC.SPECSTAT',     'PAX_EXC.EXIOSTAT',
        'PAX_EXC.VAXCOND',
        'FOR$DATE',
        'PAX_UTL.TIME',
        'PAX_FIO.FNAME',                        (* filename function *)
        'PAX_UTL.RUNTIM');              (* CPU time in milliseconds *)
$PAGE gen_init
(* GEN INIT initializes data used by this package. *)

public procedure gen_init;

 var
   d: def_class;

 begin
  code_area.first := nil;    code_area.last := nil;
  static_area.first := nil;  static_area.last := nil;
  cst_area.first := nil;     cst_area.last := nil;
  loc_code := 0;                        (* standard high segment base *)
  loc_static := 0;
  loc_cst := 0;                         (* latter merged into code area *)
  for d := minimum (def_class) to maximum (def_class) do begin
    def_lists[d] := nil;
    defnum [d] := 1;
  end;
 end;
$PAGE make_def
(* MAKE DEF returns an all new definition record of type "dtype" and with an
   unique identifying number.  A pointer to the record is returned. *)

public function make_def (dtype: def_class): def;
 begin
  new (make_def);
  with make_def^ do begin
    deftype := dtype;                   (* set true type *)
    next := def_lists [dtype];          (* add to list of definitions *)
    def_lists[dtype] := make_def;
    refchain := nil;
    defined := false; (* address not yet determined *)
    relocatable := false;
    first_offset := nil;
    if dtype <> extern_def then begin
      addr := 0;
      defnumber := defnum [dtype];      (* assign and advance id counter *)
      defnum [dtype] := defnum[dtype] + 1;
    end;
  end;
 end;
$PAGE get_def
(* GET DEF returns the internal definition record corresponding to the "dtype" -
   "defid" pair.  If such a record cannot be found, it is created.  This is used
   to create/lookup internal definitions for subroutine identifiers, user
   declared symbols, and local label nodes whose numbering is taken from the
   numbering made in the symbol table or if.  A pointer to the definition
   record is returned. *)

public function get_def (dtype: def_class; defid: id_range): def;
 var d: def;
 begin
  d := def_lists [dtype];               (* search for matching symbol *)
  while d <> nil do begin
    if d^.defnumber = defid then begin  (* ---> return if found *)
      get_def := d;
      return
    end;
    d := d^.next;
  end;

  get_def := make_def (dtype);          (* not found - allocate a new definition *)
  get_def^.defnumber := defid;          (* replace number assigned in make_def *)
 end;
$PAGE get_ext_or_stat

(* GET EXT OR STAT returns the internal definition record corresponding to the
   external or static symbol.  If such a record cannot be found, it is created. *)

public function get_ext_or_stat (list: def_class; symbol: sym): def;
 var d: def;
 begin
  d := def_lists [list];
  while d <> nil do begin
    if d^.symbol = symbol then begin (* ---> return if found *)
      get_ext_or_stat := d;
      return
    end;
    d := d^.next;
  end;

  get_ext_or_stat := make_def (list); (* not found - allocate a new definition *)
  get_ext_or_stat^.symbol := symbol;
 end;
$PAGE def_value
(* DEF VALUE defines the address of a definition record. *)

public procedure def_value (d: def; value: code_address; relocatable: boolean);
 var d1: def;
 begin
  d^.defined := true;
  d^.relocatable := relocatable;
  d^.addr := value;
  d1 := d^.first_offset;
  while d1 <> nil do begin
    d1^.defined := true;
    d1^.relocatable := relocatable;
    d1 := d1^.next;
  end;
 end;
$PAGE del_def_list

(* DEL DEF LIST deletes a list of definitions and resets the id number counter
   for a particular type of definition ("dtype"). *)

public procedure del_def_list (dtype: def_class);
 var d, d1, next: def;
 begin
  d := def_lists [dtype];
  while d <> nil do begin
    next := d^.next;
    d1 := d^.first_offset;
    dispose (d);
    d := next;
    while d1 <> nil do begin
      next := d1^.next;
      dispose (d1);
      d1 := next;
    end;
  end;
  def_lists [dtype] := nil;
  defnum [dtype] := 1;
 end;
$PAGE get_offset

(*  ****** This routine is never called ******

(* GET OFFSET returns an internal definition offset record for the definition
   specified by "intdef" corresponding to offset "off".  If there is already
   a record for the definition/offset pair, it is returned;  otherwise, a new
   record is created. *)

public function get_offset (intdef: def; off: integer): def;
 var od: def;
     svalue: integer;
 begin
  if off = 0 then begin                 (* offset 0 references original defintion *)
    get_offset := intdef;
    return;
  end;

  od := intdef^.first_offset;   (* search for same offset def *)
  while od <> nil do begin
    if od^.offset = off then begin      (* ---> return if offset found *)
      get_offset := od;
      return;
    end;
    od := od^.next;
  end;

  new (od, offset_def);                 (* not found, create new offset record *)
  with od^ do begin
    next := intdef^.first_offset;       (* chain to target definition *)
    intdef^.first_offset := od;
    refchain := nil;
    defined := intdef^.defined;
    relocatable := intdef^.relocatable;
    reldef := intdef;                   (* offset is relative to this definition *)
    offset := off;
  end;
  get_offset := od;
 end;

*)
$PAGE relrt, relsym, reldef
(* These four routines construct relocation syllables for runtime symbols, user
   defined symbols, internal definitions and internal labels.  They need not be
   the only routines to generate such records; they are used for convenience when
   the relocation must be explicitly constructed. *)

(*   ****** This routine is never called ******

public function relrt (rtsym: rt_symbol): reloc_value;
 begin
  relrt.kind := runtime_sc;
  relrt.relrtsym := rtsym;
 end;

*)


(*   ****** This routine is never called ******

public function relsym (s: sym): reloc_value;
 begin
  relsym.kind := s^.dcl_class;
  relsym.relsym := s;
 end;

*)


public function reldef (intdef: def): reloc_value;
 begin
  reldef.kind := def_sc;
  reldef.reldef := intdef;
 end;
$PAGE gen_origin
(* GEN ORIGIN generates an origin record with value "loc" and emits it in the
   area "arealist". *)

public procedure gen_origin (var arealist: code_list; psectid: psect_type);
 var cr: code;
 begin
  new (cr, origin);
  cr^.psect := psectid;
  gen_emit (arealist, cr);
 end;
$PAGE genindirect_word
(* GEN_INDIRECT_WORD emits a code record for the indirect word defining the
   location of the public var or const in an overlay compilation. *)

public procedure genindirect_word ( var arealist: code_list; symbol : sym );

var cr : code;

begin
  new ( cr , indirect_word );
  cr^.pub_sym := symbol;
  gen_emit ( arealist, cr )
end;
$PAGE mark_def
(* MARK DEF emits a defmark code record which defines the location for an internal
   definition denoted by "intdef".  The record is emitted in the are given by
   "area_list" . *)

public procedure mark_def (var area_list: code_list; intdef: def);
 var cr: code;
 begin
  new (cr, defmark);
  cr^.defname := intdef;
  gen_emit (area_list, cr);
 end;
$PAGE gen_source, gen_cmt
(* GEN SOURCE generates a code 'source' record and emits it in the code area. *)

public procedure gen_source (srcid: source_id);
 var cr: code;
 begin
  new (cr, source);
  cr^.stmtid := srcid;
  gen_emit (code_area, cr);
 end;



(* GEN COMMENT generates a code 'comment' record and emits in the designated
   area. *)

public procedure gen_cmt (var area_list: code_list; text: string);
 var cr: code;
 begin
  new (cr, comment, length (text));
  cr^.ctext := text;
  gen_emit (area_list, cr);
 end;
$PAGE gen_branch, gen_bb
(* GEN BRANCH generates a byte-displacement branch instruction code
   record, which is emitted in the code area.  *)
  
public procedure gen_branch (opc: opc_range; target: def);
  
  var cr: code;
  
  begin
    new (cr, instruction, 1);
    with cr^ do begin
      opcode := opc;
      noperands := 1;
      operands[1] := branch_addr (target);
      gen_emit (code_area, cr)
    end
  end;


(* GEN BB generates a BBC or BBS instruction.  *)

public procedure gen_bb ( opc: opc_range; addr1: addr_desc; addr2: addr_desc;
                          target: def );

var
  cr: code;

begin
  new ( cr, instruction, 3 );
  with cr^ do begin
    opcode := opc;
    noperands := 3;
    operands[ 1 ] := addr1;
    operands[ 2 ] := addr2;
    operands[ 3 ] := branch_addr ( target );
    gen_emit ( code_area, cr );
  end;
end  (* proc gen_bb *) ;
$PAGE gen_byte
(* GEN BYTE generates an instruction code record for a byte given the byte 
   itself ("bval"), and the area in which to emit it.  *)
  
public procedure gen_byte (var area_list: code_list; bval: byte);
  
  var cr: code;
  
  begin
    new (cr, bytelen);
    cr^.byte_value := bval;
    gen_emit (area_list, cr)
  end;
$PAGE gen_word
(* GEN WORD generates a code record for a word given the word itself ("wval"),
   and the area in which to emit it.  *)
  
public procedure gen_word (var area_list: code_list; wval: word);
  
  var cr: code;
  
  begin
    new (cr, wordlen);
    cr^.word_value := wval;
    gen_emit (area_list, cr)
  end;
$PAGE gen_longword, gen_real
(* GEN LONGWORD generates a code record for a longword given the longword
   itself ("lwval"), and the area in which to emit it.  *)
  
public procedure gen_longword (var area_list: code_list; lwval: longword);
  
  var cr: code;
  
  begin
    new (cr, fullword);
    cr^.fwd := lwval;
    gen_emit (area_list, cr)
  end;

(* GEN_REAL generates a code record for a real number given the
   precision of the real, the value itself, and the area in which
   to emit it.  *)

public procedure gen_real ( var area_list: code_list; precision: prec_type;
                            rvalue: real_type );

var
  cr: code;

begin
  if precision <= srealprec then begin
    new ( cr, realword );
    cr^.rvalue := rvalue;
  end
  else begin
    new ( cr, doubleword );
    cr^.dvalue := rvalue;
  end;
  gen_emit ( area_list, cr );
end  (* proc gen_real *) ;
$PAGE gen_opcode
(* GEN OPCODE generates a zero-operand instruction code record, which is emitted in the
   code_area.  *)
  
public procedure gen_opcode (opc: opc_range);
  
  var cr: code;
  
  begin
    new (cr, instruction, 0);
    cr^.opcode := opc;
    cr^.noperands := 0;
    gen_emit (code_area, cr)
  end;
$PAGE gen1
(* GEN1 generates a one-operand instruction code record, which is emitted
   in the code area.  *)
  
public procedure gen1 (opc: opc_range; operand: addr_desc);
  
  var cr: code;
  
  begin
    new (cr, instruction, 1);
    cr^.opcode := opc;
    cr^.noperands := 1;
    cr^.operands[1] := operand;
    gen_emit (code_area, cr)
  end;
$PAGE gen2
(* GEN2 generates a two-operand instruction code record, which is emitted
   in the code_area.  *)
  
public procedure gen2 (opc: opc_range; op1, op2: addr_desc);
  
  var cr: code;
  
  begin
    new (cr, instruction, 2);
    with cr^ do begin
      opcode := opc;
      noperands := 2;
      operands[1] := op1;
      operands[2] := op2
    end;
    gen_emit (code_area, cr)
  end;
$PAGE gen3
(* GEN3 generates a three-operand instruction code record, which is emitted
   in the code area.  *)
  
public procedure gen3 (opc: opc_range; op1, op2, op3: addr_desc);
 
  var cr: code;
  
  begin
    new (cr, instruction, 3);
    with cr^ do begin
      opcode := opc;
      noperands := 3;
      operands[1] := op1;
      operands[2] := op2;
      operands[3] := op3
    end;
    gen_emit (code_area, cr)
  end;
$PAGE gen4
(* GEN4 generates a four-operand instruction code record, which is emitted
   in the code area.  *)
  
public procedure gen4 (opc: opc_range; op1, op2, op3, op4: addr_desc);
  
  var cr: code;
  
  begin
    new (cr, instruction, 4);
    with cr^ do begin
      opcode := opc;
      noperands := 4;
      operands[1] := op1;
      operands[2] := op2;
      operands[3] := op3;
      operands[4] := op4
    end;
    gen_emit (code_area, cr)
  end;
$PAGE gen5
(* GEN5 generates a five-operand instruction code record, which is emitted
   in the code area.  *)
  
public procedure gen5 (opc: opc_range; op1, op2, op3, op4, op5: addr_desc);
  
  var cr: code;
  
  begin
    new (cr, instruction, 5);
    with cr^ do begin
      opcode := opc;
      noperands := 5;
      operands[1] := op1;
      operands[2] := op2;
      operands[3] := op3;
      operands[4] := op4;
      operands[5] := op5
    end;
    gen_emit (code_area, cr)
  end;
$PAGE gen6
(* GEN6 generates a six-operand instruction code record, which is emitted
   in the code area.  *)
  
public procedure gen6 (opc: opc_range; op1, op2, op3, op4, op5, op6: addr_desc);
  
  var cr: code;
  
  begin
    new (cr, instruction, 6);
    with cr^ do begin
      opcode := opc;
      noperands := 6;
      operands[1] := op1;
      operands[2] := op2;
      operands[3] := op3;
      operands[4] := op4;
      operands[5] := op5;
      operands[6] := op6
    end;
    gen_emit (code_area, cr)
  end;
$PAGE move_immediate
(* MOVE IMMEDIATE generates a minimal instruction to move the given value
   ("int") to the "destination".  The code record is emitted in the code area.  *)
  
public procedure move_immediate (int: integer; destination: addr_desc);
  
  var
    source: addr_desc;
    opc: opc_range;
  
  begin
    
    (* Case one: source = 0  *)

    if int = 0 then begin
      case destination.byte_size of
        vax_byte: opc := clrb;
        vax_word: opc := clrw;
        vax_long: opc := clrl;
        vax_quad: opc := clrq
     
      gen1 (opc, destination)
    end

    (* Case two:  0 < source <= 63  *)

    else if (int >= min_literal) and (int <= max_literal) then begin
      source := typ_int_value ( int, destination.byte_size );
      opc := typ_opc ( movl, destination.byte_size );
      gen2 ( opc, source, destination );
    end

    (* Case three:  -63 <= source < 0  *)

    else if (int <= -min_literal) and (int >= -max_literal) and
            (destination.byte_size <> vax_quad) then begin
      source := typ_int_value ( -int, destination.byte_size );
      opc := typ_opc ( mnegl, destination.byte_size );
      gen2 ( opc, source, destination );
    end

    (* Case four: all remaining cases.  *)

    else begin
      source := typ_int_value ( int, cons_vax_type ( int ) );
    
      case source.byte_size of
    
        vax_byte:
          case destination.byte_size of
            vax_byte: opc := movb;
            vax_word:
              if int >= 0 then
                opc := movzbw
              else
                opc := cvtbw;
            vax_long:
              if int >= 0 then
                opc := movzbl
              else
                opc := cvtbl
          end;
  
        vax_word: 
          case destination.byte_size of
            vax_byte: begin (* erroneous case! *)
              opc := movb;
              source.byte_size := vax_byte
            end;
            vax_word: opc := movw;
            vax_long:
              if int >= 0 then
                opc := movzwl
              else
                opc := cvtwl
          end;
    
        vax_long:
          case destination.byte_size of
            vax_byte: begin (* erroneous case! *)
              opc := movb;
              source.byte_size := vax_byte
            end;
            vax_word: begin (* erroneous case! *)
              opc := movw;
              source.byte_size := vax_word
            end;
            vax_long: opc := movl
          end
      end;
    
      gen2 (opc, source, destination)
    end (* else *);
  end (* move_immediate *);
$PAGE gen_string, gen_pstring
(* GEN STRING and GEN PSTRING each generate a code record for a string (pstring)
   given the string itself ("str"), and the area in which to emit it.  *)
  
public procedure gen_string (var area_list: code_list;
                                 str: packed array [1..*] of char);
  
  var cr: code;
  
  begin
    new (cr, stringword, length (str));
    cr^.strvalue := str;
    gen_emit (area_list, cr)
  end;
  
  
  
public procedure gen_pstring (var area_list: code_list;
                                  str: packed array [1..*] of char);
  
  var cr: code;
  
  begin
    new (cr, pstringword, length (str));
    cr^.strvalue := str;
    gen_emit (area_list, cr)
  end;
$PAGE gen_rm, gen_mr, gen_rr
(* These three routines are for convenience in generating specific kinds
   of two-operand instructions in the code area.  *)
  
public procedure gen_rm (opc: opc_range; reg: registers; op2: addr_desc);
  
  begin
    gen2 (opc, reg_addr (reg), op2)
  end;
  
  
 
public procedure gen_mr (opc: opc_range; op1: addr_desc; reg: registers);
  
  begin
    gen2 (opc, op1, reg_addr (reg))
  end;
  
  
  
public procedure gen_rr (opc: opc_range; reg1, reg2: registers);
  
  begin
    gen2 (opc, reg_addr (reg1), reg_addr (reg2))
  end;
$PAGE make_rt_addr

(* MAKE_RT_ADDR returns an address descriptor for a runtime symbol.  *)

public function make_rt_addr ( rt_name: rt_symbol ): addr_desc;

begin
  make_rt_addr := absolute_reference;
  with make_rt_addr do begin
    byte_size := vax_byte;      (* CALLS, JSB expect byte address *)
    reloc.kind := runtime_sc;
    reloc.relrtsym := rt_name;
  end;
end  (* proc make_rt_addr *) ;
$PAGE gen_rt
(* GEN RT generates a call to a runtime routine, given the parameter list
   size and the runtime symbol. *)

public procedure gen_rt (parlistsize: parm_range; rt_name: rt_symbol);

begin
  gen2 (calls, int_value (parlistsize), make_rt_addr ( rt_name ) );
end;
$PAGE gen_displacement
(* GEN DISPLACEMENT generates a code record for a displacement of "size"
   bits from "fdef" to   "tdef".  The record is emitted in the code area.  *)
 
public procedure gen_displacement (fdef, tdef: def; size: elem_sizes);
  
  var cr: code;
 
  begin
    new (cr, displacement);
    cr^.from_def := fdef;
    cr^.to_def := tdef;
    cr^.disp_size := size;
    gen_emit (code_area, cr)
  end;
$PAGE gen_mask
(* GEN MASK generates a code record for a register save mask.  A pointer to the
   block node which contains the set of registers to save is stored in the
   code record.  *)

public procedure gen_mask (blkptr: blk);

var
  cr: code;
begin
  new (cr, maskword);
  cr^.block := blkptr;
  gen_emit (code_area, cr);
end;
$PAGE skip_bytes
(* SKIP BYTES emits null byte code records in "area_list" to fill space within
   a structure for which no initial values have been provided.  *)
  
public procedure skip_bytes (var area_list: code_list; var actual_offset: bit_range;
                          desired_offset: bit_range);
  
  begin
    while actual_offset < desired_offset do begin
      gen_byte (area_list, 0);
      actual_offset := actual_offset + bits_per_byte
    end
  end;
$PAGE gen_vnode
(* GEN VNODE allocates one or more FULLWORDs, STRINGWORDs or
   SETBYTEs in the specified area to represent the specified
   value. *)

public procedure gen_vnode(var area_list: code_list; value: val_ptr; vals_type: typ);
  
  var
   cur_offset: bit_range;                       (* offset within "value" *)
 
$PAGE find_variant - in gen_vnode
(* FIND VARIANT is given a type node of kind RECORDS or VARIANTS and
   an integer representing a tag field value.  It returns the type node
   of the variant corresponding to the tag value.  NIL is returned if no
   such variant is found.  The record or variant whose type is passed
   in must contain a variant part. *)

function find_variant (recvar: typ; tag_val: integer): typ;

var
  cur_variant: typ;

 begin
  find_variant := nil;                          (* updated if variant found or
                                                   if others case found *)
  cur_variant := recvar^.variant_tag^.first_variant;
  while cur_variant <> nil do begin
    with cur_variant^ do begin
      if others_var 
        then find_variant := cur_variant
      else if (minlab <= tag_val) and (tag_val <= maxlab)
        then begin
          find_variant := cur_variant;
          return                                (* <--- exit here if specific variant found *)
        end;
      cur_variant := next_variant
    end (* with *);
  end (* while *);
 end;
$PAGE gen_component - in gen_vnode
(* GEN COMPONENT initializes code words to correspond to the value
   represented by VALUE.  BASE_OFFSET contains the bit offset, within the
   constant currently being generated, at which the value should be
   placed.  BASE_WIDTH is the width in bits of the constant represented
   by VALUE. *)

procedure gen_component (value: val_ptr; base_offset: bit_range;
                         base_width: bit_range);

 var
   i, j: integer;                              (* for loop indices *)
   max_bit: bit_offset;                         (* high bit used in set packing *)
   field_sym: sym;                              (* current field's sym *)
   cur_recvar: typ;                             (* record/variant containing FIELD_SYM *)
   is_tag: boolean;                             (* true => FIELD_SYM is tag *)
   field_number: unit_range;                    (* number of current field *)
   num_elems: integer;                         (* number of elements of array *)
   elems_per_unit: elem_sizes;                  (* array elements per unit *)
   bits_per_elem: bit_range;                    (* bits required per array element *)
   word_offset: unit_range;                     (* word offset of array element within array *)
   bits_offset: bit_offset;                     (* bit offset of start of an array element*)
   offset: bit_range;                           (* offset within constant of component of VALUE *)
   cr: code;                                    (* ptr for setting up set code records *)
$PAGE gen_subval - in gen_component
(* GEN SUBVAL generates a value corresponding to an array element
   or a record field.  Scalar and pointer constants are generated
   immediately; other VALUE_KINDs cause GEN_COMPONENT to be called
   recursively.  OFFSET is the base offset of the value within the
   current constant in bits and WIDTH is the value's width in bits. *)

procedure gen_subval ( val_recd: val; offset: bit_range; width: bit_range );

  begin
    skip_bytes (area_list, cur_offset, offset);
    with val_recd do begin
      case kind of

        scalar_cst:
          begin
            case width of
              bits_per_byte: gen_byte (area_list, ival);
              bits_per_word: gen_word (area_list, ival);
              bits_per_unit: gen_longword (area_list, ival)
            end;
            cur_offset := cur_offset + width
          end;

        real_cst,
        string_cst,
        set_cst,
        array_cst,
        record_cst:
          begin
            gen_component( valp, offset, width )
          end;

        ptr_cst:
          begin
            gen_longword (area_list, int_nil);
            cur_offset := cur_offset + bits_per_address
          end;

        subr_cst:                                       (* illegal !!! *)

      end (* case *)
    end (* with *)
  end; (* procedure gen_subval *)
$PAGE gen_component - body

 begin
  skip_bytes (area_list, cur_offset, base_offset);
  if base_width = 0 then
    return;
  with value^ do begin
    case kind of

      scalar_cst:
        begin
          case base_width of
            bits_per_byte: gen_byte (area_list, scalar_val);
            bits_per_word: gen_word (area_list, scalar_val);
            bits_per_unit: gen_longword (area_list, scalar_val)
          end;
          cur_offset := cur_offset + base_width
        end;

      real_cst:
        begin
          if real_prec > srealprec then begin
            new (cr, doubleword);
            cr^.dvalue := real_val;
            cur_offset := cur_offset + bits_per_double
          end
          else begin
            new (cr, realword);
            cr^.rvalue := real_val;
            cur_offset := cur_offset + bits_per_float
          end;
          gen_emit (area_list, cr)
        end;

      string_cst:
        if str_varying_ref then begin
          gen_string( area_list, str_val );
          cur_offset := cur_offset + str_lw_width + length (str_val) * char_size
        end
        else begin
          gen_pstring( area_list, str_val );
          cur_offset := cur_offset + length (str_val) * char_size
        end;

      set_cst:
        begin
          for i := 1 to (dimension (set_val) + set_origin mod bits_per_byte + bits_per_byte - 1)
                          div bits_per_byte do begin
            new (cr, setbyte);
            max_bit := min (bits_per_byte - 1, 
              dimension (set_val) + set_origin mod bits_per_byte - ( (i - 1) * bits_per_byte) - 1);
            for j := 0 to max_bit do
              if ((i-1) * bits_per_byte + j) < set_origin mod bits_per_byte then
                cr^.setval[j] := false
              else
                cr^.setval[j] := set_val[(i - 1) * bits_per_byte + j - set_origin mod bits_per_byte];
            if max_bit < (bits_per_byte - 1) then
              for j := max_bit + 1 to bits_per_byte - 1 do
                cr^.setval[j] := false;
            gen_emit (area_list, cr);
            cur_offset := cur_offset + bits_per_byte
          end;
        end;

      array_cst:
        begin
          with struc_type^ do begin
            num_elems := index_type^.maxval - index_type^.minval + 1;
            if element_size <= bits_per_byte 
              then elems_per_unit := bits_per_byte div element_size
              else bits_per_elem :=
                ( (element_size + bits_per_byte - 1) div bits_per_byte ) * bits_per_byte;

            for i := 1 to min (upperbound (elem_vals), num_elems) do begin
              if element_size <= bits_per_byte then begin
                word_offset := (i - 1) div elems_per_unit;
                bits_offset := ( (i-1) mod elems_per_unit ) * element_size;
                offset :=
                  base_offset + (word_offset * bits_per_byte) + bits_offset
              end
              else
                offset := base_offset + (bits_per_elem * (i - 1));
              gen_subval (elem_vals[i], offset, element_size)
            end (* for *)
          end (* with *)
        end (* array_cst case *);

      record_cst:
        begin
          field_sym := struc_type^.field_list;
          cur_recvar := struc_type;
          field_number := 0;
          offset := base_offset;

          repeat                                (* traverse appropriate sym records *)

            (* if starting new variant then find correct variant type record
               and its first field *)
  
            while ( (cur_recvar^.field_list = nil) andif
                    (cur_recvar^.variant_tag <> nil) ) orif
                  ( (field_sym <> nil) andif
                    (cur_recvar <> field_sym^.fld_variant) ) do begin
              field_number := field_number + 1;
              if field_number > upperbound (elem_vals) then return;
              cur_recvar := find_variant (cur_recvar, elem_vals[field_number].ival);
              if cur_recvar <> nil 
                then field_sym := cur_recvar^.field_list
                else return;
              if field_sym <> nil then cur_recvar := field_sym^.fld_variant
            end;

            (* is this a tag field? *)
  
            is_tag := (cur_recvar^.variant_tag <> nil) andif
                      (field_sym = cur_recvar^.variant_tag^.tag_field);

            (* process the current field *)

            field_number := field_number + 1;
            if field_number > upperbound (elem_vals) then return;
            if field_sym <> nil then begin
              offset := base_offset + field_sym^.fld_offset;

              (* Code to support constant records containing flex strings,
                 and/or flex arrays *)

              With FIELD_SYM^.TYPE_DESC^ Do Begin
                If FLEXIBLE And ( KIND in [ ARRAYS , STRINGS ] ) Then Begin
                  (* Match offset and cur_offset just in case the item before
                     the array or record was an incomplete constant 'cause
                     we are now going to put out the upb word *)
                  SKIP_BYTES ( AREA_LIST , CUR_OFFSET , OFFSET );
                  With VALUE^.ELEM_VALS [ FIELD_NUMBER ].VALP^ Do
                    If KIND = ARRAY_CST
                      Then Begin
                        GEN_LONGWORD ( AREA_LIST , STRUC_TYPE^.INDEX_TYPE^.MAXVAL );
                        OFFSET := OFFSET + FLEX_ARR_DESC_SIZE
                      End
                    Else Begin
                      GEN_WORD ( AREA_LIST , Length (STR_VAL) );
                      OFFSET := OFFSET + FLEX_STR_DESC_SIZE
                    End;
                  CUR_OFFSET := OFFSET  (* Same after GEN_WORD or GEN_LONG *)
                End             (* If FLEXIBLE ... *)
              End;              (* With FIELD ... *)

              gen_subval(value^.elem_vals[field_number], offset, field_sym^.fld_width)
            end;
            if is_tag then field_number := field_number - 1;

            (* get next field and check whether or not we are done *)

            if field_sym <> nil then begin
              field_sym := field_sym^.next;
              if (field_sym <> nil) andif (field_sym^.fld_variant <> cur_recvar) andif
                 (cur_recvar^.variant_tag = nil)
                then field_sym := nil
            end
          until field_sym = nil
        end (* record_cst case *)

      end (* case *)
    end (* with *)
end;
$PAGE bits_required in gen_vnode
(* BITS REQUIRED returns the size in bits of the constant described by "value".  *)

function bits_required (value: val_ptr; vals_type: typ): bit_range;

  begin
    with value^ do
      case kind of

        scalar_cst:
          if vals_type^.kind in [bools, chars] then
            bits_required := bits_per_byte
          else if vals_type^.kind = scalars then begin
            if vals_type^.base_type^.base_size <= bits_per_byte then
              bits_required := bits_per_byte
            else if vals_type^.base_type^.base_size <= bits_per_word then
              bits_required := bits_per_word
            else
              bits_required := bits_per_unit
          end
          else if (vals_type^.kind = ints) and vals_type^.packable then begin
            if vals_type^.base_size <= bits_per_byte
              then bits_required := bits_per_byte
            else if vals_type^.base_size <= bits_per_word
              then bits_required := bits_per_word
            else bits_required := bits_per_integer;
          end
          else
            bits_required := bits_per_unit;

        real_cst:
          if real_prec > srealprec 
            then bits_required := bits_per_double
            else bits_required := bits_per_float;

        string_cst:
          begin
            bits_required := length (str_val) * char_size;
            if str_varying_ref then bits_required := bits_required + str_lw_width
          end;

        set_cst:
          if dimension (set_val) = 0 then
            bits_required := 0
          else
            bits_required := ngm (dimension (set_val) + set_origin mod bits_per_byte, bits_per_byte);

        array_cst,
        record_cst:
          bits_required := struc_type^.base_size

      end (* case *) ;
  end;
$PAGE gen_vnode - main routine
(* GEN_VNODE main routine *)

const
  init_offset: bit_range := 0;

var
  width: bit_range;

begin
  width := bits_required (value, vals_type);
  cur_offset := 0;
  gen_component ( value, init_offset, width);
  skip_bytes (area_list, cur_offset, width)
end;
$PAGE gen_val
(* GEN VAL allocates one or more FULLWORDs, STRINGWORDs or SETBYTEs in 
   the specified area to represent the specified values.  It is identical 
   to GEN_VNODE except that it takes a VAL record as a
   parameter rather than a VAL_PTR. *)

public procedure gen_val (var area_list: code_list; value: val; vals_type: typ);

  var
    datum_width: bit_range;
    datum_alignment: align_range;

  begin
    with value do begin
      case kind of

        scalar_cst: begin
	  alc_data (vals_type, datum_width, datum_alignment);
	  if datum_width <= bits_per_byte then
	    gen_byte (area_list, ival)
	  else if datum_width <= bits_per_word then
	    gen_word (area_list, ival)
	  else
	    gen_longword (area_list, ival)
	end;

        real_cst,
        string_cst,
        set_cst,
        array_cst,
        record_cst:
          begin
            gen_vnode (area_list, valp, vals_type)
          end;

        ptr_cst:
          gen_longword (area_list, int_nil);

        others:
          assert ( false )

      end (*case *)
    end (* with *)
  end;
$PAGE gen_cnode
(* GEN CNODE allocates the specified value in the constant area, and
   returns a DEF_SC relocation syllable for a definition node referring
   to the first word of the constant *)

public function gen_cnode (value: val_ptr; vals_type: typ): reloc_value
  options special(coercions);

  var
    cons_def: def;

  begin
    if value^.def_addr = nil then begin
      cons_def := make_def (constant_def);
      mark_def (cst_area, cons_def);
      gen_vnode (cst_area, value, vals_type);
      gen_cnode := reldef (cons_def);
      value^.def_addr := val_ptr (cons_def)
    end 
    else
      gen_cnode := reldef (def (value^.def_addr))
  end;

$PAGE gen_cval
(* GEN CVAL allocates the specified value in the constant area, and
   returns a DEF_SC relocation syllable for a definition node referring
   to the first word of the constant.  This routine is identical to
   GEN_CNODE except that it takes a VAL record as a parameter rather
   than a VAL_PTR. *)

public function gen_cval (value: val; vals_type: typ): reloc_value
  options special(coercions);

  const
    has_ptr: set of value_kind = [real_cst, string_cst, set_cst, array_cst, record_cst];

  var
    cons_def: def;
    prev_emitted: boolean;

  begin
    with value do begin

      (* If previously generated, pick up DEF saved at that time. *)

      if kind = alloc_cst then
        gen_cval := reldef (def (defp))
      else if (kind in has_ptr) andif (valp^.def_addr <> nil) then
        gen_cval := reldef (def (valp^.def_addr))

      (* Generate it now. *)

      else begin
        cons_def := make_def (constant_def);
        mark_def (cst_area, cons_def);
        gen_val (cst_area, value, vals_type);
        gen_cval := reldef (cons_def);
        if kind in has_ptr then
          valp^.def_addr := val_ptr(cons_def)
      end
    end (* with *)
  end;
$PAGE gen_cst

(* GEN_CST generates a scalar value (parameter VALUE) in the constant
   area and returns an address descriptor for the location in the
   constant area.  The size of the field in which the constant is 
   generated is indicated by parameter VTYPE.  *)

public function gen_cst ( value: integer; vtype: vax_type ): addr_desc;

var
  cons_def: def;

begin
  gen_cst := absolute_reference;
  cons_def := make_def ( constant_def );
  mark_def ( cst_area, cons_def );

  if vtype = vax_byte
    then gen_byte ( cst_area, value )
  else if vtype = vax_word
    then gen_word ( cst_area, value )
  else if vtype = vax_long
    then gen_longword ( cst_area, value )
  else assert ( false );

  gen_cst.reloc := reldef ( cons_def );
  gen_cst.byte_size := vtype;
end  (* proc gen_cst *) .
  ]@P]