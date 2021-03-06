program djwcg;

type
  selections = (word_clr_loop,
		longword_clr_loop,
		lea_postincr_simple_clears, single_clears,
		lea_postincr_simple_move_zeroed,
		rt_call_four_movel);

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
	('clear loop by words',
	 'clear loop by longwords',
	'lea and postincr. simple clears', 'simple clears',
	 'lea and postincr. simple move 0',
	 'runtime call with four move.l');

begin
  rewrite (output, 'djwcg.txt');
$IF INDIRECT    writeln (output, 'Assuming (An) desriptor:');
$IFNOT INDIRECT writeln (output, 'Assuming d(An) descriptor:');
  writeln (output);

  for n := 1 to 500 do begin

    with list [word_clr_loop] do begin
      regs := 0;
      size := 12;
      cycles := 16 + 23 * n
    end;
    with list [longword_clr_loop] do begin
      regs := 0;
      size := 12 + 2 * (n mod 2);
      cycles := 16 + 16 * n - 3 * (n mod 2)
    end;
    with list [single_clears] do begin
      regs := 0;
      size := 4 * ((n + 1) div 2);
      cycles := 13 * n + 4 * (n mod 2)
    end;
    with list [lea_postincr_simple_clears] do begin
      regs := 0;
      size := 4 + 2 * ((n+1) div 2);
      cycles := 8 + 11 * n + 2 * (n mod 2)
    end;
    with list [lea_postincr_simple_move_zeroed] do begin
      regs := 0;
      size := 6 + 2 * ((n + 1) div 2);
      cycles := 12 + 7 * n + 2 * (n mod 2)
    end;
    with list [rt_call_four_movel] do begin
      regs := 0;
      size := 14;
      cycles := 308 + round (8.25 * n)
    end;

$IF INDIRECT
    for sel := minimum (selections) to maximum  (selections) do
      with list [sel] do
        if sel in [single_clears,
		   rt_call_four_movel] then begin
	  size := size - 2;
	  cycles := cycles - 4
	end
        else begin
	  size := size - 4;
	  cycles := cycles - 8
	end;
$ENDIF
  
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
   