program iching;

const
  tab = chr (11b);
  crlf = chr (15b) || chr (12b);
  line: array[0..1] of string[20] := (
	'--------    --------',
	'--------------------');

public const

$include iching.inc

external var
  table: array[0..63] of ^ string;

var
  i, j: integer;
  convert: record
    case boolean of
      true:  (bits: packed array[0..35] of 0..1);
      false: (int: integer)
  end;

begin
  rewrite (tty); open (tty);
  loop
    with convert do begin
      int := round (63*random (time*runtime/1000));
      writeln (tty);
      writeln (tty);
      for i := 30 to 35 do
	writeln (tty,tab,line[bits[i]]);
      writeln (tty);
      writeln (tty);
      writeln (tty,table[int]^);
      writeln (tty);
      break;
    end;
    readln (tty);
  end;
end.
  