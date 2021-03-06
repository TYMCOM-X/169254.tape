program encode_binary;

$SYSTEM (pasdev27)getiof

var f: file of *;
    fn: file_name;
    i: integer;
    n: 0..511;
    buf: packed array [1..512, 1..6] of 0..63;
    line: packed array [1..48] of char;

  procedure outbuf (n: 0..512);
  var i: 1..512;
      j: 1..6;
      k: 0..48;
  begin
    k := 0;
    for i := 1 to n do begin
      for j := 1 to 6 do begin
	k := k + 1;
	line[k] := chr (buf[i,j] + ord (' '));
      end;
      if k = 48 then begin
	writeln (line);
	k := 0;
      end;
    end;
    if k <> 0 then
      writeln (substr (line, 1, k));
  end;

begin
  rewrite (tty);
  open (tty);
  while getiofiles (input, 'REL', output, 'ENC') do begin
    fn := filename (input);
    close (input);
    reset (f, fn);
    writeln (extent (f));
    for i := 1 to extent (f) div 512 do begin
      read (f, buf);
      outbuf (512);
    end;
    n := extent (f) mod 512;
    if n <> 0 then begin
      read (f, buf:n);
      outbuf (n);
    end;
  end;
end.
    