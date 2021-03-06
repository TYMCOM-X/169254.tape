$PAGE	QED -- General Environment Module
(* QEDENV.PAS - modified 9/17/81 by djm to change QUERY to QQUERY *)
(*            - modified 9/25/81 by djm to add conditional compile code
                around infpac.inc and imgnam.inc *)
(*            - modified 10/01/81 by djm to put wio.inc into a 
                conditional compile bracket *)
(*            - modified 04/30/82 by djm to delete lookup.typ, add
                cmdutl.inc, add qedtyp.typ, and add qsubst.typ. 
		These are to allow calls to cmd_lookup. *)

ENVMODULE QEDENV;
$SYSTEM (pasdev2)cmdutl
$SYSTEM qerr.typ
$SYSTEM (pasdev2)qstr.typ
$SYSTEM (pasdev2)qspat.typ
$SYSTEM (pasdev2)qspred.typ
$SYSTEM (pasdev2)cmdutl.typ
$SYSTEM qedln.typ
$SYSTEM (pasdev2)qline.typ
$SYSTEM (pasdev2)qld.typ
$SYSTEM (pasdev2)qed.typ
$SYSTEM (pasdev2)qsplit.typ
$SYSTEM (pasdev2)qsubst.typ
$SYSTEM (pasdev2)wio.typ
$SYSTEM (pasdev2)qedtyp.typ
$SYSTEM (pasdev2)filutl
$SYSTEM (pasdev2)qquery
$SYSTEM (pasdev2)qspat
$SYSTEM (pasdev2)qspred
$SYSTEM (pasdev2)qederr
$SYSTEM (pasdev2)qld
$SYSTEM (pasdev2)qread
$SYSTEM qedln
$SYSTEM (pasdev2)qmark
$SYSTEM (pasdev2)qprint
$SYSTEM (pasdev2)qsubst
$SYSTEM (pasdev2)qjoin
$SYSTEM (pasdev2)qsplit
$SYSTEM (pasdev2)qopen
$SYSTEM (pasdev2)qed
$SYSTEM (pasdev2)tempfi
$IF P10
$SYSTEM (pasdev2)infpac
$SYSTEM (pasdev2)wio
$END
$IF VAX
$SYSTEM (pasdev2)imgnam
$END
$SYSTEM (pasdev2)qlabel
END.
    