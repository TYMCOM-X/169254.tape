(*   +--------------------------------------------------------------+
     I                                                              I
     I                        F I L U T L                           I
     I                        - - - - - -                           I
     I                                                              I
     +--------------------------------------------------------------+

     MDSI, COMPANY CONFIDENTIAL

     STARTED: 24-Jul-77

     PURPOSE: Serves as a command utility  to  handle  filenames  and
	opennings.  System  dependencies,  such  as  the  format of a
	filename,  are isolated in this routine,  and need not be  of
	concern to the caller.

     ENTRY POINTS:

	pr_file_id	Scans an input line, parsing a filename.

	open_file	Opens a file described by a file_name record.

     NOTES:  While the format of a file_name is system dependent,  such
	data is always represented as a string, and is thus printable.

     RESPONSIBLE: Software Tools

     CHANGES: 
       12/11/78 smr	Modified pr_file_id so that file protection codes
			may preceed the directory.

     ---------------------------------------------------------------- *)
$PAGE includes
$INCLUDE cmdutl.typ
$INCLUDE query.inc



$PAGE pr_file_id
(* PR FILE ID extracts a file title from an input string. If the title parses
   correctly, file_name information is set, the string cursor is advanced past
   the title and true is returned.  If the title is incorrectly formed, false
   is returned, and the cursor is left pointing to the character which is in
   error. The file_name information is not changed. *)

public function pr_file_id
	    (	line: cmdline; var idx: cmdlineidx;
		var fid: file_name		      ): boolean;

 var ch: char;
     start: cmdlineidx;
     cnt: 0..6;
 type charset = set of char;

 function scan (chars: charset): boolean;
  begin
   scan := false;
   idx := idx + 1;
   while idx <= length (line) do begin
     ch := uppercase (line[idx]);
     if not (ch in chars) then return;
     scan := true;
     idx := idx + 1
   end;
   ch := ' '
  end;

function scan_dir: boolean;
  begin
      scan_dir := false;
      if scan (['0'..'7']) then ;
      if ch <> ',' then return;
      if scan (['0'..'7']) then ;
      cnt := 0;					(* get SFD's *)
      while ch = ',' do begin
	if not scan (['A'..'Z','0'..'9','#','?','*']) then return;
	if cnt = 6 then return;
	cnt := cnt + 1
      end;
      if ch <> ']' then return;
      if scan ([]) then ;			(* advance one char *)
      scan_dir := true;
  end;						(* end scan_dir *)

function scan_prot: boolean;			(* scan protect codes *)
  begin
      scan_prot := false;
      if not scan (['0'..'7']) then return;
      if ch <> '>' then return;
      if scan([]) then ;		(* scan the '>' *)
      scan_prot := true
  end;


 begin
  pr_file_id := false;				(* assume failure, if error, abort by return *)
  idx := idx - 1;				(* scan increments index first thing *)
  start := idx;

  if scan (['A'..'Z','0'..'9','#','?','*']) then begin	(* get device or file name *)
    if ch <> ':'				(* was that a device name ? *)
      then idx := start				(* no fname, join code below *)
  end
  else idx := start;				(* no name, backup *)

  if scan (['A'..'Z','0'..'9','#','?','*']) then begin	(* get file name *)
    if ch = '.' then begin			(* get extension *)
      if scan (['A'..'Z','0'..'9','#','?','*']) then ;
    end;

    if ch = '[' then begin			(* get directory *)
      if not scan_dir then return;
      if (ch = '<') andif not scan_prot then return
    end else
    if ch = '<' then begin			(* get protection *)
      if not scan_prot then return;
      if (ch = '[') andif not scan_dir then return
    end
  end;

  if idx > start + 1 then begin			(* if ptr advanced past 1st char, have a valid fid *)
    pr_file_id := true;
    fid := substr (line, start+1, idx-(start+1))
  end
 end;
$PAGE open_file
(* OPEN FILE opens a text file for input or output. The mode is specified by
   the caller. For an output file the user can also request append mode and
   old/new file prompting.  The caller may supply a default extension for the
   file name. A flag is returned indicating if the open was successful. *)

type
  io_mode = ( input_mode, output_mode );
  io_options = ( append_mode, confirm_open );
  io_option_set = set of io_options;

public function open_file
	    (	var f: text;
		fid: file_name; ext: extension;
		mode: io_mode; option_set: io_option_set   ): boolean;

 var question: query_string;
     lext: packed array[1..5] of char;
 begin
  open_file := false;				(* assume failure *)
  lext := '.' || ext (* || ' ' *);
  case mode of 

    input_mode:
      begin
	if option_set <> [] then return;		(* none applicable *)
	open (f, lext || fid);			(* this effects default *)
	open_file := not eof (f)
      end;

    output_mode:
      begin
	if confirm_open in option_set then begin
	  open (f, lext || fid);
	  if eof (f)
	    then question := 'New file: ' || fid
	    else begin
		question := 'Old file: ' || filename (f);   (* used full file_name of that found *)
		close (f)
	    end;
	  if not query (question) then return
	end;
	rewrite (f, lext || fid, (append_mode in option_set));
	open_file := eof (f)
      end

  end;
 end.
   