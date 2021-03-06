$PAGE includes and externals
$SYSTEM QERR.TYP[,245]
$SYSTEM QSTR.TYP[,245]
$SYSTEM QSPAT.TYP[,245]
$SYSTEM QSPRED.TYP[,245]
$SYSTEM RLB:CMDUTL.TYP
$SYSTEM QEDLN.TYP[,245]
$SYSTEM QLD.TYP[,245]
$SYSTEM QED.TYP[,245]
$SYSTEM QSPLIT.TYP[,245]
$SYSTEM QSUBST.INC[,245]
$PAGE command processing tables
type
  rangetypes =
    ( one, dollar, dot, dotp1, lb, lbp1);

$SYSTEM RLB:LOOKUP.TYP

type
  rangelist =
    record
      lbound, hbound1, hbound2: rangetypes;
      required, permitted: ldcount
    end;


  qcmdlist = array [qedcmds] of cmdlist;

  sub_opt_list = array [sub_options] of cmdlist;

  set_par_list = array [set_params] of cmdlist;

  split_op_list = array [split_options] of cmdlist;

  defrangelist = array [qedcmds] of rangelist;


external const
  qcmds: qcmdlist;
  sops: sub_opt_list;
  setparams: set_par_list;
  splitops: split_op_list;
  defrange: defrangelist;

type
  qdatarec =
    record
      linecount,
      maxdel: qlineno;
      openfileopen: boolean;
      lasterr: qerrcode;
      errlevel: cmdlineidx
    end;

static var
  qdata: qdatarec;
  openfile: text;
  list_file: text;
  saved_bounds: boolean;			(* to push and pop buffer bounds *)
  lbound_save,
  hbound_save: qlineno;
$PAGE qexecute
public procedure qexecute
(       var buffer:     qbuffer;		(* working buffer *)
	line:           cmdline;		(* command line to parse *)
	var lindex:     cmdlineidx;		(* place marker *)
	var execrange:  ldrange;		(* limits of execution *)
	var ble:        qlineno;		(* bottommost line examined *)
	findflag:       boolean;		(* running under find? *)
	allowed_cmds:   qed_cmd_set;		(* which commands are legal? *)
	var err:        qerrcode);		(* anything wrong? *)


const
  confirm_file := true;				(* new/old file prompting desired *)

var						(* parsing routine args, etc. *)
  nld:          ldcount;			(* number of la's in ld *)
  ld:           ldchain;			(* pointer to parsed ld linked list *)
  cmd:          qedcmds;			(* parsed command *)
  cmdrange:     ldrange;			(* value of parsed ld *)

var						(* command routine identifiers *)
  fid:          file_id;			(* for file reading and writing *)
  cnt:          qlineno;			(* line count for APPENDs *)
  confirm,
  doit:         boolean;			(* for conditional tests throughout *)
  lp:           qlinep;				(* for debugging *)
  sop:		sub_options;			(* substitute storage *)
  sop_set:	sub_opt_set;			(* for option parsing *)
  splitop:	split_options;			(* split option parsing *)
  splitop_set:	split_opt_set;			(* ditto *)
  idx:		qlineno;			(* counter for running through buffer *)
  pat:		spattern;			(* pattern parsing for substitute, find *)
  pred:		spred;				(* for SET parsing & bound *)
  repstr:	qstring;			(* replacement string in substitute request *)
  total:	qlineno;			(* to keep track of changes made *)
  source:	qstring;			(* place to keep text of looked-up line *)
  pos,
  stridx,
  len:		qstringidx;			(* indicies into QED-type strings *)
  fno,
  lno:		qlineno;			(* boundary markers *)
  tmprange:	ldrange;			(* for additional LD parsing *)
  findble:	qlineno;			(* for FIND to keep track with *)
  find_cmds:	qed_cmd_set;			(* legal commands under FIND *)
  optcmd:	qedcmds;			(* for option parsing in MOVE, COPY *)
  setopt:	set_params;			(* for SET parameter parsing *)
  have_file:	boolean;			(* true if file parameter present *)
  old_cmdrange: ldrange;			(* temp used in find command *)
$PAGE utilities
  procedure chkrng (cmd: qedcmds; var nld: ldcount; var range: ldrange;
    findflag: boolean; var err: qerrcode);

    function decode (arg: rangetypes): qlineno;
    begin
      case arg of
	one:    decode := 1;
	dot:    decode := buffer.curlineno;
	dotp1:  decode := buffer.curlineno + 1;
	lb:     decode := cmdrange.lbound;
	lbp1:   decode := cmdrange.lbound + 1
      end					(* case *)
    end;					(* decode *)

  begin
    err := qok;
    if (nld = 0) and (defrange[cmd].permitted = 0) then return;
    if (nld > defrange[cmd].permitted) or (nld < defrange[cmd].required)
      and (not findflag) then err := qbadargno
    else begin
$IF all
      if nld = 0 then
	if findflag then
	begin
	  range.lbound := buffer.curlineno;
	  range.hbound := buffer.curlineno;
	  nld := 1				(* suppress NLD=0 special cases when executing under
						   FIND, e.g. LIST *)
	end
	else
	begin
	  range.lbound := decode (defrange[cmd].lbound);
	  range.hbound := decode (defrange[cmd].hbound1)
	end
      else if nld = 1 then range.hbound := decode (defrange[cmd].hbound2);
$END
      if not ( ((nld = 0) and (cmd in [bound, writecmd, save])) or
	       ((range.lbound = 0) and (cmd = append))		)
	then with range do begin
$IF all
	  if lbound > hbound
	    then if qbuflength (buffer) = 0
	      then err := qempty
	      else err := qbadrn
	  else if lbound < 1
	    then err := qbadlb
	  else if hbound > qbuflength (buffer)
	    then err := qbadub
$END
	end
    end
  end;						(* chkrng *)
$PAGE begin main command loop
begin						(* begin body of qexecute *)
  saved_bounds := false;
end.
    