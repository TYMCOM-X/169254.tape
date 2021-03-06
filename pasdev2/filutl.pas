module filutl ;

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

	open_file	Opens a file described by a file_id record.

     NOTES:  While the format of a file_id is system dependent,  such
	data is always represented as a string, and is thus printable.

     RESPONSIBLE: Software Tools

     CHANGES: 
       12/11/78 smr	Modified pr_file_id so that file protection codes
			may preceed the directory.
        1/31/80 smr	Rewrote PR_FILE_ID to scan VAX/VMS file names.
			Incorporated an automatically generated table 
			driven lexical analyzer.

	11/17/80 wem	Moved automatically  generated tables into a
			type file. Now accepts the "-" upward directory
			search character for vax filenames.
			PR_FILE_ID now has file recovery, eg. filenames
			such as _DRA1:[.tests)abc.deb;1    will now return
			an error indicator with the cursor pointing to the
			")".

	2/27/82 smk     This module is now the system independent code for
                        FILUTL. All system dependent code is in the file
                        FILUTL.TYP on each of the directories for the ADP,
                        TYMSHARE, VAX, and Motorola systems. As a result
                        the source code for get_char has been changed
                        (the function of get_char remains the same).

     ---------------------------------------------------------------- *)
$PAGE includes
$SYSTEM cmdutl.typ[31024,320156]
$SYSTEM query.inc[31024,320156]

(* The following file contains the expression description for the filenames.

 $include filutl.bnf

*)
$PAGE pr_file_id
(* PR FILE ID extracts a file title from an input string. If the title parses
   correctly, file_id information is set, the string cursor is advanced past
   the title and true is returned.  If the title is incorrectly formed, false
   is returned, and the cursor is left pointing to the character which is in
   error. The file_id information is not changed. 

   The algorithm used is a direct implementation of a table driven finite
   state machine.  The tables used were generated automatically by the
   program LEXGEN (see Dave Wilson).  The regular expressions used as
   input to LEXGEN may be found in file FILUTL.BNF.  The output file
   produced by LEXGEN was LEXFIL.OUT. The output file was transformed
   by hand to produce a type file for filutl. The name of the type file
   is FILUTL.TYP. THe tables used are the non-compacted form. *)

public function pr_file_id
	    (	line: cmdline; var idx: cmdlineidx;
		var fid: file_id		      ): boolean;

$if ADP
$include filutl.typ[31024,274427]
$endif
$if TYMSHARE
$include filutl.typ[31024,320156]
$endif
$if VAX
$include filutl.typ[31024,320157]
$endif
$if M68
$include filutl.typ[31024,320160]
$endif
$ifnone (ADP,TYMSHARE,VAX,M68)
  One of the system switches must be enabled to compile this module;
   legal switches are: 'ADP', 'TYMSHARE', 'VAX', and 'M68'.
$endif
$PAGE SCAN
PROCEDURE SCAN(BEGIN_INDEX: indexrange; var END_INDEX: INDEXRANGE;
               VAR LEXEME: LEXTOKEN);

   VAR
      CURRSTATE, CURRFINAL: EXSTATERANGE;
      OLDINDEX:  INDEXRANGE;

  (* GETCHAR maps characters from the input line into the terminal classes
     expected by SCAN and used to index the transition matrix.  *)

  function getchar (): terminal_range;

    var
      ch: char;

    begin

      if end_index >= length (line) then begin	(* past end of string *)
	getchar := eodata;
      end
      else begin
        end_index := end_index + 1;

        ch :=  line[ end_index ] ;

        getchar := char_set_codes[ ch ];

      end  (* else *) ;
    end  (* proc getchar *);


   BEGIN (* SCAN *)
      CURRSTATE := DFASTATE1;  (* START IN INITIAL STATE *)
      CURRFINAL := 0;
      OLDINDEX  := 0;  (* width of lexeme AS OF LAST FINAL STATE *)
      end_index := begin_index - 1;

      WHILE CURRSTATE <> 0 DO
         BEGIN
            IF FINAL[CURRSTATE] <> 0 THEN
               BEGIN
                  CURRFINAL := CURRSTATE;
                  OLDINDEX := END_INDEX - BEGIN_INDEX + 1
               END;
            CURRSTATE := DELTA[CURRSTATE, getchar ()];
         END;

      lexeme := token_kind [ final [ currfinal ] ];

      (* If an error has occured update the cursor to point at bad char *)

      if lexeme = error_token
	then oldindex := end_index - begin_index;

      END_INDEX := BEGIN_INDEX + OLDINDEX;	(* on exit, END_INDEX is index of 1st *)

   END; (* SCAN *)
$PAGE pr_file_id body

var end_index : indexrange;
    lexeme : lextoken;

begin	(* body of PR_FILE_ID *)

  scan ( idx, end_index, lexeme );

  pr_file_id := (idx <> end_index) and
	        (lexeme = file_token);

  if pr_file_id
    then fid := substr ( line, idx, end_index - idx );
  idx := end_index;

end (* proc pr_file_id *) ;
$PAGE open_file
(* OPEN FILE opens a text file for input or output. The mode is specified by
   the caller. For an output file the user can also request append mode and
   old/new file prompting.  The caller may supply a default extension for the
   file name. A flag is returned indicating if the open was successful. *)

public function open_file
	    (	var f: text;
		fid: file_id; ext: extension;
		mode: ( input_mode, output_mode );
		option_set: set of ( append_mode, confirm_open, ascii_mode )
	    ): boolean;

 var question: query_string;
     lext: packed array[1..5] of char;
 begin
  open_file := false;				(* assume failure *)
  lext := '.' || ext (* || ' ' *);
  case mode of 

    input_mode:
      begin
	if (option_set - [ascii_mode]) <> [] then
	  return; (* none applicable *)
	if ascii_mode in option_set
	  then open (f, lext || fid, [ascii])
	  else open (f, lext || fid);
	open_file := (iostatus = io_ok);
      end;

    output_mode:
      begin
	if confirm_open in option_set then begin
	  open (f, lext || fid);
	  if eof (f)
	    then question := 'New file: ' || fid
	    else begin
		question := 'Old file: ' || filename (f);   (* used full file_id of that found *)
		close (f)
	    end;
	  if not query (question) then return
	end;
	if append_mode in option_set
	  then rewrite (f, lext || fid, [preserve])
	  else rewrite (f, lext || fid);
	open_file := (iostatus = io_ok)
      end

  end;
 end.
   