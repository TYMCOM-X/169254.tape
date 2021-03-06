(*   +--------------------------------------------------------------+
     I                                                              I
     I                        Q S P R E D                           I
     I                        - - - - - -                           I
     I                                                              I
     +--------------------------------------------------------------+

     MDSI, COMPANY CONFIDENTIAL

     STARTED:  4-Aug-77

     PURPOSE: This package  contains  the  QED  routines  SPREDPARSE,
	SPREDMATCH,  and SPREDDISPOSE.

     USAGE:
	CALLING SEQUENCES:
		SPREDPARSE( LINE : CMDLINE;
			    var IDX : CMDLINEIDX;
			    var PRED : SPRED;
			    var ERR : QERRCODE) : boolean;
		SPREDDISPOSE( PRED : SPRED);
		SPREDMATCH( LINE : QSTRING;
			    PRED : SPRED;
			    var ERR : QERRCODE) : boolean;

     REQUIREMENTS: This  package  uses  entry points in the QSPAT and
	QSPATP packages.  It is the second  in  the  QED  LD  parsing
	hierarchy,  below  LDPARS.  Users  of SPREDDISPOSE should NIL
	the SPRED pointer after disposal.

     EFFECTS: SPREDPARSE returns a pointer to  a  tree  suitable  for
	matching by SPREDMATCH and disposal by SPREDDISPOSE.

     RESPONSIBLE: Jerry Rosen

     CHANGES: The following error codes can be returned by SPREDPARSE:
	QNONOT_OP  -- Invalid field after 'NOT' operator
	QNOINPAREN -- Invalid field after opening parenthesis
	QNOCLOSPAREN- Missing closing parenthesis
	QNORTOP    -- Invalid right-hand operator of AND or OR
	QSTUPID    -- Unmatchable predicate parsed

     SPREDPARSE can also return any error codes returned by SPATPARSE:
	QNOCLOSE   -- Missing closing delimiter for string pattern
	QNODEFAULT -- Default pattern has been parsed but not set

     ---------------------------------------------------------------- *)
$PAGE declarations
(* first, declarations for LOOKUP *)


type
    toktyp = (and_tok, or_tok, not_tok);
    cmdlist = record
      name : packed array[1..10] of char;
      abb : 1..10
    end;
    caller_list = array[toktyp] of cmdlist;

var
    whichfnd : toktyp;

const lexcon: caller_list :=
      (	('AND       ', 3),
	('OR        ', 2),
	('NOT       ', 3)  );
$PAGE includes and externals
$INCLUDE qerr.typ		(* QED error codes *)
$INCLUDE qstr.typ		(* QED string definitions *)
$INCLUDE qspat.typ		(* search pattern definitions *)
$INCLUDE qspred.typ		(* string predicate definitions *)
$INCLUDE cmdutl.typ		(* file_id definitions, etc. *)
$INCLUDE qedln.typ
$INCLUDE QLD.TYP
$INCLUDE QSPAT.INC

external function lookup( line : cmdline; var idx : cmdlineidx;
  list : caller_list; maxsc : toktyp; var which : toktyp) : boolean;

$PAGE spreddispose
public procedure spreddispose(pred : spred);

begin
  with pred^ do
  if pred <> nil then begin
    case predkind of
      not_spop:
	spreddispose(noper);
      and_spop, or_spop: begin
	spreddispose(loper);
	spreddispose(roper)
      end;
      pattern_spop:
	spatdispose (pattern)
    end; (*case*)
    dispose(pred)
  end
end;
$PAGE spredparse

public function spredparse( line : cmdline; var idx : cmdlineidx;
  var pred : spred; wildswitch : boolean; var err : qerrcode) : boolean;

label 1;


    (* Outsiders see only this wrapper--real work is done down below *)




  procedure error (derr : qerrcode; zap : spred);

  begin
    err := derr;
    spreddispose(zap);
    pred := nil;
    goto 1 (*Kickout of Recursion*)
  end;


$PAGE getspred
  (* GETSPRED parses <spred> ::= [ <spred>  ( AND | OR ) ] <subpred> *)

  function getspred (line : cmdline; var idx : cmdlineidx; var pred : spred;
    var err : qerrcode) : boolean;

  forward;


  (* GET SUB PRED parses
     <subpred> ::=  NOT <subpred>  |  <spat>  |  "(" <spred>  ")"    *)

  function getsubpred(line : cmdline; var idx : cmdlineidx; var pred : spred;
    var err : qerrcode) : boolean;

  var
      temptr : spred;
      pat : spattern;

  begin
    pred := nil;
    getsubpred := false;
    err := qok;
    if qtokenget(line,idx) then begin
      if lookup(line,idx,lexcon,not_tok,whichfnd) andif (whichfnd = not_tok)
	then begin
	  if (not getsubpred(line,idx,temptr,err)) then
	    error(qnonot_op, nil);
	  new(pred, not_spop);
	  pred^.noper := temptr;
	  getsubpred := true
	end
	else begin (*something but not a 'NOT' keyword *)
	  if line[idx] = '(' then begin
	    idx := idx + 1;
	    if not getspred(line,idx,temptr,err) then
	      error(qnoinparen,temptr);
	    if (not qtokenget(line,idx)) orif (line[idx] <> ')' ) then
	      error(qnoclosparen, temptr);
	    pred := temptr;
	    idx := idx + 1;
	    getsubpred := true
	  end
	  else begin (*not even a paren'd spred *)
	    if spatparse(line,idx,pat,wildswitch,err) then
	      if (err = qok) then begin
		new(pred, pattern_spop);
		pred^.pattern := pat;
		getsubpred := true
	      end
	      else
		error(err, nil)
	  end
	end
    end
  end;


$PAGE andoror, stupid
  function andoror(line : cmdline; var idx : cmdlineidx;
    var which : spred_kinds) : boolean;

  var save_idx: cmdlineidx;

  begin
    andoror := false;
    save_idx := idx;
    if lookup( line, idx, lexcon, not_tok, whichfnd) then begin
      if (whichfnd = or_tok) then begin
	andoror := true;
	which := or_spop
      end
      else if (whichfnd = and_tok) then begin
	andoror := true;
	which := and_spop
      end
      else (* whichfnd = not_tok *) begin
        idx := save_idx				(* back up, not interested in not here *)
      end
    end
  end;



  function stupid(pred:spred) : boolean;
  (* to catch those ridiculous unmatchable predicates *)

  begin
    stupid := false; (* assume the best *)
    if pred <> nil then
      if pred^.predkind = and_spop then
	with pred^ do
	  if (loper^.predkind = pattern_spop) andif
	    (roper^.predkind = pattern_spop) then
	      stupid := (not(loper^.pattern.stype in [simple, token])) andif
		(loper^.pattern.stype = roper^.pattern.stype)
  end; (*whew*)
$PAGE getspred_body, spredparse_mainline
  function getspred;

  var
      ltemp, rtemp : spred;
      which : spred_kinds;

  begin
    err := qok;
    pred := nil;
    getspred := getsubpred(line, idx, pred, err);
    if getspred then
      while andoror(line, idx, which) do
	if not getsubpred (line, idx, rtemp, err) then
	  error(qnortop, pred)
	else begin
	  if which = or_spop then
	    new(ltemp, or_spop)
	  else
	    new(ltemp, and_spop);
	  ltemp^.loper := pred;
	  ltemp^.roper := rtemp;
	  pred := ltemp;
	  if stupid(pred) then
	    error(qstupid,pred)
	end
  end;


  (*mainline for procedure SPREDPARSE *)


begin
  spredparse := getspred(line, idx, pred, err);
  1:
end;


$PAGE spredmatch
public function spredmatch(line : qstring; pred : spred; var err : qerrcode)
  : boolean;

var
    pos, len: qstringidx; (* discarded after pattern match *)

begin
  err := qok;
  case pred^.predkind of
    not_spop: begin
      spredmatch := not spredmatch (line, pred^.noper, err);
      if err <> qok then
	spredmatch := false
    end;
    and_spop:
      spredmatch := spredmatch (line, pred^.loper, err) andif
	spredmatch (line, pred^.roper, err);
    or_spop: begin
      if not spredmatch (line, pred^.loper, err) then begin
	if err <> qok then
	  spredmatch := false
	else
	  spredmatch := spredmatch (line, pred^.roper, err)
      end
      else
	spredmatch := true
    end;
    pattern_spop:
      spredmatch := spatmatch (line, pred^.pattern, pos, len, err)
  end
end.
    