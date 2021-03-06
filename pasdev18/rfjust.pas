$TITLE rfjust
$OPTIONS special
$PAGE includes and externals
$INCLUDE rfdata.inc

external procedure readline
     (  var cmdkind: command_words;
	var line: line_type	    );
$PAGE justify

public procedure justify 
	( var linekind: command_words;
	  var line: line_type;
	  page_width: points	       );

static var				(* for scanning input line *)
  curline: line_type := nil;		(* last line read, as readline returns nil at
					   end of file, this is always nil at the
					   start of a run. *)
  curkind: command_words;		(* designation of curline *)
  curnumber: line_number;		(* current input line number *)
  curpos: line_index;			(* scanning cursor in curline *)
  insertright: boolean := true;		(* side from which to pad when aligning *)

var
  buffer: line_type;
  buflen: line_index;
  bufwidth: points;
  exchar: character;
  word_start: line_index;
  word_width: points;
  idx: line_index;
  space_points: array[1..max_line_length] of line_index;	(* position in buffer of spaces *)
  nwords: line_index;				(* number of words on line *)
  insert: points;
  extra: points;

label 100;				(* abort on command line read *)


begin
  buffer := nil;			(* empty the buffer *)
  buflen := 0;
  bufwidth := 0;
  nwords := 0;

  if curline = nil then begin			(* make sure that we have a line of input *)
    readline (curkind, curline);
    curpos := 1;
  end;
  if curkind <> nonword then goto 100;		(* command found - as the buffer is empty,
						   command line will be returned now *)

  (* cont. *)
$PAGE alloc the line - justify (cont.)

  (* Allocate a line that is capable of holding the line that we are to read.
     The line is actually over allocated here deliberately for two reasons:
     (1) to make sure that there is enough room, and (2) to make sure that we
     always allocate the same size node, so that performance is improved. *)

  new (buffer: page.width);
  with buffer^ do begin
    next := nil;
    indentation := 0;
    spacing := 0;
    total_width := 0;	(* these three are updated on exit *)
    textlen := 0;
    number := curnumber;
  end;
$PAGE fetch a line - justify (cont.)

  (* Accumulate enough words to fill one line, but no more.  We exit in one
     of two cases. (1) A word is found which overflows the line width.
     In this case, we backup the input read so that the offending word is
     reread on the next call. (2) A command line is found; in this case, the
     buffered line is flushed immediately. *)

  loop
    (* Skip blanks, looking for next word in input. *)

    loop			(* until non-blank found *)
      while curpos > curline^.textlen do begin	(* fetch a new line *)
	dispose (curline);
	readline (curkind, curline);
	curpos := 1;
	if curkind <> nonword then goto 100;	(* flush when command seen *)
      end;
      exchar := curline^.text[curpos];
    exit if exchar.ch <> ' ';
      curpos := curpos + 1;
    end;

    (* Now copy the word into output line buffer.  If it overflows, we will
       back up in the input. *)

    word_start := curpos;		(* remember where it started, in case we have to back up *)
    word_width := 0;

    repeat	(* scan for end of the word *)
      with curline^ do begin		(* scan for end of word *)
	buflen := buflen + 1;	(* add char to buffer *)
	buffer^.text [buflen] := exchar;
	word_width := word_width + exchar.width;
	curpos := curpos + 1;
    exit if curpos > textlen;
	exchar := text[curpos];		(* get current character *)
      end (* with *) ;
    until exchar.ch = ' ';

    (* Try to add the word to the line being constructed.  If it is too much
       backup the input read. *)

  exit if (bufwidth + word_width) > page_width
      do begin				(* word over flows buffer, backup *)
	buflen := buflen - (curpos - word_start);
      if buflen > 0 then begin	(* remember to delete extra space at end *)
	buflen := buflen - 1;
	bufwidth := bufwidth - buffer^.text[buflen].width;
      end;
				(****** must check for word too long ******)
	curpos := word_start;
      end;

    (* Okay to append the word to the line *)

    if bufwidth = 0 			(* record number of input line containing first word *)
      then curnumber := curline^.number;
    bufwidth := bufwidth + word_width;
    nwords := nwords + 1;

    (* Try to add a blank to the line at the end of the word just appended.
       Use extra wide space follow clause terminators. *)

    exchar.ch := ' '; exchar.font := standard;
    if buffer^.text[buflen].ch in ['.',';']
      then exchar.width := 2
      else exchar.width := 1;
  exit if (bufwidth + exchar.width) > page_width;
    buflen := buflen + 1;	(* okay to append spaces *)
    buffer^.text[buflen] := exchar;
    bufwidth := bufwidth + exchar.width;
    space_points [nwords] := buflen;		(* record where the space is *)

  end (* loop to build line *) ;

  (* cont. *)
$PAGE left justification - justify (cont.)

  (* At this point we have a line whose length is less that the required
     width.  If in fill mode, where we leave a jagged right margin, we
     are done.  If in align mode, we must pad out the buffered line so
     that the right margin is straight. *)

  if cur_state = alignmode then begin
    insert := (page_width - bufwidth) div (nwords - 1);	(* # to pad each word *)
    extra := (page_width - bufwidth) mod (nwords - 1);	(* # to pad extra from some side *)

    if insert > 0 then begin
      for idx := 1 to nwords - 1 do 
	with buffer^.text [space_points [idx]] do
	  width := width + insert;
    end;
    insertright := not insertright;			(* change padding direction *)
    if insertright
      then for idx := nwords-1 downto nwords-extra do
	with buffer^.text [space_points [idx]] do
	  width := width + 1
      else for idx := 1 to extra do
	with buffer^.text [space_points [idx]] do
	  width := width + 1
  end;

  (* cont. *)
$PAGE flush buffer - justify (cont.)

100 (* flush on command read *) :

  (* If we have just read a command, and there is nothing in the buffer,
     then return the command line immediately.  Otherwise, return the
     partial buffer. *)

  if (buflen = 0) and (curkind <> nonword) then begin
    linekind := curkind;
    line := curline;
    curline := nil;			(* cause a new line to be read at next call *)
    if buffer <> nil then dispose (buffer);	(* allocated, but not used *)
    return;
  end;

  (* Return the buffer load.  If we have only a partial line, it is possible
     that there is a trailing space in the buffer.  Remove it if it is there. *)

  if buffer^.text[buflen].ch = ' ' then begin	(* strip a trailing space *)
    bufwidth := bufwidth - buffer^.text[buflen].width;
    buflen := buflen - 1;
  end;

  with buffer^ do begin		(* fill in lengths, etc. *)
    textlen := buflen;
    total_width := bufwidth;
    number := curnumber;
  end;
  line := buffer;		(* return the line *)
  linekind := nonword;		(* returning a text line, not a command *)

end.
 