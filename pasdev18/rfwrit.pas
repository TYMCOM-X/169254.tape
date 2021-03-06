$TITLE rfwrite
$LENGTH 42
$PAGE includes
$include rfdata.inc
$PAGE wrline

public procedure wrline ( line: line_type );

 const
   BS = chr (010B);
   CR = chr (015B);

 var
   underline: packed array[1..max_line_length] of char;
   pos, lastunderline: line_index;
   idx: line_index;
   lcnt: line_count;

begin
 with line^ do begin
   if textlen > 0 then begin
     pos := page.left_margin + indentation;
     write (output, ' ': pos);
     case device of

       stdtty:
	 begin
	   for idx := 1 to textlen do
	     with text[idx] do begin
	       if ch = ' '
		 then write (output, ' ': width)
	       else if ch = '\'
		 then begin
		   if font = underlined
		     then write (output, '_')
		     else write (output, ' ');
		 end
	       else if font = underlined
		 then write (output, ch, BS, '_')
		 else write (output, ch);
	     end;
	   writeln (output);
	 end;

       crt:
	 begin
	   underline := '';
	   lastunderline := 0;
	   for idx := 1 to textlen do
	     with text[idx] do begin
	       if ch <> ' ' then begin
		 pos := pos + 1;
		 if ch = '\'
		   then write (output, ' ')
		   else write (output, ch);
		 if font = underlined then begin
		   underline [pos] := '_';
		   lastunderline := pos;
		 end;
	       end
	       else begin
		 write (output, ' ': width);
		 pos := pos + width;
	       end;
	     end;
	   if lastunderline > 0
	     then writeln (output, CR, substr (underline, 1, lastunderline))
	     else writeln (output);
	 end

     end (* case *) ;
   end (* if *) ;
   for lcnt := 1 to spacing do writeln (output);
 end (* with *) ;
end.
   