program lextst;

$SYSTEM cmdutl.typ[31024,320156]
$SYSTEM filutl.inc[31024,320156]
$SYSTEM query.inc[31024,320156]

var
  opt_set : io_option_set;
  f : text;
  line: cmdline;
  idx: cmdlineidx;
  fid: file_id;
  fname : file_id;
  b: boolean;

begin
  open ( tty );
  rewrite ( ttyoutput );

  loop
    write ( ttyoutput, 'Enter file specifier: ' );
    break ( ttyoutput );
    if eoln ( tty ) then readln ( tty );
    read (tty, line );
  exit if line = '';

    idx := 1;
    b := pr_file_id ( line, idx, fid );

    write ( ttyoutput, b, '  IDX: ', idx );
    if b
      then writeln ( ttyoutput, '  FID: ', fid )
      else writeln ( ttyoutput );
  end  (* loop *) ;

  (* Now try some open files. *)

  loop
    write ( ttyoutput , 'File to open: ' );
    break ( ttyoutput );
    readln ( tty );
    read ( tty , fname );
  exit if fname = '';

      opt_set := [ ];
      if query ( '_ascii' ) then opt_set := opt_set + [ ascii_mode ];
      if query ( '_confirm' ) then opt_set := opt_set + [ confirm_open ];
      if query ( '_preserve' ) then opt_set := opt_set + [ append_mode ];
      if open_file ( f , fname , ' ' , output_mode , opt_set )
	then begin
	  repeat
	    write ( ttyoutput,'Enter text for file: ' );
	    break ( ttyoutput );
	    readln ( tty );
	    read ( tty , line );
	    if line <> '' then writeln ( f , line )
	  until line = '';
	  close ( f );
	end
      else writeln ( ttyoutput , 'Error in file open for file ' , fname );

      if open_file ( f , fname , ' ' , input_mode , [] )
	then begin
	  writeln ( ttyoutput , 'Beginning of file- ' , fname );
	  if not eof ( f ) then readln ( f );
	  while not eof ( f ) do
	    begin
	      read ( f , line );
	      writeln ( ttyoutput , line );
	      readln ( f );
	    end;
	  writeln ( ttyoutput , 'End of file- ', fname );
	  close ( f );
	end
      else writeln ( ttyoutput , 'Error in opening file ' , fname );
  end;		(* loop *)
end.
   