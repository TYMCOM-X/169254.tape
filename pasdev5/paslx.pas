$title paslx - PASCAL compiler character input routines
$OPTIONS SPECIAL, NOCHECK

$INCLUDE PASDCL.INC

external procedure nextfile;

external procedure error (integer);

external procedure endofline;

external procedure getnextline;

external procedure fwdfileref;

external procedure fwdpageref;

external var
    buffer: packed array[1..chcntmax] of char;
    filedata: array[0..maxinclusion] of fileinfo;
    in_system: boolean;
    lines_read: integer;
    incl_lines_read: integer;
    origch: char;				(* CH BEFORE UPPERCASE *)
    commentlvl: integer;			(* NESTING LEVEL OF COMMENTS *)
    source: inputstate;
    inclnest: 0..maxinclusion;
    inclfile, incl2file				(*,
				       INCL3FILE,
				       INCL4FILE*): text;
    chcnt: 0..chcntmax;
    nestlv, pnestlv: integer;
    firstnestsetonline: boolean;

$PAGE setnest, zeronest, incnest, decnest
public procedure setnest;

begin
  if firstnestsetonline then begin
    pnestlv := nestlv;
    firstnestsetonline := false
  end
end;

public procedure zeronest;

begin
  nestlv := 0;
  if firstnestsetonline then begin
    pnestlv := 0;
    firstnestsetonline := false
  end
end;

public procedure incnest;

begin
  nestlv := nestlv + 1;
end;

public procedure decnest;

begin
  nestlv := nestlv - 1;
end;

$PAGE seoln
public function seoln: boolean;

begin
  case source of
    prompting:
      seoln := eoln (ttyi);
    reading:
      seoln := eoln (input);
    including:
      case inclnest of
	1:
	  seoln := eoln (inclfile);
	2:
	  seoln := eoln (incl2file)		(*;
		    3: SEOLN := EOLN (INCL3FILE);
		    4: SEOLN := EOLN (INCL4FILE)*)
      end
  end
end;

$PAGE seof
public function seof: boolean;

var
    incleof: boolean;

begin
  case source of
    prompting:
      seof := eof (ttyi);
    reading: begin
      incleof := eof (input);
      seof := incleof;
      if incleof then begin
	fwdfileref;
	fwdpageref;
	lines_read := lines_read + filedata[0].linecnt;
      end
    end;
    including: begin
      case inclnest of
	1: begin
	  incleof := eof (inclfile);
	  if incleof then
	    close (inclfile)
	end;
	2: begin
	  incleof := eof (incl2file);
	  if incleof then
	    close (incl2file)
	end					(*;
					  3: BEGIN
					       INCLEOF := EOF (INCL3FILE);
					       IF INCLEOF THEN CLOSE (INCL3FILE)
					     END;
					  4: BEGIN
					       INCLEOF := EOF (INCL4FILE)
					       IF INCLEOF THEN CLOSE (INCL4FILE)
					     END*)
      end;
      if incleof then begin
	fwdfileref;
	fwdpageref;
	with filedata[inclnest] do begin
	  lines_read := lines_read + linecnt;
	  incl_lines_read := incl_lines_read + linecnt;
	  if in_system then
	    if not was_in_system then begin
	      in_system := false;
	      listsource := was_listing;
	    end;
	end;
	inclnest := inclnest - 1;
	if inclnest < 1 then
	  source := reading;
	seof := seof()				(*RECURSE*)
      end
      else
	seof := false
    end
  end
end;

$PAGE sread
public procedure sread (* VAR CH: CHAR *);	(* CH NO LONGER PASSED AS A PARAMETER *)

begin
  case source of
    prompting:
      read (ttyi,ch);
    reading:
      read (input,ch);
    including:
      case inclnest of
	1:
	  read (inclfile,ch);
	2:
	  read (incl2file,ch)			(*;
			  3: READ (INCL3FILE,CH);
			  4: READ (INCL4FILE,CH)*)
      end
  end;
  chcnt := chcnt + 1;
  if chcnt <= linewidth then
    buffer[chcnt] := ch
end;

$PAGE sreadln
public procedure sreadln;

begin
  case source of
    prompting:
      readln(ttyi);
    reading:
      readln (input);
    including:
      case inclnest of
	1:
	  readln (inclfile);
	2:
	  readln (incl2file)			(*;
			   3: READLN (INCL3FILE);
			   4: READLN (INCL4FILE)*)
      end
  end
end;

$PAGE sgetlinenr
public procedure sgetlinenr (var linenr: linenrtype);

begin
  case source of
    prompting:
      linenr := '-----';
    reading:
      getlinenr (input, linenr);
    including:
      case inclnest of
	1:
	  getlinenr (inclfile, linenr);
	2:
	  getlinenr (incl2file, linenr)		(*;
		3: GETLINENR (INCL3FILE, LINENR);
		4: GETLINENR (INCL4FILE, LINENR)*)
      end
  end
end;

$PAGE litch
public procedure litch;

begin
  if seof then
    nextfile;
  if seof then begin
    if not eofn then begin
      if commentlvl > 0 then
	error (216);
      eofn := true;
      eol := true
    end;
    ch := ' ';
  end
  else begin
    if eol then begin
      endofline;
      sreadln;
      if not seof then
	getnextline
    end;
    eol := seoln;
    if eol then
      ch := ' '
    else
      sread					(* CH *)
  end;
end;

$PAGE nextch
public procedure nextch;

begin
  litch;
  origch := ch;					(*SAVE ORIGINAL CHARACTER*)
  ch := uppercase (ch)
end.
    