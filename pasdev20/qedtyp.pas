$INCLUDE QERR.TYP
$INCLUDE QSTR.TYP
$INCLUDE QSPAT.TYP
$INCLUDE QSPRED.TYP
$INCLUDE RLB:CMDUTL.TYP
$INCLUDE QEDLN.TYP
$INCLUDE QSPLIT.TYP
$INCLUDE QED.TYP
$INCLUDE RLB:FILUTL.INC
$INCLUDE QSUBST.INC

type
  rangetypes =
    ( one, dollar, dot, dotp1, lb, lbp1);

$INCLUDE RLB:LOOKUP.TYP

type
  rangelist =
    record
      lbound, hbound1, hbound2: rangetypes;
      required, permitted: 0..2
    end;


  qcmdlist = array [qedcmds] of cmdlist;

  sub_opt_list = array [sub_options] of cmdlist;

  split_op_list = array [split_options] of cmdlist;

  set_par_list = array [set_params] of cmdlist;

  defrangelist = array [qedcmds] of rangelist;


public const qcmds: qcmdlist :=
     (  ( 'APPEND',	1 ),
	( 'CHANGE',	1 ),
	( 'DELETE',	1 ),
	( 'INSERT',	1 ),
	( 'EDIT',	4 ),
	( 'MODIFY',	6 ),
	( 'LOAD',	1 ),
	( 'PRINT',	1 ),
	( 'SUBSTITUTE',	1 ),
        ( 'AFTER',      2 ),
        ( 'BEFORE',     2 ),
	( 'WRITE',	1 ),
	( 'SAVE',	2 ),
	( 'FIND',	1 ),
	( 'GOTO',	2 ),
	( 'RESET',	5 ),
	( 'JOIN',	1 ),
	( 'COPY',	2 ),
	( 'MOVE',	2 ),
	( 'TRANSFER',	1 ),
	( 'BOUND',	1 ),
	( 'LIST',	2 ),
	( '=',		1 ),
	( 'NUMBER',	1 ),
	( 'OPEN',	4 ),
	( 'OUTPUT',	6 ),
	( 'CLOSE',	5 ),
	( 'SET',	2 ),
	( 'SPLIT',	2 ),
	( 'QUIT',	1 ),
	( 'EXIT',	2 ),
	( '^',		1 ),
	( 'WHY',	3 ),
	( 'INDENT',	3 )   );

public const defrange: defrangelist :=
     (  ( (* APPEND *)	   dollar,	lb,	lb,	0,	1 ),
	( (* CHANGE *)	   dot,		lb,	lb,	1,	2 ),
	( (* DELETE *)	   dot,		lb,	lb,	1,	2 ),
	( (* INSERT *)	   dotp1,	lb,	lb,	0,	1 ),
	( (* EDIT *)	   dotp1,	lb,	lb,	0,	1 ),
	( (* MODIFY *)	   dotp1,	lb,	lb,	0,	1 ),
	( (* LOAD *)	   dot,		dot,	dot,	0,	0 ),
	( (* PRINT *)	   one,		dollar,	lb,	0,	2 ),
	( (* SUBSTITUTE *) dot,		lb,	lb,	0,	2 ),
        ( (* AFTER *)      dot,         lb,     lb,     0,      2 ),
        ( (* BEFORE *)     dot,         lb,     lb,     0,      2 ),
	( (* WRITE *)	   one,		dollar,	lb,	0,	2 ),
	( (* SAVE *)	   one,		dollar,	lb,	0,	2 ),
	( (* FIND *)	   one,		dollar,	lb,	0,	2 ),
	( (* GOTO *)	   dot,		lb,	lb,	1,	1 ),
	( (* RESET *)	   dot,		dot,	dot,	0,	0 ),
	( (* JOIN *)	   dot,		dot,	lbp1,	2,	2 ),
	( (* COPY *)	   dot,		lb,	lb,	0,	2 ),
	( (* MOVE *)	   dot,		lb,	lb,	0,	2 ),
	( (* TRANSFER *)   dot,		lb,	lb,	0,	2 ),
	( (* BOUND *)	   one,		dollar,	lb,	0,	2 ),
	( (* LIST *)	   one,		dollar,	lb,	0,	2 ),
	( (* = *)	   dot,		lb,	lb,	0,	1 ),
	( (* NUMBER *)	   dot,		lb,	lb,	0,	1 ),
	( (* OPEN *)	   dot,		dot,	dot,	0,	0 ),
	( (* OUTPUT *)	   dot,		lb,	lb,	0,	2 ),
	( (* CLOSE *)	   dot,		dot,	dot,	0,	0 ),
	( (* SET *)	   dot,		dot,	dot,	0,	0 ),
	( (* SPLIT *)	   dot,		lb,	lb,	0,	2 ),
	( (* QUIT *)	   dot,		dot,	dot,	0,	0 ),
	( (* EXIT *)	   dot,		dot,	dot,	0,	0 ),
	( (* ^ *)	   dot,		lb,	lb,	0,	0 ),
	( (* WHY *)	   dot,		dot,	dot,	0,	0 ),
	( (* INDENT *)     dot,		lb,	lb,	0,	2 )   );

public const sops: sub_opt_list :=
     (	( 'CONFIRM',	1 ),
	( 'ALL',	1 ),
	( 'PRINT',	1 ),
	( 'NUMBER',	1 )   );

public const splitops: split_op_list :=
     (	( 'NUMBER',	1 ),
	( 'CONFIRM',	1 ),
	( 'PRINT',	1 ),
	( 'ALL',	1 ),
	( 'DELETE',	1 )   );

public const setparams: set_par_list :=
     (	( 'DELLIMIT',	3 ),
	( 'LINECOUNT',	4 ),
	( 'MARK',	4 ),
	( 'TABS',	3 ),
	( 'WILDCARD',	4 )	);

procedure worthless;

begin
end.
 