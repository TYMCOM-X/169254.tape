program bldrw;

  (* Utility program for PASCAL compiler to create a reserved word table
     from a list of words, symbols, and operators:

	WORD; WORDSY; WORDOP;

     Table is assumed to be ordered by length of WORD.
									*)

$PAGE declarations

const
    rwmax = 100; (* max number of reserved words *)
    wordsize = 32; (* maximum word or symbol length *)

type
    rwrange = 1 .. rwmax;
    rwindex = 0 .. rwmax;
    wordtype = string [wordsize];
    wordrange = 1 .. wordsize;
    wordindex = 0 .. wordsize;

var
    frw: array [wordrange] of rwrange;
    rwc: rwindex;		(* number of RW's seen *)

    iname, oname: string [80];

    intab, outtab: text;

    word: wordtype;
    wordlist : array [rwrange] of 
      record
	name: wordtype;
	sy: wordtype;
	op: wordtype
      end;
    spchar: array [' '..'~'] of
      record
	sy: wordtype;
	op: wordtype
      end;

    lastlen: wordindex;
    i: rwindex;
    ch: char;

    maxrwlen, maxsylen: wordindex;
$PAGE error

procedure error ( msg: packed array [1..*] of char );
begin
  writeln (tty, '? ', msg);
  stop;
end;
$PAGE gettoken

function gettoken: wordtype;
 begin
  while (not eof (intab)) andif (intab^ = ' ') do get (intab);

  if eof (intab) then error ('Unexpected end-of-file in ' || filename (intab));

  gettoken := '';
  while (not eof (intab)) andif (intab^ <> ' ') do begin
    gettoken := gettoken || intab^;
    get (intab)
  end;
  gettoken := uppercase (gettoken);
 end;
$PAGE putfield

procedure putfield ( text: packed array [1..*] of char; ind, low, high: integer );
begin
  if ind = low then
    write (outtab, '     (  ');
  if ind = high then
    writeln (outtab, text: maxsylen: L, '  );')
  else begin
    write (outtab, text || ',': maxsylen+2: L);
    if ((ind - low + 1) mod (72 div (maxsylen + 2))) = 0 then begin
      writeln (outtab);
      write (outtab, chr(11b));
    end;
  end;
end;
$PAGE mainline

begin

  (*  Get the input and output file names.  *)

  open (tty); rewrite (tty);
  write (tty, 'Input table file:  '); break;
  readln (tty); read (tty, iname);
  write (tty, 'Output table file:  '); break;
  readln (tty); read (tty, oname);

  (*  Open the input file.  *)

  reset (intab, '.TAB ' || iname);
  if iostatus <> io_ok then error ('Unable to open ' || iname);

  (*  Read the reserved word table.  *)

  word := gettoken;
  if uppercase (word) <> '$RWORDS' then
    error ('"$RWORDS" expected, "' || word || '" read');

  rwc := 0;
  loop
    word := gettoken;
  exit if word[1] = '$';
    rwc := rwc + 1;
    i := rwc;
    while (i > 1) andif (length (word) < length (wordlist[i-1].name)) do i := i - 1;
    wordlist[i].name := word;
    wordlist[i].sy := lowercase (gettoken);
    wordlist[i].op := lowercase (gettoken);
  end;

  (*  Read the single-character symbol table.  *)

  if word <> '$SYMBOLS' then
    error ('"$SYMBOLS" expected, "' || word || '" read');

  for ch := ' ' to '~' do
    spchar[ch].sy := 'badsymbol';

  loop
    word := gettoken;
  exit if (word[1] = '$') and (word <> '$');
    if length (word) > 1 then error ('Bad symbol "' || word || '"');
    spchar[word[1]].sy := lowercase (gettoken);
  end;

  (*  Read the single-character operator table.  *)

  if word <> '$OPERATORS' then
    error ('"$OPERATORS" expected, "' || word || '" read');

  for ch := ' ' to '~' do
    spchar[ch].op := 'noop';

  loop
    word := gettoken;
  exit if (word[1] = '$') and (word <> '$');
    if length (word) > 1 then error ('Bad symbol "' || word || '"');
    spchar[word[1]].op := lowercase (gettoken);
  end;

  if word <> '$END' then
    error ('"$END expected, "' || word || '" read');

  (*  Open the output file.  *)

  rewrite (outtab, '.INC ' || oname);
  if iostatus <> io_ok then error ('Unable to open ' || oname);

  (*  Find the longest symbol length.  *)

  maxrwlen := length (wordlist[rwc].name);
  maxsylen := maxrwlen + 2;
  for i := 1 to rwc do
    maxsylen := max (maxsylen, length (wordlist[i].sy), length (wordlist[i].op));
  for ch := ' ' to '~' do
    maxsylen := max (maxsylen, length (spchar[ch].sy), length (spchar[ch].op));

  (*  Find the first reserved word of each length.  *)

  lastlen := 0;
  for i := 1 to rwc do begin
    while lastlen <> length (wordlist[i].name) do begin
      lastlen := lastlen + 1;
      frw[lastlen] := i;
    end;
  end;
  for i := lastlen + 1 to maxrwlen + 1 do
    frw[i] := rwc + 1;

  (*  Write the type declarations.  *)

  writeln (outtab, 'type');
  writeln (outtab, '  rwordtype = packed array [1..', maxrwlen:0, '] of char;');
  writeln (outtab, '  rwtype  = array [1..', rwc:0, '] of rwordtype;');
  writeln (outtab, '  rsytype = array [1..', rwc:0, '] of symbols;');
  writeln (outtab, '  roptype = array [1..', rwc:0, '] of operators;');
  writeln (outtab, '  frwtype = array [1..', maxrwlen+1:0, '] of 1..', rwc+1:0, ';');
  writeln (outtab, '  ssytype = array ['' ''..''~''] of symbols;');
  writeln (outtab, '  soptype = array ['' ''..''~''] of operators;');

  (*  Write the lexical tables.  *)

  writeln (outtab);
  writeln (outtab, 'const rw: rwtype :=');
  for i := 1 to rwc do
    putfield (''''||wordlist[i].name||'''', i, 1, rwc);

  writeln (outtab);
  writeln (outtab, 'const rsy: rsytype :=');
  for i := 1 to rwc do
    putfield (wordlist[i].sy, i, 1, rwc);

  writeln (outtab);
  writeln (outtab, 'const rop: roptype :=');
  for i := 1 to rwc do
    putfield (wordlist[i].op, i, 1, rwc);

  writeln (outtab);
  writeln (outtab, 'const frw: frwtype :=');
  for i := 1 to maxrwlen + 1 do begin
    putstring (word, frw[i]:0);
    putfield (word, i, 1, maxrwlen + 1);
  end;

  writeln (outtab);
  writeln (outtab, 'const ssy: ssytype :=');
  for ch := ' ' to '~' do
    putfield (spchar[ch].sy, ord(ch), ord(' '), ord('~'));

  writeln (outtab);
  writeln (outtab, 'const sop: soptype :=');
  for ch := ' ' to '~' do
    putfield (spchar[ch].op, ord(ch), ord(' '), ord('~'));

end.
 