program xrfdmp;

type
    xrf_record = packed record
	code: 0 .. 16;
	var_lab_parm: boolean;
	parameter: 0 .. 777777b
    end;

    xrf_file = file of xrf_record;

var
    textin: text;
    input: xrf_file;
    rec: array [1..40, 1..5] of packed record
	code: 0 .. 31;
	var_lab_parm: boolean;
	parameter: 0 .. 777777b
    end;
    i, j: 1 .. 40;
    columns: 1 .. 5;
    page_no: 0 .. 999;
    title: string [100];

    names: array [0 .. 17] of packed array [1..8] of char :=
     (  'VALUE', 'MOD', 'VAR PARM', 'REF', 'FILE', 'PAGE', 'LINE', 'BLOCK',
	'END', 'INDEX', 'DEREF', 'CALL', 'FIELD', 'WFIELD', 'DECLARE',
	'FILEBLK', 'BASE REC', ''  );

$INCLUDE rlb:cmdutl.typ
external function pathname ( var text ): file_id;

$INCLUDE getiof.inc[52250,246]

$INCLUDE corout.inc[52250,234]

var get_record: environment;

procedure get_rec;
begin
  detach;
  loop
    while not eof (input) andif (input^.code in [4..6]) do begin
      rec[j,i].code := input^.code;
      rec[j,i].var_lab_parm := input^.var_lab_parm;
      rec[j,i].parameter := input^.parameter;
      get (input);
      detach;
    end;
    while not eof (input) andif not (input^.code in [4..6]) do begin
      rec[j,i].code := input^.code;
      rec[j,i].var_lab_parm := input^.var_lab_parm;
      rec[j,i].parameter := input^.parameter;
      get (input);
      detach;
    end;
    if eof (input) then
      loop
	rec[j,i].code := 17;
	rec[j,i].var_lab_parm := true;
	detach;
      end
    else
      begin
	rec[j,i].code := 17;
	rec[j,i].var_lab_parm := false;
	detach;
      end;
  end;
end (* get_rec *);


begin
  rewrite (tty);
  open (tty);
  getiofiles (textin, output, 'XRF', 'LST');
  reset (input, pathname (textin));
  title := 'CROSS REFERENCE LISTING OF ' || pathname (textin) || ', PAGE ';
  if substr (pathname(output), 1, 3) = 'TTY'
    then columns := 4
    else columns := 5;
  close (textin);
  page_no := 0;
  get_record := create (get_rec, 100);
  repeat
    page_no := page_no + 1;
    if page_no <> 1 then
      page (output);
    writeln (output, ' ':(20*columns-length(title)-3) div 2, title, page_no:3);
    writeln (output);
    writeln (output);
    for i := 1 to columns do
      for j := 1 to 40 do
	call (get_record);
    for i := 1 to 40 do begin
      with rec [i,1] do
    exit if (code = 17) and var_lab_parm;
      for j := 1 to columns do begin
	with rec [i,j] do begin
      exit if (code = 17) and var_lab_parm;
	  if j <> 1 then
	    write (output, ' ':5);
	  write (output, names[code]);
	  if code in [0..7, 12..14] then begin
	    if (code in [0..3, 12..14]) and var_lab_parm
	      then write (output, ' * ')
	      else write (output, '   ');
	    write (output, parameter:5);
	  end
	  else
	    write (output, ' ':8);
	end;
      end;
      writeln (output);
    end;
  until eof (input);
end.
    