$TITLE fio - formated output package
$LENGTH 43

module fio;

$INCLUDE fio.typ
$PAGE fio_nop
(* FIO NOP performs no action.  It is used as the page_header procedure when no
   header is required, e.g. the default case. *)

public procedure fio_nop (var fb: file_block);
begin
end;
$PAGE fio_eject
(* FIO EJECT emits a form feed to the output file.  It is used as the new_page
   procedure in the default case, when the output file is intended for the
   line printer. *)

public procedure fio_eject ( var fb: file_block );
begin
  with fb do
    page (file_var);
end;
$PAGE fio_open
(* FIO OPEN opens a specified text file for output and initializes the control
   block to default values. *)

public procedure fio_open (var fb: file_block; file_name: packed array [1..*] of char);
begin
  with fb do begin
    rewrite (file_var, file_name);
    file_title := filename (file_var);
    pageno := 1;
    lineno := 1;
    column := 1;
    width := max_width;
    c_column := 0;
    plength := 0;
    new_page := fio_eject;
    page_header := fio_nop;
  end (* with *) ;
end;
$PAGE fio_reopen
(* FIO REOPEN opens a specified text file for continued output.  The file is
   opened in append mode, and the control block is *not* reinitialized.  It is
   assumed that it has been previously opened with fio_open. *)

public procedure fio_reopen (var fb: file_block);
begin
  rewrite (fb.file_var, fb.file_title, [preserve]);
end;
$PAGE fio_attach
(* FIO ATTACH takes a file which has already been opened for output, and
   initializes a control block for it. *)

public procedure fio_attach (var fb: file_block; fil: text);
begin
  with fb do begin
    file_var := fil;
    file_title := filename (fil);
    pageno := 1;
    lineno := 1;
    column := 1;
    width := max_width;
    c_column := 0;
    plength := 0;
    new_page := fio_eject;
    page_header := fio_nop;
  end (* with *);
end;
$PAGE fio_close
(* FIO CLOSE closes a file opened by fio_open or fio_reopen.  The control block
   is not modified in order that a subsequent reopen call may be made. *)

public procedure fio_close (var fb: file_block);
begin
  close (fb.file_var);
end;
$PAGE fio_page
(* FIO PAGE forces the output file to the top of a page (invoking the new_page
   routine if necessary), and then invokes the page_header routine. *)

public procedure fio_page (var fb: file_block);
begin
  with fb do begin
    if column <> 1 then writeln (file_var);
    if (lineno <> 1) or (column <> 1) then begin	(* don't page if already at top of page *)
      new_page (fb);
      pageno := pageno + 1;
      lineno := 1;
      column := 1;
    end;
    page_header (fb); (* emit header, if any *)
  end;
end;
$PAGE fio_skip
(* FIO SKIP moves the output to the beginning of a new line.  The state of the
   file block is altered so that if a page is overflowed, the next output operation
   will cause a skip to the top of a new page. *)

public procedure fio_skip (var fb: file_block);
begin
  with fb do begin
    if (column = 1) andif (plength <> 0) andif (lineno > plength)
      then fio_page (fb)
      else begin
	lineno := lineno + 1;
	column := 1;
	if (plength = 0) orif (lineno <= plength) then
	  writeln (file_var); (* No eoln if new page coming. *)
      end;
  end;
end;
$PAGE fio_nskip
(* FIO NSKIP is equivalent to N calls to fio_skip, except that it will never
   write beyond the top of a new page.  Fio_nskip will also test whether there
   are M lines remaining on the current page, and will force a page skip if
   there are not. *)

public procedure fio_nskip ( var fb: file_block; nskip, nleft: integer );
var i: integer;

begin
  with fb do begin
    if (column = 1) andif (plength <> 0) andif (lineno > plength)
      then fio_page (fb)
      else begin
	column := 1;
	if (plength = 0) orif (lineno + nskip + nleft <= plength) then begin
	  for i := 1 to nskip do
	    writeln (file_var);
	  lineno := lineno + nskip;
	end
	else
	  lineno := plength + 1;
      end;
  end;
end;
$PAGE fio_tab
(* FIO TAB moves the output to a specified column position.  If the target column
   lies before the current column position, a new line is started before tabbing. *)

public procedure fio_tab (var fb: file_block; tabcol: fio_width);

 var
   i, tcol: fio_width;

const
    ht = chr (011b);

 begin
  with fb do begin
    tcol := min (tabcol, width);

    if column > tcol then fio_skip (fb);

    if column = tcol then return;

    if (column = 1) andif (plength <> 0) andif (lineno > plength)
      then fio_page (fb);

    for i := 1 to (((tcol - 1) div 8) - ((column - 1) div 8)) do
      write (file_var, ht);
    write (file_var, ' ': min ((tcol - 1) mod 8, tcol - column));
    column := tcol;
  end;
 end;
$PAGE fio_write
(* FIO WRITE outputs a string to the file.  Page width and length limitations are
   checked for and enforced. *)

public procedure fio_write (var fb: file_block; str: packed array [1..*] of char);

var idx, l: integer;

begin
  with fb do begin
    if (column = 1) andif (plength <> 0) andif (lineno > plength)
      then fio_page (fb);

    if (length (str) > width - column + 1) and
       (length (str) <= width - c_column + 1) and
       (c_column <> 0) then
      fio_tab (fb, c_column);

    idx := 1;
    loop
      l := min (length (str) - idx + 1, width - column + 1);
      write (file_var, substr (str, idx, l));
      idx := idx + l;
      column := column + l;
    exit if (idx > length(str)) or (c_column = 0);
      fio_tab (fb, c_column);
    end;
  end (* with fb *);
end;
$PAGE fio_line
(* FIO LINE writes a string to a file and skips to a new line.  Page width and
   length limitations are applied. *)

public procedure fio_line (var fb: file_block; str: packed array [1..*] of char);
 begin
  fio_write (fb, str);
  fio_skip (fb);
 end;
$PAGE fio_space
(* FIO SPACE emits a specified number of spaces to the output file. *)

public procedure fio_space ( var fb: file_block; spaces: fio_width);

begin
  fio_tab (fb, fb.column+spaces);
end.
 