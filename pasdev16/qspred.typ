(* STRING PREDICATE definitions reprenting a parsed QED string predicated.
   For details see the 'Definition of QED'. *)

TYPE
  SPRED_KINDS =
    (	PATTERN_SPOP,			(* MATCH A LINE CONTAINING PATTERN *)
	NOT_SPOP,			(* MATCH A LINE NOT MATCHING PREDICATE OPERAND *)
	AND_SPOP,			(* MATCH A LINE MATCHING BOTH PREDICATE OPERANDS *)
	OR_SPOP		);		(* MATCH A LINE MATCHING EITHER PREDICATE OPERANDS *)

  SPRED = ^ SPRED_NODE;		(* REPRESENTED AS A TREE OF NODES *)
  SPRED_NODE =
    RECORD
      CASE PREDKIND: SPRED_KINDS OF
	NOT_SPOP:			(* NOT <NOPER> *)
	      (  NOPER: SPRED  );
	AND_SPOP, OR_SPOP:		(* <LOPER> OP <ROPER> *)
	      (  LOPER, ROPER: SPRED  );
	PATTERN_SPOP:
	      (  PATTERN: SPATTERN  )
    END;

  TOKTYP = (AND_TOK, OR_TOK, NOT_TOK);
    