(*********     Initialization -- Machine-dependent Declarations

**********     VAX/VMS

*********)


module aevimd;

$SYSTEM pascal.inc
$SYSTEM pasist.inc
$SYSTEM pasdat.inc
$SYSTEM pasini.inc
$SYSTEM ptmimd.typ


public const
    mword_size: integer = 16;
    max_real: real_type = 1.7e+38;
    max_char: integer = #Hff;
    fnamsize: integer = 125;
    fnamextern: extname = 'FNAME.';
    trnamextern: extname = 'TRACE';
    condnamextern: condnames = ( '', '', '', '', '', '', '' );
$PAGE target machine constants
$INCLUDE ptmcon.inc
$PAGE sys_ppf

(*  SYS PPF will enter the system-dependent predefined procedures and functions
    into the initial symbol table.  *)

public procedure sys_ppf;

begin
end;
$PAGE init_tal_tables
(*  INIT TAL TABLES initializes the type allocation tables used by PASTAL.  *)

external var tal_tables: save_pointer;

procedure init_tal_tables options special(coercions);

$INCLUDE pastal.prm
$PAGE
type
    x_packing_table = array [packing_contexts] of integer;

static var
    r_8_8_8     : rule_node := ( nil, 8, 8, 8 );
    r_16_16_16  : rule_node := ( nil, 16, 16, 16 );
    r_32_16_32	: rule_node := ( nil, 32, 16, 32);
    r_64_16_64	: rule_node := ( nil, 64, 16, 64);
    r_all_16_16 : rule_node := ( nil, maximum (bit_range), 16, 16 );
    r_all_16_32 : rule_node := ( nil, maximum (bit_range), 16, 32 );
    r_all_16_64 : rule_node := ( nil, maximum (bit_range), 16, 64 );

    rules: array [1..6] of rule;

procedure make_rules;
begin
  new (rules [1]);	(* Rule 1 - *)
  rules [1]^ := r_all_16_16;	(*    0..*:  16, 16 *)

  new (rules [2]);	(* Rule 2 - *)
  rules [2]^ := r_8_8_8;	(*    0..8:  8, 8 *)
  rules [2]^.next := rules [1];	(*    9..*:  16, 16 *)
 
  new (rules [3]);	(* Rule 3 - *)
  rules [3]^ := r_16_16_16;	(*    0..16:  16, 16 *)
  new (rules [3]^.next);
  rules [3]^.next^ := r_32_16_32;	(*    17..32:  16, 32 *)
  new (rules [3]^.next^.next);
  rules [3]^.next^.next^ := r_64_16_64;	(*    33..64:  16, 64 *)
  rules [3]^.next^.next^.next := rules [1];	(*    65..*:  16, 16 *)

  new (rules [4]);	(* Rule 4 - *)
  rules [4]^ := r_all_16_64;	(*    0..*:  16, 64 *)

  new (rules [5]);	(* Rule 5 - *)
  rules [5]^ := r_32_16_32;	(*    0..32:  16, 32 *)
  new (rules [5]^.next);
  rules [5]^.next^ := r_all_16_64;	(*    33..*:  16, 64 *)

  new (rules [6]);	(* Rule 6 - *)
  rules [6]^ := r_16_16_16;	(*   0..16:  16, 16 *)
  new (rules [6]^.next);
  rules [6]^.next^ := r_all_16_32;	(*    17..*:  16, 32 *)
end (* make_rules *);
$PAGE
static var
    x_efw: bit_range := 16;
    x_efa: bit_range := 8;

    x_str_lw_width: bit_range := 16;
    x_str_char_size: bit_range := 8;

    x_real_base_size: array [prec_type] of bit_range :=
      ( 32, 32, 32, 32, 32, 32, 32, 32, 64, 64, 64, 64, 64, 64, 64, 64 );
    x_pointer_base_size: bit_range := 32;
    x_file_base_size: bit_range := 32;
    x_subr_base_size: bit_range := 48;

    x_allocation_tables: array [type_kind] of x_packing_table :=
      ( ( 2, 1, 1, 1, 1 ),	(* scalars *)
	( 2, 1, 1, 1, 1 ),	(* bools *)
	( 2, 1, 1, 1, 1 ),	(* chars *)
	( 2, 1, 1, 1, 1 ),	(* unsigned integers *)
	( 5, 5, 5, 5, 1 ),	(* reals *)
	( 3, 3, 3, 3, 1 ),	(* sets *)
	( 6, 6, 6, 6, 1 ),	(* pointers *)
	( 6, 6, 6, 6, 1 ),	(* files *)
	( 3, 3, 3, 3, 1 ),	(* non-varying strings *)
	( 3, 3, 3, 3, 1 ),	(* arrays *)
	( 3, 3, 3, 3, 1 ),	(* records *)
	( 3, 3, 3, 3, 1 ),	(* variants *)
        ( 3, 3, 3, 3, 1 ),	(* tags *)
	( 4, 4, 4, 4, 1 ),	(* procs *)
	( 4, 4, 4, 4, 1 ),	(* funcs *)
	( 3, 3, 3, 3, 1 ),	(* unknown_type *)
	( 3, 3, 3, 3, 1 ) );	(* indirect_type *)
    x_packed_scalar_rules: array [scalars..chars] of x_packing_table :=
      ( ( 2, 1, 1, 1, 1 ), (* scalars *)
	( 2, 1, 1, 1, 1 ), (* bools *)
	( 2, 1, 1, 1, 1 ) ); (* chars *)
    x_integer_rules: array [boolean (* signed *), boolean (* packed *)] of x_packing_table :=
    ( ( ( 1, 1, 1, 1, 1 ), (* unsigned / unpacked *)
	( 2, 1, 1, 1, 1 ) ), (* unsigned /   packed *)
      ( ( 1, 1, 1, 1, 1 ), (*   signed / unpacked *)
	( 1, 1, 1, 1, 1 ) ) ); (*   signed /   packed *)
    x_var_string_rules: x_packing_table :=
	( 3, 3, 3, 3, 1 );	(* varying strings *)
    x_arr_desc_rules: x_packing_table :=
	( 1, 1, 1, 1, 1 );	(* array descriptors *)
    x_str_desc_rules: x_packing_table :=
	( 1, 1, 1, 1, 1 );	(* string descriptors *)

    x_pl_base: bit_range := 32;

    x_rv_addr_loc: rv_loc_type := rv_at_start;
    x_rv_value_loc: rv_loc_type := rv_nowhere;

    x_a_prm_size: bit_range := 32;
    x_a_prm_alignment: align_range := 16;

    x_pba_types: set of type_kind := [];
    x_pbv_limit: bit_range := 64;
    x_pba_retsym: boolean := false;
$PAGE
$INCLUDE pastal.ini
$PAGE init_alc_tables
(*  INIT ALC TABLES initializes the storage allocation tables used by PASALC.  *)

external var alc_tables: save_pointer;

procedure init_alc_tables options special(coercions);
$PAGE
$INCLUDE pasalc.prm
$PAGE
static var
    x_alc_area_descs: array [area_class] of area_desc :=
      ( ( 0, true ), (* initialized static *)
	( 0, true ), (* uninitialized static *)
	( 0, true ), (* condition cells *)
	( 3,  true), (* positive stack area - local variables *)
	( 0, false) ); (* negative stack area - unused *)

    x_loc_area: local_areas := pos_stack_area;
    x_retsym_loc: array [boolean (* passed by address *)] of rv_loc_type :=
      ( ( false, false, false ), ( true, false, true ) );
    x_parmlist_loc: array [boolean (* size <= limit *)] of pl_loc_type :=
      ( ( neg_stack_area, true ), ( neg_stack_area, true ) );
    x_pl_size_limit: unit_range := 0;
    x_parm_ptr_size: unit_range := 4;
    x_basic_alignment: align_range := 2;
    x_cond_size: unit_range := 2;
    x_cond_alignment: align_range := 2;
$PAGE
$INCLUDE pasalc.ini
$PAGE tm_constants
(*  TM_CONSTANTS will initialize the PTMCON variables to values which
    characterize the target machine.  *)

public procedure tm_constants;

begin
  tmprefix := 'AEV';
  ttyiname := 'TTY.';
  ttyoname := 'TTY.O';
  rel_extension := 'OBJ';
  have_checkout := true;
  have_optimizer := false;
  radix := hex_radix;
  adr_width := 8;
  srealprec := 8;
  set_lwb_limit := 0;
  set_upb_limit := 32767;
  set_size_limit := 32768;
  set_lquantum := 16;
  set_uquantum := 16;
  set_lbase := maximum (integer);
  set_ubase := minimum (integer);
  byte_size := 8;
  int_prec_limit := 16;
  qbl_allowed := true;

  init_tal_tables;
  init_alc_tables;
end (* tm_constants *);
$PAGE dcl_stt_constants
(* DCL SCONSTS will declare the elements of the scalar status types.  *)

public procedure dcl_sconsts;

begin
  stt_constant ('IO_OK'  , stat_io, 0);
  stt_constant ('IO_NOVF', stat_io, 1);
  stt_constant ('IO_POVF', stat_io, 2);
  stt_constant ('IO_DGIT', stat_io, 3);
  stt_constant ('IO_GOVF', stat_io, 4);
  stt_constant ('IO_INTR', stat_io, 5);
  stt_constant ('IO_REWR', stat_io, 6);
  stt_constant ('IO_EOF' , stat_io, 7);
  stt_constant ('IO_OUTF', stat_io, 8);
  stt_constant ('IO_INPF', stat_io, 9);
  stt_constant ('IO_SEEK', stat_io, 10);
  stt_constant ('IO_ILLC', stat_io, 11);
  stt_constant ('IO_NEMP', stat_io, 12);
  stt_constant ('IO_OPNF', stat_io, 13);

  stt_constant ('MATH_OK',		stat_math, 0);

  stt_constant ('PROGRAM_OK',		stat_program, 0);
  stt_constant ('PROGRAM_ASSERTION',	stat_program, 1);
  stt_constant ('PROGRAM_CASE',		stat_program, 2);
  stt_constant ('PROGRAM_COMPATIBILITY',stat_program, 3);
  stt_constant ('PROGRAM_FILE',		stat_program, 4);
  stt_constant ('PROGRAM_POINTER',	stat_program, 5);
  stt_constant ('PROGRAM_SUBSTRING',	stat_program, 6);
  stt_constant ('PROGRAM_SUBSCRIPT',	stat_program, 7);
  stt_constant ('PROGRAM_VALUE',	stat_program, 8);

  stt_constant ('SPECIAL_OK',		stat_special, 0);
end.
   