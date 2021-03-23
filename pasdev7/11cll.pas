      PROCEDURE CALL(FSYS: SETOFSYS; FCP: CTP);
      VAR
	  LKEY: 1..25;
	  FILECP: CTP;
          LCP: CTP;
	PROCEDURE VARIABLE(FSYS: SETOFSYS);
	BEGIN
	  IF SY = IDENT THEN BEGIN
	    SEARCHID([VARS,FIELD],LCP);
	    INSYMBOL
	  END
	  ELSE BEGIN
	    ERROR(2);
	    LCP := UVARPTR
	  END;
	  SELECTOR(FSYS,LCP)
	END (*VARIABLE*);
	(*$Y+*)     (*  NEW MODULE  *)
	PROCEDURE GETFILEID;
	VAR
	    LDISPL, MODE: INTEGER;
	BEGIN
	  FILECP := NIL;
	  IF SY = IDENT THEN BEGIN
	    PRTERR := FALSE;
	    SEARCHID( [VARS], FILECP );
	    PRTERR := TRUE;
	    IF FILECP^.IDTYPE = NIL THEN
	      FILECP := NIL
	    ELSE IF FILECP^.IDTYPE^.FORM <> FILES THEN
	      FILECP := NIL;
	  END;
	  IF FILECP <> NIL THEN BEGIN
	    INSYMBOL;
	    IF SY = COMMA THEN
	      INSYMBOL;
	    IF (LKEY IN [4,9,10]) AND (FILECP = TTYINPTR) THEN
	      FILECP := TTYOUTPTR;
	  END
	  ELSE BEGIN
	    IF ( LKEY IN [7,8,11,12,13]) AND ( INPUTPTR <> NIL ) THEN
	      FILECP := INPUTPTR
	    ELSE IF ( LKEY IN [2,9,10]) AND ( OUTPUTPTR <> NIL ) THEN
	      FILECP := OUTPUTPTR
	    ELSE IF ( LKEY IN [4,9,10]) AND ( TTYOUTPTR <> NIL ) THEN
	      FILECP := TTYOUTPTR
	    ELSE IF ( LKEY IN [7,8,11,12,13] ) AND (TTYINPTR <> NIL ) THEN
	      FILECP := TTYINPTR
	    ELSE
	      ERROR(180) ;
	  END;
	  IF LKEY >= 11 THEN
	  CASE LKEY OF
	    11:
	      LDISPL := EOFSTATUS;
	    12:
	      LDISPL := EOLNSTATUS;
	    13:
	      LDISPL := IORESULT
	  END
	  ELSE LDISPL := 0;
	  IF FILECP <> NIL THEN
	    WITH FILECP^ DO
	      IF VKIND = FORMAL THEN BEGIN
		GATTR.TYPTR := INTPTR (*  <> CHARPTR FOR LOD  *);
		LOD( LEVEL-VLEV, VADDR, 2 );
		IF LKEY IN [7,8,11,12,13] THEN
		  GENSUBRCALL( TTPAR );
		IF LKEY >= 11 THEN BEGIN
		  GEN2( MOV,AUTINC,SP,REG,AD );
		  GEN2( MOV,INDEX,AD,AUTDEC,SP );
		  GENCONST( LDISPL )
		END
	      END
	      ELSE BEGIN
		IF VCLASS = DEFAULTSY THEN BEGIN
		  IF LKEY >= 11 THEN
		    GEN2 (MOV,INDEX,GP,AUTDEC,SP)
		  ELSE BEGIN
		    GEN2 (MOV,REG,GP,AUTDEC,SP);
		    GEN2 (ADD,AUTINC,PC,REGDEF,SP);
		  END;
		  GENCONST (VADDR+LDISPL);
		END
		ELSE BEGIN
		  IF LKEY >= 11 THEN MODE := AUTINCDEF
		  ELSE MODE := AUTINC;
		  GEN2 (MOV,MODE,PC,AUTDEC,SP);
		  STATICPUBLIC (FILECP,VADDR+LDISPL);
		END
	      END
	END (*  GETFILEID  *);
	(*$Y+*)     (*  NEW MODULE  *)
	PROCEDURE GETPUTRESETREWRITE;
	VAR
	    SUBRNAME: RUNTIMEROUTS;
	    I,J,SMIN,SMAX: INTEGER;
	BEGIN
	  GETFILEID;
	  IF LKEY > 4 (* RESET, REWRITE *)
	  THEN BEGIN (*RESET, REWRITE *)
	    IF FILECP^.IDTYPE <> NIL THEN
	      WITH FILECP^.IDTYPE^ DO
		IF FORM = FILES THEN BEGIN
		  GEN2(MOV,AUTINC,PC,AUTDEC,SP);
		  IF FILTYPE = CHARPTR THEN
		    GENCONST(-1)
		  ELSE
		    GENCONST(FILTYPE^.SIZE);
		END;
	    FOR I := 1 TO 3 DO BEGIN
	      IF NOT ( SY IN [COMMA,RPARENT] ) THEN BEGIN
		EXPRESSION(FSYS OR [COMMA,RPARENT]);
		IF GATTR.TYPTR <> NIL THEN
		  IF STRING(GATTR.TYPTR) THEN BEGIN
		    GETBOUNDS(GATTR.TYPTR^.INXTYPE,SMIN,SMAX);
		    IF GATTR.KIND = VARBL THEN
		      IF GATTR.ACCESS = DRCT THEN
			GATTR.DPLMT := GATTR.DPLMT + SMIN
		      ELSE
			GATTR.IDPLMT := GATTR.IDPLMT + SMIN;
		    LOADADDRESS ;
		    GEN2(MOV,AUTINC,PC,AUTDEC,SP);
		    GENCONST(SMAX-SMIN+1)
		  END
		  ELSE
		    ERROR(116);
	      END
	      ELSE IF (I = 1) AND (FILECP <> NIL) THEN
		WITH FILECP^ DO BEGIN
		  GENBR(BR,(ALFALENG+1)DIV 2);
		  J := 1 ;
		  WHILE J < ALFALENG DO BEGIN
		    GENCONST(ORD(NAME[J])+256* ORD(NAME[J+1]));
		    J := J+2 ;
		  END;
		  IF ODD(ALFALENG) THEN
		    GENCONST(ORD(NAME[J]));
		  GEN2(MOV,REG,PC,AUTDEC,SP);
		  GEN2(SUB,AUTINC,PC,REGDEF,SP);
		  GENCONST( 2 * ( ALFALENG DIV 2 ) + 2 );
		  GEN2(MOV,AUTINC,PC,AUTDEC,SP) ;
		  GENCONST(ALFALENG)
		END
	      ELSE BEGIN
		GEN1(CLR,AUTDEC,SP);
		GEN1(CLR,AUTDEC,SP)
	      END ;
	      IF SY = COMMA THEN
		INSYMBOL;
	    END (*  FOR  *);
	    IF SY = RPARENT THEN
	      GEN1(CLR,AUTDEC,SP)
	    ELSE BEGIN
	      EXPRESSION(FSYS OR [COMMA,RPARENT]);
	      IF GATTR.TYPTR = NIL THEN
		ERROR(116)
	      ELSE
		WITH GATTR.TYPTR^ DO
		  IF (FORM = POWER) AND (SIZE = 2) THEN
		    LOAD
		  ELSE
		    ERROR(116);
	    END;
	  END (* LKEY > 4  *)
	  ELSE IF SY <> RPARENT THEN BEGIN
	    EXPRESSION(FSYS OR [RPARENT]);
	    IF COMPTYPES(INTPTR,GATTR.TYPTR) THEN
	      LOAD
	    ELSE
	      ERROR(116);
	    LKEY := LKEY + 1;
	  END;
	  CASE LKEY OF
	    1:
	      SUBRNAME := GETCH;
	    2:
	      SUBRNAME := GETR;
	    3:
	      SUBRNAME := PUTCH;
	    4:
	      SUBRNAME := PUTR;
	    5:
	      SUBRNAME := RESETF;
	    6:
	      SUBRNAME := REWRITEF
	  END;
	  GENSUBRCALL(SUBRNAME)
	END (*GETPUTRESETREWRITE*);
	PROCEDURE READREADLN (*$Y+*);
	VAR
	    SMIN,SMAX: INTEGER;
	BEGIN
	  GETFILEID;
	  IF ((LKEY = 7) OR ((LKEY = 8) AND (SY <>RPARENT) AND
	    (SY IN (FACBEGSYS - [LBRACK]) OR [ADDOP]))) AND (FILECP <> NIL) THEN
	      LOOP
		VARIABLE(FSYS OR [COMMA,RPARENT]);
		LOADADDRESS;
		IF GATTR.TYPTR <> NIL THEN
		  IF COMPTYPES( FILECP^.IDTYPE^.FILTYPE, GATTR.TYPTR) AND
		    NOT COMPTYPES( GATTR.TYPTR,CHARPTR) THEN
		      GENSUBRCALL( RDREC )
		    ELSE IF STRING ( GATTR.TYPTR ) THEN
		      WITH GATTR.TYPTR^ DO BEGIN
			IF ADDRCORR <> 0 THEN BEGIN
			  GEN2(ADD,AUTINC,PC,REGDEF,SP);
			  GENCONST(ADDRCORR);
			END;
			GETBOUNDS(INXTYPE,SMIN,SMAX);
			GEN2(MOV,AUTINC,PC,AUTDEC,SP);
			GENCONST(SMAX-SMIN+1);
			GENSUBRCALL(RDSTR);
		      END
		    ELSE IF GATTR.TYPTR^.FORM <= SUBRANGE THEN
		      IF COMPTYPES(INTPTR,GATTR.TYPTR) THEN
			GENSUBRCALL(RDI)
		      ELSE IF COMPTYPES(REALPTR,GATTR.TYPTR) THEN
			GENSUBRCALL(RDR)
		      ELSE IF COMPTYPES(CHARPTR,GATTR.TYPTR) THEN
			GENSUBRCALL(RDC)
		      ELSE
			ERROR(399)
		    ELSE
		      ERROR(116);
	      EXIT IF SY <> COMMA;
		INSYMBOL
	      END;
	  IF FILECP <> NIL THEN
	    IF (LKEY = 8) AND COMPTYPES(FILECP^.IDTYPE^.FILTYPE,CHARPTR) THEN
	      GENSUBRCALL(GETLINE)
	    ELSE
	      GEN1(TST,AUTINC,SP) (* REMOVE FILE ID *);
	END (*READ*);
	PROCEDURE WRITEWRITELN (*$Y+*);
	VAR
	    LSP: STP;
	    DEFAULT, STACKD: BOOLEAN;
	    SMIN,SMAX: INTEGER;
	BEGIN
	  GETFILEID;
	  IF ((LKEY = 9) OR ((LKEY = 10) AND ((SY <> RPARENT) AND
	    (SY IN (FACBEGSYS - [LBRACK]) OR [ADDOP])))) AND (FILECP <> NIL)
	      THEN
		LOOP
		  EXPRESSION(FSYS OR [COMMA,COLON,RPARENT]);
		  LSP := GATTR.TYPTR;
		  STACKD := FALSE;
		  IF LSP <> NIL THEN
		    IF LSP^.FORM <= POWER THEN
		      LOAD
		    ELSE IF LSP^.FORM <> STRINGPARM THEN
		      IF GATTR.KIND = EXPR THEN
		      (*MULTIPLE FUNCTIONRESULT ON STACK IS ACTUAL PARAMETER*)
		      BEGIN
			GEN2(MOV,REG,SP,AUTDEC,SP);
			STACKD := TRUE
		      END
		      ELSE BEGIN
			LOADADDRESS;
			IF LSP^.FORM = ARRAYS THEN
			  IF LSP^.ADDRCORR <> 0 THEN BEGIN
			    GEN2(ADD,AUTINC,PC,REGDEF,SP);
			    GENCONST(LSP^.ADDRCORR)
			  END
		      END;
		  IF NOT COMPTYPES(CHARPTR,GATTR.TYPTR) AND
		    COMPTYPES(FILECP^.IDTYPE^.FILTYPE,GATTR.TYPTR) THEN
		      GENSUBRCALL ( WRREC )
		    ELSE BEGIN
		      IF SY = COLON THEN BEGIN
			INSYMBOL;
			EXPRESSION(FSYS OR [COMMA,COLON,RPARENT]);
			IF GATTR.TYPTR <> NIL THEN
			  IF GATTR.TYPTR <> INTPTR THEN
			    ERROR(116);
			LOAD;
			DEFAULT := FALSE
		      END
		      ELSE
			DEFAULT := TRUE;
		      IF SY = COLON THEN BEGIN
			INSYMBOL;
			IF (SY = IDENT) AND (ID = 'O         ') THEN BEGIN
			  INSYMBOL;
			  IF LSP <> INTPTR THEN
			    ERROR(206)
			  ELSE
			    GENSUBRCALL(WRIOCT)
			END
			ELSE BEGIN
			  EXPRESSION(FSYS OR [COMMA,RPARENT]);
			  IF GATTR.TYPTR <> NIL THEN
			    IF GATTR.TYPTR <> INTPTR THEN
			      ERROR(116);
			  IF LSP <> REALPTR THEN
			    ERROR(124);
			  LOAD;
			  GENSUBRCALL(WRFIX);
			END
		      END
		      ELSE IF LSP = INTPTR THEN BEGIN
			IF DEFAULT THEN BEGIN
			  GEN2(MOV,AUTINC,PC,AUTDEC,SP) ;
			  GENCONST( 8 )
			END ;
			GENSUBRCALL(WRI)
		      END
		      ELSE IF LSP = REALPTR THEN BEGIN
			IF DEFAULT THEN BEGIN
			  GEN2(MOV,AUTINC,PC,AUTDEC,SP);
			  GENCONST(15)
			END;
			GENSUBRCALL(WRR)
		      END
		      ELSE IF LSP = CHARPTR THEN BEGIN
			IF DEFAULT THEN
			  GENSUBRCALL(WRC)
			ELSE
			  GENSUBRCALL(WRCHA);
		      END
		      ELSE IF LSP = BOOLPTR THEN BEGIN
			IF DEFAULT THEN
			  GENSUBRCALL(WRB)
			ELSE
			  GENSUBRCALL(WRBFX);
		      END
		      ELSE IF LSP <> NIL THEN BEGIN
			IF LSP^.FORM = SCALAR THEN
			  ERROR(399)
			ELSE IF STRING(LSP) THEN BEGIN
			  GEN2(MOV,AUTINC,PC,AUTDEC,SP);
			  GETBOUNDS(LSP^.INXTYPE,SMIN,SMAX);
			  GENCONST(SMAX - SMIN + 1);
			  IF DEFAULT THEN
			    GEN2(MOV,REGDEF,SP,AUTDEC,SP);
			  GENSUBRCALL(WRS);
			  IF STACKD THEN BEGIN
			    GEN2(ADD,AUTINC,PC,REG,SP);
			    GENCONST(LSP^.SIZE)
			    (*REMOVE FUNCTIONRESULT FROM STACK*)
			  END
			END
			ELSE IF LSP^.FORM = STRINGPARM THEN BEGIN
			  IF DEFAULT THEN
			    GEN2(MOV,REGDEF,SP,AUTDEC,SP)
			  ELSE BEGIN
			    GEN2(MOV,AUTINC,SP,REG,R);
			    GEN2(MOV,REGDEF,SP,AUTDEC,SP);
			    GEN2(MOV,REG,R,INDEX,SP);
			    GENCONST(2);
			  END;
			  GENSUBRCALL(WRS)
			END
			ELSE
			  ERROR(116);
		      END;
		    END;
		EXIT IF SY <> COMMA;
		  INSYMBOL
		END;
	  IF FILECP <> NIL THEN
	    IF (LKEY = 10) AND COMPTYPES(FILECP^.IDTYPE^.FILTYPE,CHARPTR) THEN
	      GENSUBRCALL(PUTLINE)
	    ELSE
	      GEN1(TST,AUTINC,SP) (* REMOVE FILE ID *);
	END (*WRITE*);
	PROCEDURE PACK (*$Y+*);
	VAR
	    LSP,LSP1: STP;
	BEGIN
	  ERROR(399);
	  (*$Z+*)
	  VARIABLE(FSYS OR [COMMA,RPARENT]);
	  LSP := NIL;
	  LSP1 := NIL;
	  IF GATTR.TYPTR <> NIL THEN
	    WITH GATTR.TYPTR^ DO
	      IF FORM = ARRAYS THEN BEGIN
		LSP := INXTYPE;
		LSP1 := AELTYPE
	      END
	      ELSE
		ERROR(116);
	  IF SY = COMMA THEN
	    INSYMBOL
	  ELSE
	    ERROR(20);
	  EXPRESSION(FSYS OR [COMMA,RPARENT]);
	  IF GATTR.TYPTR <> NIL THEN
	    IF GATTR.TYPTR^.FORM <> SCALAR THEN
	      ERROR(116)
	    ELSE IF NOT COMPTYPES(LSP,GATTR.TYPTR) THEN
	      ERROR(116);
	  IF SY = COMMA THEN
	    INSYMBOL
	  ELSE
	    ERROR(20);
	  VARIABLE(FSYS OR [RPARENT]);
	  IF GATTR.TYPTR <> NIL THEN
	    WITH GATTR.TYPTR^ DO
	      IF FORM = ARRAYS THEN BEGIN
		IF NOT COMPTYPES(AELTYPE,LSP1) OR NOT COMPTYPES(INXTYPE,LSP)
		  THEN
		    ERROR(116)
	      END
	      ELSE
		ERROR(116)
		(*$Z-*)
	END (*PACK*);
	PROCEDURE UNPACK (*$Y+*);
	VAR
	    LSP,LSP1: STP;
	BEGIN
	  ERROR(399);
	  (*$Z+*)
	  VARIABLE(FSYS OR [COMMA,RPARENT]);
	  LSP := NIL;
	  LSP1 := NIL;
	  IF GATTR.TYPTR <> NIL THEN
	    WITH GATTR.TYPTR^ DO
	      IF FORM = ARRAYS THEN BEGIN
		LSP := INXTYPE;
		LSP1 := AELTYPE
	      END
	      ELSE
		ERROR(116);
	  IF SY = COMMA THEN
	    INSYMBOL
	  ELSE
	    ERROR(20);
	  VARIABLE(FSYS OR [COMMA,RPARENT]);
	  IF GATTR.TYPTR <> NIL THEN
	    WITH GATTR.TYPTR^ DO
	      IF FORM = ARRAYS THEN BEGIN
		IF NOT COMPTYPES(AELTYPE,LSP1) OR NOT COMPTYPES(INXTYPE,LSP)
		  THEN
		    ERROR(116)
	      END
	      ELSE
		ERROR(116);
	  IF SY = COMMA THEN
	    INSYMBOL
	  ELSE
	    ERROR(20);
	  EXPRESSION(FSYS OR [RPARENT]);
	  IF GATTR.TYPTR <> NIL THEN
	    IF GATTR.TYPTR^.FORM <> SCALAR THEN
	      ERROR(116)
	    ELSE IF NOT COMPTYPES(LSP,GATTR.TYPTR) THEN
	      ERROR(116);
	      (*$Z-*)
	END (*UNPACK*);
	PROCEDURE NEW1 (*$Y+*);
	LABEL
	    1;
	CONST
	    TAGMAX = 5;
	VAR
	    LSP,LSP1: STP;
	    LMIN,LMAX,I: INTEGER;
	    LSIZE,LSZ: ADDRRANGE;
	    LVAL: VALU;
	    TAGIX: -1..TAGMAX;
	    TAGSAVE: ARRAY[0..TAGMAX] OF RECORD
	      TAGVALUE: INTEGER;
	      TAGOFFSET: INTEGER
	    END;
	BEGIN
	  VARIABLE(FSYS OR [COMMA,RPARENT,COLON]);
	  LOADADDRESS;
	  LSP := NIL;
	  LSIZE := 0;
	  TAGIX := -1;
	  IF GATTR.TYPTR <> NIL THEN
	    WITH GATTR.TYPTR^ DO
	      IF FORM = POINTER THEN BEGIN
		IF ELTYPE <> NIL THEN BEGIN
		  LSIZE := ELTYPE^.SIZE;
		  IF ELTYPE^.FORM = RECORDS THEN BEGIN
		    LSP := ELTYPE^.RECVAR;
		  END
		  ELSE IF ELTYPE^.FORM = ARRAYS THEN BEGIN
		    LSP := ELTYPE;
		  END;
		END
	      END
	      ELSE
		ERROR(116);
	  WHILE SY = COMMA DO BEGIN
	    INSYMBOL;
	    CONSTANT(FSYS OR [COMMA,COLON,RPARENT],LSP1,LVAL);
	    (*CHECK TO INSERT HERE: IS CONSTANT IN TAGFIELDTYPE RANGE*)
	    IF LSP = NIL THEN
	      ERROR(158)
	    ELSE IF STRING(LSP1) OR (LSP1 = REALPTR) THEN
	      ERROR(159)
	    ELSE BEGIN
	      IF LSP^.FORM = TAGFWITHID THEN BEGIN
		IF LSP^.TAGFIELDP <> NIL THEN
		  IF COMPTYPES(LSP^.TAGFIELDP^.IDTYPE,LSP1) THEN BEGIN
		    IF TAGIX = TAGMAX THEN ERROR (306)
		    ELSE BEGIN
		      TAGIX := TAGIX + 1;
		      WITH TAGSAVE[TAGIX] DO BEGIN
			TAGVALUE := LVAL.IVAL;
			TAGOFFSET := LSP^.TAGFIELDP^.FLDADDR;
		      END;
		    END;
		  END
		  ELSE BEGIN
		    ERROR(116);
		    GOTO 1
		  END
	      END
	      ELSE IF LSP^.FORM = TAGFWITHOUTID THEN BEGIN
		IF NOT COMPTYPES(LSP^.TAGFIELDTYPE,LSP1) THEN BEGIN
		  ERROR(116);
		  GOTO 1
		END
	      END
	      ELSE BEGIN
		ERROR(170);
		GOTO 1
	      END;
	      LSP1 := LSP^.FSTVAR;
	      WHILE LSP1 <> NIL DO
		WITH LSP1^ DO
		  IF VARVAL.IVAL = LVAL.IVAL THEN BEGIN
		    LSIZE := SIZE;
		    LSP := SUBVAR;
		    GOTO 1
		  END
		  ELSE
		    LSP1 := NXTVAR;
	      LSIZE := LSP^.SIZE;
	      LSP := NIL;
	    END;
	    1:
	  END (*WHILE*);
	  IF SY = COLON THEN BEGIN
	    INSYMBOL;
	    EXPRESSION(FSYS OR [RPARENT]);
	    IF LSP = NIL THEN
	      ERROR(163)
	    ELSE IF LSP^.FORM <> ARRAYS THEN
	      ERROR(164)
	    ELSE BEGIN
	      IF NOT COMPTYPES(GATTR.TYPTR,LSP^.INXTYPE) THEN
		ERROR(116);
	      LSZ := 2;
	      LMIN := 1;
	      IF LSP^.INXTYPE <> NIL THEN
		GETBOUNDS(LSP^.INXTYPE,LMIN,LMAX);
	      IF LSP^.AELTYPE <> NIL THEN
		IF LSP^.AELTYPE = CHARPTR THEN
		  LSZ := 1
		ELSE
		  LSZ := LSP^.AELTYPE^.SIZE;
	      LOAD;
	      IF LSP^.PACKOPT THEN BEGIN
		IF LMIN <> 1 THEN BEGIN
		  GEN2(SUB,AUTINC,PC,REGDEF,SP);
		  GENCONST(LMIN- 1);
		END;
		LSZ := 1;
		FOR I := 1 TO 3 DO
		  GEN1(ASR,REGDEF,SP) (* ... DIV 8 *);
		GEN1(INC,REGDEF,SP);
		LMIN := 1
		(*ALWAYS ADDS ONE BYTE*)
	      END;
	      IF LSZ <> 1 THEN
		IF LSZ = 2 THEN
		  GEN1(ASL,REGDEF,SP)
		ELSE IF EXTSET THEN BEGIN
		  GEN2(MOV,REGDEF,SP,REG,R);
		  GEN2(MULT,REG,R,AUTINC,PC);
		  GENCONST(LSZ);
		  GEN2(MOV,REG,R,REGDEF,SP);
		END
		ELSE BEGIN
		  GEN2(MOV,AUTINC,PC,AUTDEC,SP);
		  GENCONST(LSZ);
		  GENSUBRCALL(MPI);
		END;
	      LSZ := LSIZE - LSP^.SIZE - LSZ * (LMIN - 1);
	      IF LSZ > 0 THEN BEGIN
		GEN2(ADD,AUTINC,PC,REGDEF,SP);
		GENCONST(LSZ);
	      END;
	      GEN2(ADD,REG,R,INDEX,GP);
	      GENCONST(DAPADDR)
	    END
	  END
	  ELSE BEGIN
	    GEN2(MOV,AUTINC,PC,AUTDEC,SP);
	    GENCONST(LSIZE);
	  END;
	  GENSUBRCALL (NEWP);
	  IF TAGIX < 0 THEN
	    GEN2(MOV,AUTINC,SP,AUTINCDEF,SP)
	  ELSE BEGIN
	    GEN2(MOV,AUTINC,SP,REG,R);
	    FOR I := 0 TO TAGIX DO
	      WITH TAGSAVE[I] DO BEGIN
		GEN2 (MOV,AUTINC,PC,INDEX,R);
		GENCONST (TAGVALUE);
		GENCONST (TAGOFFSET);
	      END;
	    GEN2(MOV,REG,R,AUTINCDEF,SP);
	  END;
	END (*NEW*);
	PROCEDURE ABS (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR = INTPTR THEN BEGIN
	    GEN1(TST,REGDEF,SP);
	    GENBR(BPL,1);
	    GEN1(NEG,REGDEF,SP)
	  END
	  ELSE IF GATTR.TYPTR = REALPTR THEN BEGIN
	    GEN2(BIC,AUTINC,PC,REGDEF,SP);
	    GENCONST(100000B)
	  END
	  ELSE BEGIN
	    ERROR(125);
	    GATTR.TYPTR := INTPTR
	  END
	END (*ABS*);
	PROCEDURE SQR (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR = INTPTR THEN BEGIN
	    IF EXTSET THEN BEGIN
	      GEN2(MOV,REGDEF,SP,REG,R);
	      GEN2(MULT,REG,R,AUTINC,SP);
	      GEN2(MOV,REG,R,AUTDEC,SP)
	    END
	    ELSE
	      GENSUBRCALL(SQI)
	  END
	  ELSE IF GATTR.TYPTR = REALPTR THEN
	    GENSUBRCALL(SQRR)
	  ELSE BEGIN
	    ERROR(125);
	    GATTR.TYPTR := INTPTR
	  END
	END (*SQR*);
	PROCEDURE TRUNC (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> NIL THEN
	    IF GATTR.TYPTR <> REALPTR THEN
	      ERROR(125);
	  GENSUBRCALL(TRC);
	  GATTR.TYPTR := INTPTR
	END (*TRUNC*);
	PROCEDURE ARITHMETICFUNCTIONS (*$Y+*);
	VAR
	    RTR: RUNTIMEROUTS;
	BEGIN
	  IF GATTR.TYPTR = INTPTR THEN BEGIN
	    GENSUBRCALL(FLT);
	    GATTR.TYPTR := REALPTR
	  END;
	  IF GATTR.TYPTR <> REALPTR THEN
	    ERROR(125)
	  ELSE BEGIN
	    CASE LKEY OF
	      16:
		RTR := RSIN;
	      17:
		RTR := RCOS;
	      18:
		RTR := RARCTAN;
	      19:
		RTR := REXP;
	      20:
		RTR := RLOG;
	      21:
		RTR := RSQRT
	    END;
	    GENSUBRCALL(RTR);
	  END;
	END;
	(*ARITHMETICFUNCTIONS*)
	PROCEDURE ROUND (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> NIL THEN
	    IF GATTR.TYPTR <> REALPTR THEN
	      ERROR(125);
	  GENSUBRCALL(RND);
	  GATTR.TYPTR := INTPTR
	END;
	(*ROUND*)
	PROCEDURE ODD (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> INTPTR THEN
	    ERROR(125);
	  GEN2(BIC,AUTINC,PC,REGDEF,SP);
	  GENCONST(-2);
	  GATTR.TYPTR := BOOLPTR
	END (*ODD*);
	PROCEDURE ORD (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> NIL THEN
	    IF (GATTR.TYPTR^.FORM > POWER) OR (GATTR.TYPTR^.SIZE <> 2) THEN
	      ERROR(125);
	  GATTR.TYPTR := INTPTR
	END (*ORD*);
	PROCEDURE CHR (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> INTPTR THEN
	    ERROR(125);
	  GATTR.TYPTR := CHARPTR
	END (*CHR*);
	PROCEDURE POINTR (*$Y+*);
	BEGIN
	  IF NOT COMPTYPES (GATTR.TYPTR,INTPTR) THEN
	    ERROR (125);
	  LOAD;
	  GATTR.TYPTR := NILPTR;
	END;
	PROCEDURE LADDRESS (*$Y+*);
	BEGIN
	  VARIABLE (FSYS OR [RPARENT]);
	  LOADADDRESS;
          (* IF VARIABLE WAS AN ARRAY AN ADDRESS WAS GENERATED
             WHICH ASSUMED THE INDEX OF THE FIRST ELEMENT WAS
             ZERO. IF THAT ASSUMUPTION WAS FALLACIOUS THEN
             GENERATE CODE TO ADD THE CORRECTION FACTOR IN 
          *)
          IF LCP^.IDTYPE <> NIL THEN
          WITH LCP^.IDTYPE^ DO
          IF FORM = ARRAYS THEN
            IF ADDRCORR <> 0 THEN
            BEGIN
              GEN2(ADD,AUTINC,PC,REGDEF,SP);
              GENCONST(ADDRCORR)
            END;
	  GATTR.TYPTR := NILPTR;
	END;
	PROCEDURE PREDSUCC (*$Y+*);
	BEGIN
	  IF LKEY = 7 THEN
	    GEN1(DEC,REGDEF,SP)
	  ELSE
	    GEN1(INC,REGDEF,SP); (OUNDCHECKING IS DONE*)
	  IF GATTR.TYPTR <> NIL THEN
	    IF GATTR.TYPTR^.FORM <> SCALAR THEN
	      ERROR(125);
	END (*PREDSUCC*);
	PROCEDURE EOFEOLNIORES (*$Y+*);
	VAR
	    LDISPL: INTEGER;
	BEGIN
	  LKEY := LKEY + 2;
	  GETFILEID;
	  IF LKEY = 13 (* 11+2  *)
	  THEN
	    GATTR.TYPTR := INTPTR
	  ELSE
	    GATTR.TYPTR := BOOLPTR ;
	END (*EOF*);
	PROCEDURE BREAKLN (*$Y+*);
	BEGIN
	  GETFILEID;
	  GENSUBRCALL( BRK )
	END;
	PROCEDURE FORMFEED (*$Y+*);
	BEGIN
	  GETFILEID;
	  GENSUBRCALL( FORMFD )
	END;
	PROCEDURE DATETIME (*$Y+*);
	BEGIN
	  VARIABLE( FSYS OR [RPARENT]);
	  LOADADDRESS;
	  IF GATTR.TYPTR <> NIL THEN
	    IF LKEY = 19 THEN
	      GENSUBRCALL( TIME1 )
	    ELSE
	      GENSUBRCALL( DATE1 );
	END;
	PROCEDURE HALT (*$Y+*);
	BEGIN
	  GENSUBRCALL( DUMP )
	END ;
	PROCEDURE RUNTIME1 (*$Y+*);
	BEGIN
	  GENSUBRCALL( RUNTM );
	  GATTR.TYPTR := INTPTR
	END;
	PROCEDURE DISPOSAL (*$Y+*);
	BEGIN
	  VARIABLE (FSYS OR [RPARENT]);
	  LOADADDRESS;
	  IF GATTR.TYPTR <> NIL THEN BEGIN
	    IF GATTR.TYPTR^.FORM <> POINTER THEN
	      ERROR (116);
	    GENSUBRCALL (DISPOSEP);
	  END;
	END;
	PROCEDURE MARKRELEASE (*$Y+*);
	BEGIN
	  ERROR(903);
	  VARIABLE (FSYS OR [RPARENT]);
	  LOADADDRESS;
	  IF LKEY = 12 THEN
	    GENSUBRCALL(MARKP)
	  ELSE
	    GENSUBRCALL(RELEASEP)
	END;
	PROCEDURE SPLITREAL (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> REALPTR THEN
	    ERROR(125);
	  IF SY =COMMA THEN
	    INSYMBOL
	  ELSE
	    ERROR(20);
	  VARIABLE(FSYS OR [RPARENT]);
	  LOADADDRESS;
	  IF GATTR.TYPTR <> INTPTR THEN
	    ERROR(125);
	  GENSUBRCALL(SPLTRL);
	  GATTR.TYPTR := REALPTR;
	END;
	(*SPLITREAL*)
	PROCEDURE SSIZE (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> NIL THEN
	    IF GATTR.TYPTR^.FORM <> STRINGPARM THEN
	      ERROR(626)
	    ELSE
	      GEN2(MOV,AUTINC,SP,REGDEF,SP);
	  GATTR.TYPTR := INTPTR;
	END;
	PROCEDURE TWOPOW (*$Y+*);
	BEGIN
	  IF GATTR.TYPTR <> INTPTR THEN
	    ERROR(125);
	  GENSUBRCALL(TWPOW);
	  GATTR.TYPTR := REALPTR;
	END;
	(*TWOPOW*)
	PROCEDURE CALLNS1 (*$Y+*);
	BEGIN
	  IF SY IN [LBRACK,PERIOD] THEN (*ELEMENTSELECTION FROM MULTIPLE*)
	  BEGIN (*FUNCTIONRESULT*)
	    IF GATTR.TYPTR <> NIL THEN
	      WITH GATTR.TYPTR^ DO BEGIN
		I := SIZE;
		GEN2(MOV,REG,SP,AUTDEC,SP); (*MULTIPLE ADDRESS ON STACK*)
		IF FORM = ARRAYS THEN
		  IF ADDRCORR <> 0 THEN BEGIN
		    GEN2(SUB,AUTINC,PC,REGDEF,SP);
		    GENCONST(ADDRCORR)
		  END
	      END;
	    WITH GATTR DO BEGIN
	      KIND := VARBL ;
	      ACCESS := INDRCT;
	      IDPLMT := 0
	    END;
	    SELECTOR(FSYS, NIL); (*  *)
	    (*POSSIBILITIES AFTER SELECTOR: KIND = VARBL, ACCESS = INDRCT,OR
			   ACCESS = PACKD. AN ADDRESS (POSSIBLY  2-TUPLE)HAS BEEN PRODUCED
			   ON TOP OF  THE STACK; THE CONTENTS OF THIS ADDRESS (POSSIBLY A
			   MULTIPLE VALUE) MUST BE  LOADED ONTO THE STACK AFTER THE
			   FUNCTIONRESULT HAS BEEN REMOVED*)
	    IF GATTR.TYPTR <> NIL THEN
	      WITH GATTR DO
		IF KIND = EXPR THEN
		  ERROR(609)
		ELSE IF ACCESS = INDRCT THEN (*FIELD OF RECORD OR ARRAY-EL*)
		BEGIN
		  GEN2(MOV,AUTINC,SP,REG,AR);
		  GEN2(MOV,REG,SP,REG,AD);
		  GEN2(ADD,AUTINC,PC,REG,AD);
		  GENCONST(I);
		  IF TYPTR^.SIZE = 2 THEN
		    IF TYPTR = CHARPTR THEN BEGIN
		      IF IDPLMT = 0 THEN
			GEN2(MOVB,REGDEF,AR,REG,AR)
		      ELSE BEGIN
			GEN2(MOVB,INDEX,AR,REG,AR);
			GENCONST(IDPLMT)
		      END;
		      GEN1(CLR,AUTDEC,AD);
		      GEN2(MOVB,REG,AR,REGDEF,AD);
		    END
		    ELSE IF IDPLMT = 0 THEN
		      GEN2(MOV,REGDEF,AR,AUTDEC,AD)
		    ELSE (*MAY BE DONE MORE EFFICIENT*)
		    BEGIN
		      GEN2(MOV,INDEX,AR,AUTDEC,AD);
		      GENCONST(IDPLMT)
		    END
		  ELSE BEGIN
		    GEN2(ADD,AUTINC,PC,REG,AR);
		    GENCONST(IDPLMT + TYPTR^.SIZE);
		    GENSUBRCALL(MOVMR);
		    GENCONST(TYPTR^.SIZE DIV 2)
		  END;
		  GEN2(MOV,REG,AD,REG,SP);
		END
		ELSE BEGIN (*ACCESSS = PACKD*)
		  IF TYPTR = BOOLPTR THEN BEGIN
		    GENSUBRCALL(LPB);
		    GEN2(MOV,REGDEF,SP,INDEX,SP);
		    GENCONST(I);
		    GEN2(ADD,AUTINC,PC,REG,SP);
		    GENCONST(I)
		  END
		  ELSE
		    ERROR(400);
		END;
	    GATTR.KIND := EXPR
	  END;
	END (* CALLNS1 *);
	PROCEDURE CALLNONSTANDARD (*$Y+*);
	VAR
	    NXT,LCP: CTP;
	    LSP,LSP2: STP;
	    LKIND: IDKIND;
	    LSP1: STP;
	    LCP1,LCP2: CTP;
	    LMIN,LMAX,I,P: INTEGER;
	    LATTR: ATTR;
	    B: BOOLEAN;
	    RELNAME: ALFA;
	  PROCEDURE BASE(PLEVEL: LEVRANGE);
	  VAR
	      I,MODE,REGISTER: INTEGER;
	  BEGIN
	    REGISTER := MP;
	    IF PLEVEL = 0 THEN
	      MODE := REG
	    ELSE
	      MODE := REGDEF;
	    IF PLEVEL > 1 THEN BEGIN
	      GEN2(MOV,REGDEF,MP,REG,AD);
	      FOR I := 3 TO PLEVEL DO
		GEN2(MOV,REGDEF,AD,REG,AD);
	      REGISTER := AD
	    END;
	    GEN2(MOV,MODE,REGISTER,AUTDEC,SP)
	  END;
	  FUNCTION COMPSPECIFICATION(LCP1, LCP2: CTP): BOOLEAN;
	  VAR
	      ERR: BOOLEAN;
	  BEGIN
	    ERR := FALSE;
	    WHILE (LCP1 <> NIL) AND (LCP2 <> NIL) AND NOT ERR DO BEGIN
	      IF COMPTYPES(LCP1^.IDTYPE, LCP2^.IDTYPE) AND
		(LCP1^.KLASS = LCP2^.KLASS) THEN BEGIN
		  IF LCP1^.KLASS = VARS THEN BEGIN
		    IF LCP1^.VKIND <> LCP2^.VKIND THEN
		      ERR := TRUE
		  END
		  ELSE
		    ERR := NOT COMPSPECIFICATION(LCP1^.PARMLIST,LCP2^.PARMLIST);
		END
		ELSE
		  ERR := TRUE;
	      LCP1 := LCP1^.NEXT;
	      LCP2 := LCP2^.NEXT;
	    END;
	    IF LCP1 <> LCP2 THEN
	      ERR := TRUE;
	    COMPSPECIFICATION := NOT ERR;
	  END;
	  (*COMPSPECIFICATION*)
	BEGIN
	  WITH FCP^ DO BEGIN
	    LKIND := PFKIND;
	    IF LKIND = ACTUAL THEN
	      NXT := NEXT
	    ELSE
	      NXT := PARMLIST; (*NXT POINTS TO PARAM.LIST*)
	    IF KLASS = FUNC THEN (*RESERVE PLACE FOR RESULT*)
	    BEGIN
	      IF IDTYPE^.SIZE = 2 THEN
		GEN1(CLR,AUTDEC,SP)
	      ELSE IF IDTYPE^.SIZE = 4 THEN
		GEN2(CMP,AUTDEC,SP,AUTDEC,SP)
	      ELSE BEGIN
		GEN2(SUB,AUTINC,PC,REG,SP);
		GENCONST(IDTYPE^.SIZE)
	      END
	    END
	  END;
	  IF SY = LPARENT THEN BEGIN
	    REPEAT
	      INSYMBOL;
	      IF NXT = NIL THEN BEGIN
		ERROR(126);
		SKIP(FSYS OR [RPARENT])
	      END
	      ELSE BEGIN
		IF NXT^.KLASS IN [PROC,FUNC] THEN (*PROCEDURE PARAM'S*)
		BEGIN
		  IF SY <> IDENT THEN BEGIN
		    ERROR(2);
		    SKIP(FSYS OR [COMMA,RPARENT])
		  END
		  ELSE
		  (*PROCEDURE PARAM*)
		  IF NXT^.KLASS = PROC THEN
		    SEARCHID([PROC],LCP)
		  ELSE
		  (*FUNCTION PARAM*)
		  BEGIN
		    SEARCHID([FUNC],LCP);
		    IF NOT COMPTYPES(LCP^.IDTYPE, NXT^.IDTYPE) THEN
		      ERROR(128)
		  END;
		  INSYMBOL;
		  IF NOT (SY IN FSYS OR [COMMA,RPARENT]) THEN BEGIN
		    ERROR(6);
		    SKIP(FSYS OR [COMMA,RPARENT])
		  END;
		  IF LCP <> NIL THEN
		    WITH LCP^ DO BEGIN
		      P := LEVEL - PFLEV;
		      IF PFDECKIND = STANDARD THEN
			ERROR(603);
		      LCP1 := NXT^.PARMLIST;
		      IF PFKIND = ACTUAL THEN (*ACTUAL PARAM IS AN*)
		      BEGIN
			BASE(P); (*ACTUAL P/F*)
			LCP2 := LCP^.NEXT;
			GEN2(MOV,REG,PC,AUTDEC,SP);
			GEN2(ADD,AUTINC,PC,REGDEF,SP);
			IF DECLPLACE > EXTRNL THEN
			  ERROR(609);
			GENCONST( 0 (*ADDRCHAIN*));
			IF EXTNAME = NIL THEN
			  RELNAME := NAME
			ELSE
			  RELNAME := EXTNAME^ ;
			PUTRLD( RELNAME, RELOCFCN, 2*CODE.LEN-2, 4);
			PUTGSD(RELNAME, GLOBALREFFLAGS, 0 ) ;
		      END (*NOW ABSOLUTE CODEADDRESS OF P/F LOADED*)
		      ELSE BEGIN
			LCP2 := LCP^.PARMLIST;
			(*ACTUAL PROCEDURE PARAM*)
			IF PFLEV <= 1 THEN
			  LDO(PFADDR, 4,NIL(*TEMP*))
			  (*IS FORMAL PROCEDURE*)
			ELSE
			  LOD(P, PFADDR, 4)
		      END;
		      IF NOT COMPSPECIFICATION(LCP1,LCP2) THEN
			ERROR(612);
		    END
		END
		ELSE BEGIN
		  LSP := NXT^.IDTYPE;
		  IF LSP <> NIL THEN BEGIN
		    IF NXT^.VKIND = FORMAL THEN BEGIN
		      IF LSP^.FORM = STRINGPARM THEN
			IF SY = IDENT THEN BEGIN
			  PRTERR := FALSE;
			  SEARCHID([FUNC],LCP1);
			  PRTERR := TRUE;
			  IF LCP1 <> NIL THEN
			    ERROR(609);
			END;
		      EXPRESSION(FSYS OR [COMMA,RPARENT]);
		      IF LSP^.FORM = STRINGPARM THEN BEGIN
			IF GATTR.KIND <> EXPR THEN BEGIN
			  LOADADDRESS;
			  IF GATTR.TYPTR <> NIL THEN
			    WITH GATTR.TYPTR^ DO
			      IF FORM = ARRAYS THEN BEGIN
				IF INXTYPE <> NIL THEN
				  GETBOUNDS(INXTYPE,LMIN,LMAX);
				GEN2(ADD,AUTINC,PC,REGDEF,SP);
				GENCONST(LMIN); (*HYP.ADDR --> ACT ADDR*)
				GEN2(MOV,AUTINC,PC,AUTDEC,SP);
				GENCONST(LMAX-LMIN+1);
			      END
			END
			ELSE IF GATTR.TYPTR <> NIL THEN
			  IF GATTR.TYPTR^.FORM <> STRINGPARM THEN
			    ERROR(617)
		      END
		      ELSE IF GATTR.KIND = VARBL THEN BEGIN
			LOADADDRESS;
			IF FCP^.DECLPLACE = EXTERNFORTRAN THEN
			  IF LSP^.FORM = ARRAYS THEN
			    IF LSP^.ADDRCORR <> 0 THEN BEGIN
			      GEN2 (ADD,AUTINC,PC,REGDEF,SP);
			      GENCONST (LSP^.ADDRCORR);
			    END
		      END
		      ELSE
			ERROR(154);
		      LSP2 := GATTR.TYPTR;
		      LSP1 := LSP;
		      WHILE LSP1^.FORM = BOUNDLESS DO BEGIN
			IF LSP2 <> NIL THEN
			  IF LSP2^.FORM = ARRAYS THEN BEGIN
			    LSP2 := LSP2^.AELTYPE;
			    IF LSP1^.UNSPECLEVEL > 1 THEN BEGIN
			      GEN2(MOV,AUTINC,PC,AUTDEC,SP);
			      GENCONST(LSP2^.SIZE);
			    END
			  END
			  ELSE IF LSP2^.FORM = BOUNDLESS THEN BEGIN
			    IF ((LSP2^.UNSPECLEVEL = 1) AND
			      (LSP1^.UNSPECLEVEL > 1)) THEN BEGIN
				GEN2(MOV,AUTINC,PC,AUTDEC,SP);
				GENCONST(LSP2^.SUBSTRUCT^.SIZE);
			      END;
			    LSP2 := LSP2^.SUBSTRUCT;
			  END;
			LSP1 := LSP1^.SUBSTRUCT;
		      END;
		      IF NOT COMPTYPES(LSP1,LSP2) THEN
			ERROR(142)
		    END
		    ELSE
		      WITH LSP^ DO BEGIN
			IF (FORM = ARRAYS) OR (FORM = RECORDS) THEN BEGIN
			  EXPRESSION(FSYS OR [COMMA,RPARENT]);
			  IF GATTR.KIND <> EXPR THEN
			  (* GATTR.TYPTR = EXPR  MEANS THAT THE ACTUAL PARAMETER WAS A FUNCTION,
			   THE RESULT OF WHICH HAS BEEN LEFT BEHIND ON THE STACK*)
			  BEGIN
			    LOADADDRESS;
			    GEN2(MOV,AUTINC,SP,REG,AR);
			    IF FORM = ARRAYS THEN
			      I := GATTR.TYPTR^.ADDRCORR
			    ELSE
			      I := 0;
			    IF SIZE <= 10 THEN BEGIN
			      GEN2(ADD,AUTINC,PC,REG,AR);
			      GENCONST(SIZE + I);
			      FOR I := 1 TO SIZE DIV 2 DO
				GEN2(MOV,AUTDEC,AR,AUTDEC,SP);
			    END
			    ELSE BEGIN
			      GEN2(SUB,AUTINC,PC,REG,SP);
			      GENCONST(SIZE);
			      GEN2(MOV,REG,SP,REG,AD);
			      (*NOW ADDRESS OF DESTINATION IN AD*)
			      IF I <> 0 THEN BEGIN
				GEN2(ADD,AUTINC,PC,REG,AR);
				GENCONST(ADDRCORR)
			      END;
			      GENSUBRCALL(MOVM2);
			      GENCONST(SIZE DIV 2);
			    END
			  END;
			  IF NOT COMPTYPES(LSP,GATTR.TYPTR) THEN
			    ERROR(142)
			END (*FORM=ARRAYS,ETC*)
			ELSE BEGIN
			  EXPRESSION(FSYS OR [COMMA,RPARENT]) ;
			  LOAD ;
			  IF FORM = POWER THEN BEGIN
			    LATTR.TYPTR := LSP;
			    LATTR.KIND := VARBL ;
			    B := LARGESET(LATTR)
			  END
			  ELSE IF COMPTYPES(REALPTR,LSP) AND
			    (GATTR.TYPTR = INTPTR) THEN BEGIN
			      GENSUBRCALL(FLT);
			      GATTR.TYPTR := REALPTR
			    END;
			  IF RUNTMCHECK THEN
			    IF (FORM <= SUBRANGE) AND (LSP <> REALPTR) AND
			      (LSP <> INTPTR) THEN BEGIN
				GENSUBRCALL(SUBRCHK);
				GETBOUNDS(LSP,LMIN,LMAX);
				GENCONST(LMIN);
				GENCONST(LMAX);
			      END;
			  IF NOT COMPTYPES(LSP,GATTR.TYPTR) THEN
			    ERROR(142)
			END
		      END (*WITH  LSP..*)
		  END (*LSP <> NIL*)
		END (* NXT^.KLASS*)
	      END;
	      (*NXT = NIL*)
	      IF NXT <> NIL THEN
		NXT := NXT^.NEXT;
	    UNTIL SY <> COMMA;
	    IF SY = RPARENT THEN
	      INSYMBOL
	    ELSE
	      ERROR(4)
	  END;
	  (*IF  SY=LPARENT*)
	  IF NXT <> NIL THEN
	    ERROR(126);
	  WITH FCP^ DO
	    IF LKIND = ACTUAL THEN (*CALL THE ACTUAL PROCEDURE*)
	    BEGIN
	      IF EXTNAME = NIL THEN
		RELNAME := NAME
	      ELSE
		RELNAME := EXTNAME^ ;
	      IF DECLPLACE < EXTERNFORTRAN THEN BEGIN
		BASE(LEVEL - PFLEV); (*LOADS THE STATIC LINK*)
		GEN2(JSR,REG,PC,INDEX,PC);
		GENCONST( 0 ) ;
		PUTRLD ( RELNAME, RELOCFCN, 2*CODE.LEN-2, 0 ) ;
		IF (DECLPLACE=EXTRNL) AND PNOTUSED THEN BEGIN
		  PNOTUSED := FALSE;
		  PUTGSD ( RELNAME, GLOBALREFFLAGS, 0 ) ;
		END;
	      END
	      ELSE BEGIN
		GEN2(MOV,AUTINC,PC,AUTDEC,SP);
		GENCONST(PARLISTSIZE DIV 2);
		GENSUBRCALL( FORTR );
		GENCONST( 0 );
		PUTRLD ( RELNAME, RELOCFCN, 2*CODE.LEN-2, 0 );
		PUTGSD ( RELNAME, GLOBALREFFLAGS, 0 );
		IF KLASS = FUNC THEN BEGIN
		  GEN2(MOV,REG,AR,REGDEF,SP);
		  IF IDTYPE^.SIZE = 4 THEN BEGIN
		    GEN2(MOV,REG,R,INDEX,SP);
		    GENCONST( 2 );
		  END
		END
	      END;
	    END
	    ELSE (*CALL OF FORMAL PROCEDURE*)
	    BEGIN
	      LOD(LEVEL - PFLEV,PFADDR,4); (*LOAD THE PROCEDURE PARAMETER*)
	      GEN2(JSR,REG,PC,AUTINCDEF,SP)
	    END;
	    (* WITH FCP*)
	  GATTR.TYPTR := FCP^.IDTYPE;
	END (*CALLNONSTANDARD*);
	PROCEDURE CALLSTANDARD( FCP: CTP ) (*$Y+*);
	BEGIN (*CALLSTANDARD*)
	  LKEY := FCP^.KEY;
          IF NOIO THEN
            IF ((FCP^.KLASS = PROC) AND
                (LKEY IN [1,2,3,4,5,6,7,8,9,10])) OR
               ((FCP^.KLASS = FUNC) AND
                (LKEY IN [9,10,11]))
              THEN ERROR(185);
	  IF (FCP^.KLASS = PROC) AND (LKEY = 15) THEN
	    HALT
	  ELSE IF (FCP^.KLASS = FUNC) AND (LKEY = 13) THEN
	    RUNTIME1
	  ELSE IF (FCP^.KLASS = PROC) AND ((LKEY IN [2,4,8,10]) AND
	    (SY <> LPARENT)) THEN
	      CASE LKEY OF
		2:
		  FORMFEED;
		4:
		  BREAKLN;
		8:
		  READREADLN;
		10:
		  WRITEWRITELN
	      END
	    ELSE IF (FCP^.KLASS = FUNC) AND ((LKEY IN [9,10,11]) AND
	      (SY <> LPARENT)) THEN
		EOFEOLNIORES
	      ELSE BEGIN
		IF SY = LPARENT THEN
		  INSYMBOL
		ELSE
		  ERROR(9);
		IF FCP^.KLASS = PROC THEN
		  CASE LKEY OF
		    2:
		      FORMFEED;
		    4:
		      BREAKLN;
		    1,3, 5,6:
		      GETPUTRESETREWRITE;
		    7,8:
		      READREADLN;
		    9,10:
		      WRITEWRITELN;
		    11 :
		      NEW1;
		    12,13:
		      MARKRELEASE;
		    14:
		      DISPOSAL;
		    16 :
		      PACK;
		    17 :
		      UNPACK;
		    18,19 :
		      DATETIME
		  END
		ELSE IF LKEY IN [9,10,11] THEN
		  EOFEOLNIORES
		ELSE BEGIN
		  IF LKEY <> 24 (* ADDRESS *) THEN BEGIN
		    EXPRESSION(FSYS OR [COMMA,RPARENT]);
		    LOAD;
		  END;
		  CASE LKEY OF
		    1:
		      ABS;
		    2:
		      SQR;
		    3:
		      TRUNC;
		    4:
		      ODD;
		    5:
		      ORD;
		    6:
		      CHR;
		    7,8:
		      PREDSUCC;
		    12:
		      ROUND;
		    14:
		      SPLITREAL;
		    15:
		      TWOPOW;
		    16,17,18, 19,20,21:
		      ARITHMETICFUNCTIONS;
		    22:
		      SSIZE;
		    23:
		      POINTR;
		    24:
		      LADDRESS
		  END
		END;
		IF SY = RPARENT THEN
		  INSYMBOL
		ELSE
		  ERROR(4)
	      END
	END (*CALLSTANDARD*);
	(*$Y+*)  (* NEW MODULE *)
      BEGIN (* CALL *)
	IF FCP^.PFDECKIND = STANDARD THEN
	  CALLSTANDARD( FCP )
	ELSE BEGIN
	  CALLNONSTANDARD;
	  IF SY IN [LBRACK,PERIOD] THEN
	    CALLNS1
	END
      END (* CALL *);
    @<