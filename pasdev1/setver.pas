program setver options special (word);

(*	SETVER is a program which will set the Pascal compiler version number.
	When run, SETVER prompts for a DEC format version number.  It then
	creates file PASVER.REL, which has no effect other than to load the
	desired version number word at .JBVER (137B).  Loading PASVER with
	a compiler link will then produce a compiler with the specified version
	number.  *)

var ver_string: string [40];
    major, minor, edit, code: integer;
    version: packed record
	code: 0 .. 7b;
	major: 0 .. 777b;
	minor: 0 .. 77b;
	edit: 0 .. 777777b;
    end;
    old_ver: boolean;
    relfile: file of *;
    x: integer;

const
    octal = ['0'..'7'];

label 1, 2;

  function width (x: integer): integer;
  var xx: integer;
  begin
    xx := x;
    width := 0;
    repeat
      width := width + 1;
      xx := xx div 8;
    until xx = 0;
  end;
begin
  rewrite (tty);
  open (tty);

  reset (relfile, 'PASVER.REL', [seekok]);
  if iostatus <> io_ok then begin
    close (relfile);
    reset (relfile, '(PASDEV1)PASVER.REL', [seekok]);
  end;
  if iostatus = io_ok then begin
    readrn (relfile, 7, version);
    with version do begin
      write (tty, 'Old version = ');
      if major <> 0 then
	write (tty, major:width(major):o);
      if minor <> 0 then begin
	if minor <= 26 then
	  write (tty, chr (ord ('A') - 1 + minor))
	else if minor <= 52 then
	  write (tty, 'A', chr (ord ('A') - 1 + minor - 26))
	else
	  write (tty, 'B', chr (ord ('A') - 1 + minor - 52));
      end;
      if edit <> 0 then
	write (tty, '(', edit:width(edit):o, ')');
      if code <> 0 then
	write (tty, '-', code:1:o);
      writeln (tty);
    end;
    old_ver := true;
  end
  else
    old_ver := false;
  close (relfile);

2:
  write (tty, 'New version: ');
  break;
  readln (tty);
  read (tty, ver_string);
  if (ver_string = '') and old_ver then begin
    version.edit := version.edit + 1;
    version.code := 1;
  end
  else begin
    ver_string := uppercase (ver_string) || ' ';

    x := verify (ver_string, octal);
    if x = 1
      then major := 0
      else getstring (ver_string, major: x - 1: o);
    if major > 777b then goto 1;
    ver_string := substr (ver_string, x);

    x := verify (ver_string, ['A'..'Z']);
    case x of
      1:  minor := 0;
      2:  minor := ord (ver_string [1]) - ord ('A') + 1;
      3:  if substr (ver_string, 1, 2) > 'BK' then
	    goto 1
	  else
	    minor := (ord (ver_string [1]) - ord ('A') + 1) * 26 +
		     (ord (ver_string [2]) - ord ('A') + 1);
      others:  goto 1;
    end;
    ver_string := substr (ver_string, x);

    if ver_string [1] = '(' then begin
      ver_string := substr (ver_string, 2);
      x := verify (ver_string, octal);
      if x = 0 then goto 1;
      getstring (ver_string, edit: x - 1: o);
      if edit > 777777b then goto 1;
      if ver_string [x] <> ')' then goto 1;
      ver_string := substr (ver_string, x + 1);
    end
    else
      edit := 0;

    if ver_string [1] = '-' then begin
      if not (ver_string [2] in octal) then goto 1;
      code := ord (ver_string [2]) - ord ('0');
      ver_string := substr (ver_string, 3);
    end
    else
      code := 0;

    if ver_string <> ' ' then goto 1;

    version.major := major;
    version.minor := minor;
    version.edit := edit;
    version.code := code;
  end;

  rewrite (relfile, 'PASVER.REL');
  if iostatus <> io_ok then begin
    writeln (tty, '?Unable to open PASVER.REL');
    stop;
  end;

  write (relfile, 000006000001b); (* NAME record *)
  write (relfile, 0);
  write (relfile, 024036746164b);(* name = PASVER *)

  write (relfile, 000001000002b); (* CODE record *)
  write (relfile, 0);
  write (relfile, 137b); (* addr = absolute 137B *)
  write (relfile, version); (* data = version word *)

  write (relfile, 000005000002b); (* END record *)
  write (relfile, 200000000000b);
  write (relfile, 0); (* highseg break = relocatable 0 *)
  write (relfile, 140b); (* lowseg break = absolute 140B *)
  close (relfile);

  writeln (tty, 'PASVER.REL created');
  stop;

1:
  writeln (tty, '?Bad version number.  Syntax is:');
  writeln (tty, '  [<major>] [<minor>] ["("<edit>")"] ["-"<code>]');
  writeln (tty, '  0 <= major <= 777b');
  writeln (tty, '  "A" <= minor <= "BK"');
  writeln (tty, '  0 <= edit <= 777777b');
  writeln (tty, '  0 <= code <= 7');
  goto 2;

end.
  