$PAGE	QED -- General Environment Module
(* QEDENV.PAS - created 10/07/81 by djm *)
(*            - modified 04/29/82 by djm to delete lookup.typ, add
                cmdutl.inc, add qedtyp.typ, and add qsubst.typ.
                These are to allow calls to cmd_lookup. *)
(*            - Modified 7/29/82 by WNH to add qterm and
		qtprnt.  These are to consolidate tty references
		so that other QEDLIB users can provide their own
		hardware drivers for other display devices. *)

(*		8/30/82 WNH added QLANG, to help with prompt displays
		in languages other than English. *)
ENVMODULE QEDENV;
$SYSTEM cmdutl
$SYSTEM qlang.typ
$SYSTEM qerr.typ
$SYSTEM qstr.typ
$SYSTEM qspat.typ
$SYSTEM qspred.typ
$SYSTEM cmdutl.typ
$SYSTEM qedln.typ
$SYSTEM qline.typ
$SYSTEM qld.typ
$SYSTEM qed.typ
$SYSTEM qsplit.typ
$SYSTEM qsubst.typ
$SYSTEM qedtyp.typ
$SYSTEM filutl
$SYSTEM qterm
$SYSTEM query
$SYSTEM qspat
$SYSTEM qspred
$SYSTEM qlang
$SYSTEM qilang
$SYSTEM qederr
$SYSTEM qld
$SYSTEM qread
$SYSTEM qedln
$SYSTEM qmark
$SYSTEM qprint
$SYSTEM qtprnt
$SYSTEM qsubst
$SYSTEM qjoin
$SYSTEM qsplit
$SYSTEM qopen
$SYSTEM qed
$IF P10
$SYSTEM infpac
$END
$IF VAX
$SYSTEM imgnam
$END
END.
  