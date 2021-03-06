program count;

var
  s: string;
  long, short, funny, ix, i: integer;
  instr: array [1..16] of string[4] :=
    ('BRA.', 'BSR.', 'BHI.', 'BLS.', 'BCC.', 'BCS.', 'BNE.', 'BEQ.', 'BVC.', 'BVS.', 
     'BPL.', 'BMI.', 'BGE.', 'BLT.', 'BGT.', 'BLE.');

begin
  long := 0;
  short := 0;
  reset (input, 'lexgen.lst');
  while not eof(input) do begin
    readln (input, s);
    for i := 1 to 16 do begin
      ix := index (s, instr[i]);
      if ix > 0 then
	if s[ix+4] = 'L' then
	  long := long + 1
	else if s[ix+4] = 'S' then
	  short := short + 1
	else
	  funny := funny + 1;
    end
  end;

  rewrite (ttyoutput);
  writeln (ttyoutput, 'short = ', short);
  writeln (ttyoutput, 'long =  ', long);
  writeln (ttyoutput, 'funny = ', funny);
end.
   