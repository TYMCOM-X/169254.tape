$PAGE QEDTYP -- Public Constants for QED
(* QEDTYP.PAS - modified 10/09/81 by djm to add CASE to SETPARAMS.  *)
(*            - modified 04/29/82 by djm to change qcmdlist, sub_opt_list,
                split_op_list, and set_par_list to use the new procedure
                cmd_lookup.  *)

module qedtyp
  options special;

public const qcmds: qcmdlist :=
     (  ( 'APPEND',	1, ord (append) ),
	( 'CHANGE',	1, ord (change) ),
	( 'DELETE',	1, ord (delete) ),
	( 'INSERT',	1, ord (insert) ),
	( 'EDIT',	4, ord (edit) ),
	( 'MODIFY',	6, ord (modify) ),
	( 'LOAD',	1, ord (load) ),
	( 'PRINT',	1, ord (print) ),
	( 'SUBSTITUTE',	1, ord (substitute) ),
        ( 'AFTER',      2, ord (after) ),
        ( 'BEFORE',     2, ord (before) ),
	( 'WRITE',	1, ord (writecmd) ),
	( 'SAVE',	2, ord (save) ),
	( 'FIND',	1, ord (find) ),
	( 'GOTO',	2, ord (gotocmd) ),
	( 'RESET',	5, ord (resetcmd) ),
	( 'JOIN',	1, ord (join) ),
	( 'COPY',	2, ord (copy) ),
	( 'MOVE',	2, ord (move) ),
	( 'TRANSFER',	1, ord (transfer) ),
	( 'BOUND',	1, ord (bound) ),
	( 'LIST',	2, ord (list) ),
	( '=',		1, ord (eqcmd) ),
	( 'NUMBER',	1, ord (number) ),
	( 'OPEN',	4, ord (opencmd) ),
	( 'OUTPUT',	6, ord (outputcmd) ),
	( 'CLOSE',	5, ord (closecmd) ),
	( 'SET',	2, ord (setcmd) ),
	( 'SPLIT',	2, ord (split) ),
	( 'QUIT',	1, ord (quit) ),
	( 'EXIT',	2, ord (exitcmd) ),
	( '^',		1, ord (uparrow) ),
	( 'WHY',	3, ord (why) ),
	( 'INDENT',	3, ord (indent) )   );

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
     (	( 'CONFIRM',	1, ord (confirm_sop) ),
	( 'ALL',	1, ord (all_sop) ),
	( 'PRINT',	1, ord (print_sop) ),
	( 'NUMBER',	1, ord (number_sop) )   );

public const splitops: split_op_list :=
     (	( 'NUMBER',	1, ord (number_splitop) ),
	( 'CONFIRM',	1, ord (confirm_splitop) ),
	( 'PRINT',	1, ord (print_splitop) ),
	( 'ALL',	1, ord (all_splitop) ),
	( 'DELETE',	1, ord (delete_splitop) )   );

public const setparams: set_par_list :=
     (	( 'DELLIMIT',	3, ord (del_param) ),
	( 'LINECOUNT',	4, ord (lcnt_param) ),
	( 'MARK',	4, ord (mark_param) ),
	( 'TABS',	3, ord (tab_param) ),
        ( 'WILDCARD',   4, ord (wild_param) ),
        ( 'CASE',       4, ord (case_param) )     );

public const lexcon: caller_list :=
     (	( 'AND',	3, ord (and_tok) ),
	( 'OR',		2, ord (or_tok) ),
        ( 'NOT',        3, ord (not_tok) )     );

public procedure worthless;

begin
end.
 