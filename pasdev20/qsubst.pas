$PAGE declarations and includes
type
  sub_options =
    ( confirm_sop, all_sop, print_sop, number_sop  );

  sub_opt_set = set of sub_options;


$INCLUDE qed.typ                (* QED command types *)
$INCLUDE qerr.typ		(* QED error codes *)
$INCLUDE qstr.typ		(* QED string definitions *)
$INCLUDE qspat.typ		(* search pattern definitions *)
$INCLUDE qspred.typ		(* string predicate definitions *)
$INCLUDE cmdutl.typ		(* file_id definitions, etc. *)
$INCLUDE qedln.typ
$INCLUDE QSPAT.INC
$INCLUDE RLB:QUERY.INC
$INCLUDE QPRINT.INC
$PAGE qsubstitute
public function qsubstitute			(* substitute one string for another in a third *)
(	var line: qstring;			(* line in which substitution is to be made *)
	lineno: qlineno;			(* above's line number *)
	pat: spattern;				(* pattern to search for *)
	rplmtstr: qstring;			(* string to replace it with *)
	options: sub_opt_set;			(* various action-modifiers *)
	var cnt: qstringidx;			(* number of substitutions made *)
        cmd : qedcmds;                          (* parsed command *)
        var nth : qlineno;                      (* count of occurrances *)
        n_par : qlineno;                        (* occurrance parameter *)
	var err: qerrcode			(* error report *)
		): boolean;			(* flag indicating success of substitution *)

label 1;

var
  tempstr: qstring;
  numberit,
  doit: boolean;
  pos,
  len,
  idx: qstringidx;
  repstr : qstring;

begin
  err := qok;
  idx := 1;
  cnt := 0;
  nth := 0;
  qsubstitute := false;
  numberit := (lineno <> 0) and (number_sop in options);

  loop
    tempstr := substr (line, idx);		(* bug fix ? *)
    doit := spatmatch (tempstr, pat, pos, len, err);
  exit if (not doit) or (err <> qok);
    nth := nth +1;
    if nth >= n_par then begin

      qsubstitute := true;
      if numberit then
      begin
	writeln (tty, lineno:5);
	numberit := false
      end;
      if confirm_sop in options then
      begin
	writeln (tty, substr (line, 1, idx + pos - 2), '\', substr (line, idx + pos -1, len),
	  '\', substr (line, idx + pos + len - 1));
	doit := query ('OK')
      end;
      if doit then
      begin
	if (cmd = substitute) then repstr := rplmtstr
	  else if (cmd = before) then repstr := rplmtstr||substr(line, idx+pos-1, len)
	    else if (cmd = after) then repstr := substr(line, idx+pos-1, len)||rplmtstr
	      else err := qbadcmd;
	if idx + pos - 1 + length (repstr) - 1 +
	  length (substr (line, idx + pos - 1 + len)) <= qstringlen then
	  line := substr (line, 1, idx + pos - 2) || repstr ||
	    substr (line, idx + pos + len - 1)
	else err := qlnlong;
	cnt := cnt + 1;
	idx := idx + pos + length (repstr) - 1;	(* advance past inserted string *)
      end
      else idx := idx + pos + len - 1;		(* advance past matched string *)
      if not ((all_sop in options) and (pat.stype in [simple, token])) then goto 1
    end                                           (* if nth begin *)
  else idx := idx + pos + len - 1  (* advance past the matched string *)
  end;						(* loop *)
1:
  if (cnt > 0) and (print_sop in options) then prline (ttyoutput, line, true, err)
end.						(* qsubstitute *)
 