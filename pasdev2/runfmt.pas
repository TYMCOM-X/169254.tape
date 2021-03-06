$TITLE runfmt - Tymshare hack to run FORMAT
  
(* To link RUNFMT, use the command file RUNFMT.COM.  It loads RUN and JOBNUM
   in addition to RUNFMT itself.  *)
  
program runfmt;
  
$SYSTEM jobnum
external procedure run (packed array [1..*] of char; boolean);
  
const
  format_program: packed array [1..50] of char := 'format[31024,320156]';
  listings_account: string [30] := '[31024,314532]';
  
var
  i:		 integer;
  list_filename,
  label_filename,
  source_command,
  initials:	 string [30];
  label_line:	 string [200];
  listfile:	 text;
$PAGE utilities for printing banner pages
procedure skip_lines (start_line, end_line: integer);
  var j: integer;
  begin
    for j := start_line to end_line do
      writeln (listfile)
  end;
  
procedure star_lines (start_line, end_line: integer);
  var j: integer;
  begin
    for j := start_line to end_line do
      writeln (listfile, '#$#$#$#$#$#$#$#$#$#$#$ RUNFMT Version 1.0 #$#$#$#$#$#$',
                         '#$#$#$#$#$#$ RUNFMT Version 1.0 #$#$#$#$#$#$#$#$#$#$#$')
  end;
  
$PAGE mainline
begin
  rewrite (ttyoutput, 'tty:');
  open (tty, 'tty:');
  
  writeln (ttyoutput);
  write (ttyoutput, 'enter your initials-- ');
  break (ttyoutput);
  readln (tty);
  read (tty, initials);
  initials := substr (initials, 1, min (length (initials), 3));
  
  list_filename := initials || '.LST' || listings_account;
  label_filename := 'LABEL.' || initials || listings_account;
  
  reset (listfile, list_filename);
  if eof (listfile) then begin		(* file doesn't already exist *)
    reset (input, label_filename);
    if eof (input) then begin
      writeln (ttyoutput, '?cannot find ', label_filename);
      stop
    end;
    rewrite (listfile, list_filename || '<007>');
    star_lines (1, 3);
    skip_lines (4, 26);
    i := 26;
    while not eof (input) do begin	(* copy labelling *)
      readln (input, label_line);
      i := i + 1;
      writeln (listfile, label_line)
    end;
    skip_lines (i + 1, 44);
    star_lines (45, 52); 		(* run right across perforation *)
    skip_lines (5, 26);
    i := 26;
    reset (input, label_filename);
    while not eof (input) do begin	(* copy labelling *)
      readln (input, label_line);
      i := i + 1;
      writeln (listfile, label_line)
    end;
    close (input);
    skip_lines (i + 1, 47);
    star_lines (48, 51);		(* just down to perforation this time *)
    page (listfile)
  end;
  close (listfile);
  
  rewrite (output, jobnum || 'FMT.TMP');
  writeln (output, '/ECHO');
  writeln (ttyoutput);
  writeln (output, list_filename || '= /list/pass/xref/header/append');
  
  loop
    write (ttyoutput, 'input filename, or "done"-- ');
    break (ttyoutput);
    readln (tty);
    read (tty, source_command);
  exit if (source_command = ' ') or (uppercase (source_command) = 'DONE');
    writeln (output, source_command)
  end;
  writeln (output, '/QUIT');
  
  close (output);
  run (format_program, true)
end.
    