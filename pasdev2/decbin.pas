program encode_binary;

$SYSTEM (pasdev27)getiof

var f: file of *;
    fn: file_name;
    extent_f: integer;
    i: integer;
    n: 0..511;
    buf: packed array [1..512, 1..6] of 0..63;
    line: packed array [1..48] of char;

  procedure inbuf (n: 0..512);
  var i: 1..512;
      j: 1..6;
      k: 0..48;
  begin
    k := 48;
    for i := 1 to n do begin
      if k = 48 then begin
	readln (line);
	k := 0;
      end;
      for j := 1 to 6 do begin
	k := k + 1;
	buf[i,j] := ord (line[k]) - ord (' ');
      end;
    end;
  end;

begin
  rewrite (tty);
  open (tty);
  while getiofiles (input, 'ENC', output, 'REL') do begin
    fn := filename (output);
    close (output);
    rewrite (f, fn);
    readln (extent_f);
    for i := 1 to extent_f div 512 do begin
      inbuf (512);
      write (f, buf);
    end;
    n := extent_f mod 512;
    if n <> 0 then begin
      inbuf (n);
      write (f, buf:n);
    end;
  end;
end.
  