$TITLE sw_ini -- Pascal Callable SWITCH.INI Processor
$LENGTH 43

$HEADER swini.hdr
$PAGE declarations

type
    sw_ini_name = string [6];
    sw_ini_string = string [128];

var
    switch_file: text;
    ch: char; (* The input character buffer. *)

const
    eol = chr (13); (* Ascii CR *)

procedure get_char;
begin
  if eoln (switch_file)
    then ch := eol
    else read (switch_file, ch);
end;
$PAGE sw_ini

public function sw_ini ( prog: sw_ini_name;
			 opt: sw_ini_name;
			 var switches: sw_ini_string ): boolean;

var
    name: sw_ini_name;

begin
  open (switch_file, 'SWITCH.INI');
  sw_ini := false;
  while not eof (switch_file) and not sw_ini do begin

    (*  Get the program name.  *)

    name := '';
    repeat
      get_char
    until ch <> ' ';
    while uppercase (ch) in ['A'..'Z', '0'..'9'] do begin
      name := name || uppercase (ch);
      get_char;
    end;

    if name = prog then begin

      (*  Get the option name, if any. *)

      name := '';
       while ch = ' ' do
	get_char;
      if ch = ':' then begin
	repeat
	  get_char
	until ch <> ' ';
	while uppercase (ch) in ['A'..'Z', '0'..'9'] do begin
	  name := name || uppercase (ch);
	  get_char;
	end;
	while ch = ' ' do
	  get_char;
      end;

      if name = opt then begin
	switches := '';
	while ch <> eol do begin
	  switches := switches || ch;
	  get_char;
	end;
	sw_ini := true;
      end (* nam = opt *);
    end (* name = prog *);
    readln (switch_file);
  end (* while *);
  close (switch_file);
end (* sw_ini *).
   