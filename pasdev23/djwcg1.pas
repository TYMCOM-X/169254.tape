program djwcg;

type
  selections = (movem_by_words, movem_by_longs, 
		longword_loop, lea_postincr_simple_moves,
		two_longword_loop, rt_call);

var
  n: integer;
  sel: selections;

  list: array [selections] of
	  record
	    regs: integer;
	    size: integer;
	    cycles: integer;
	  end;
  size_list: array [1..ord (maximum (selections)) + 1] of
	       record
		 regs: integer;
		 size: integer;
		 cycles: integer;
		 code_sel: selections
	       end;
  last_size, size_ptr, size_ptr2, temp_size_ptr: 0..upperbound (size_list);

  labels: array [selections] of string :=
	('move mult. by words', 'move mult. by longwords',
	 'loop by longwords', 'lea''s and postincr. simple moves',
	 'loop by two longwords', 'runtime call');

begin
  rewrite (output, 'djwcg.txt');
  writeln (output, 'Assuming (An) descriptors:');
  writeln (output);

  for n := 3 to 500 do begin

    with list [movem_by_longs] do begin
      regs := n div 2;
      size := 12;
      if odd (n) then size := size + 6;
      cycles := 28 + 9*n;
      if odd (n) then cycles := cycles + 21;
    end;
    with list [movem_by_words] do begin
      regs := n;
      size := 12;
      cycles := 28 + 9*n;
    end;
    with list [longword_loop] do begin
      regs := 0;
      if odd (n) then
	size := 18
      else
	size := 16;
      if odd (n) then
	cycles := 37 + 16 * (n-1)
      else
	cycles := 24 + 16 * n
    end;
    with list [lea_postincr_simple_moves] do begin
      regs := 0;
      size := 8 + 2 * ((n+1) div 2);
      if odd (n) then
	cycles := 29 + 11 * (n-1)
      else
	cycles := 16 + 11 * n
    end;
    with list [two_longword_loop] do begin
      regs := 0;
      size := 18;
      if n mod 4 in [1,2] then
	size := size + 2
      else if n mod 4  = 3 then
	size := size + 4;
      cycles := 24 + 54 * (n div 4);
      if n mod 4 = 1 then
	cycles := cycles + 13
      else if n mod 4 = 2 then
	cycles := cycles + 22
      else if n mod 4 = 3 then
	cycles := cycles + 35
    end;
    with list [rt_call] do begin
      regs := 0;
      size := 18;
      cycles := 260 + 76 + round (12.25 * n)
    end;

    for sel := minimum (selections) to maximum  (selections) do
      with list [sel] do
        if sel in [movem_by_words, movem_by_longs, rt_call] then begin
	  size := size - 4;
	  cycles := cycles - 8
	end
	else if sel in [longword_loop, lea_postincr_simple_moves, two_longword_loop] then begin
	  size := size - 8;
	  cycles := cycles - 16
	end;

    last_size := 0;
    for sel := minimum (selections) to maximum (selections) do
      if list [sel].regs <= 13 then begin
	size_ptr := last_size;
	while (size_ptr > 0) andif (list [sel].size < size_list [size_ptr].size) do
	  size_ptr := size_ptr - 1;
	if (size_ptr = 0) orif
		( (list [sel].size > size_list [size_ptr].size) orif
		  ((list [sel].cycles > size_list [size_ptr].cycles) and
		   (list [sel].regs   < size_list [size_ptr].regs  ))   ) then begin
	  for temp_size_ptr := last_size downto size_ptr + 1 do
	    size_list [temp_size_ptr + 1] := size_list [temp_size_ptr];
	  with size_list [size_ptr + 1] do begin
	    regs := list [sel].regs;
	    size := list [sel].size;
	    cycles := list [sel].cycles;
	    code_sel := sel;
	    last_size := last_size + 1
	  end
	end
	else if list [sel].cycles <= size_list [size_ptr].cycles then begin
	  assert (size_list [size_ptr].size = list [sel].size);
	  size_list [size_ptr].regs := list [sel].regs;
	  size_list [size_ptr].cycles := list [sel].cycles;
	  size_list [size_ptr].code_sel := sel;
	  if (size_ptr > 1) andif
		((size_list [size_ptr - 1].size = size_list [size_ptr].size) and
		 (size_list [size_ptr - 1].cycles >= size_list [size_ptr].cycles)) then begin
	    for temp_size_ptr := size_ptr - 1 to last_size - 1 do
	      size_list [temp_size_ptr] := size_list [temp_size_ptr + 1];
	    last_size := last_size - 1
	  end
	end
	else
	  assert ((size_list [size_ptr].size = list [sel].size) and
		  (size_list [size_ptr].cycles < list [sel].cycles))
      end;

    size_ptr := 1;
    while size_ptr < last_size do
      if (size_list [size_ptr].regs > 0) orif
	  (2.0 * (size_list [size_ptr + 1].size - size_list [size_ptr].size) /
						  size_list [size_ptr].size
			  <=
	     (size_list [size_ptr].cycles - size_list [size_ptr + 1].cycles) /
						  size_list [size_ptr].cycles   ) orif
	( (size_list [size_ptr].cycles - size_list [size_ptr + 1].cycles) /
	(size_list [size_ptr + 1].size - size_list [size_ptr].size)   >= 150 ) then
	size_ptr := size_ptr + 1
      else begin
	for temp_size_ptr := size_ptr + 1 to last_size - 1 do
	  size_list [temp_size_ptr] := size_list [temp_size_ptr + 1];
	last_size := last_size - 1
      end;

    size_ptr := 1;
    while size_ptr < last_size do begin
      while (size_ptr <= last_size) andif (size_list [size_ptr].regs > 0) do
        size_ptr := size_ptr + 1;
      if size_ptr < last_size then begin
	size_ptr2 := size_ptr + 1;
	while (size_ptr2 <= last_size) andif (size_list [size_ptr2].regs > 0) do
	  size_ptr2 := size_ptr2 + 1;
	if (size_ptr2 <= last_size) then begin
	  if (2.0 * (size_list [size_ptr2].size - size_list [size_ptr].size) /
						  size_list [size_ptr].size
			  <=
	     (size_list [size_ptr].cycles - size_list [size_ptr2].cycles) /
						  size_list [size_ptr].cycles   ) orif
	( (size_list [size_ptr].cycles - size_list [size_ptr2].cycles) /
	(size_list [size_ptr2].size - size_list [size_ptr].size)   >= 150 ) then begin
	  for temp_size_ptr := size_ptr to last_size - 1 do
	    size_list [temp_size_ptr] := size_list [temp_size_ptr + 1];
	  last_size := last_size - 1
	end
	else
	  size_ptr := size_ptr + 1
	end
	else
	  size_ptr := last_size
      end
    end;

    writeln (output, n:5, ' words                             bytes of code    cycles');
    for size_ptr := 1 to last_size do
      with size_list [size_ptr] do begin
	write (output, '        ', labels [code_sel]:32, size: 10, cycles: 10);
	if regs > 0 then
	  writeln (output, '    but requires ', regs:2, ' registers!')
	else
	  writeln (output)
      end;
    writeln (output);
  end;

  close (output)
end.
 