program jan;
  
type
  rec_of_str = array [1..8] of string[60];
  
procedure next_member (var lines: rec_of_str; var num_lines: integer);
  
  var
    temp_str: string[60];

  begin
    num_lines := 0;
    if eof (input) then return;
    repeat
      readln (input, temp_str)
    until (temp_str <> '') or eof (input);
    if temp_str = '' then return;
  
    repeat
      num_lines := num_lines + 1;
      lines [num_lines] := temp_str;
     exit if eof (input);
      readln (input, temp_str)
    until temp_str = '';
    while (substr (lines [num_lines], 1, 3) = 'hm:') or
	  (substr (lines [num_lines], 1, 3) = 'wk:') do
      num_lines := num_lines - 1;
  end;

var
  lines: rec_of_str;
  lines_count, lines_index: integer;

begin
  reset (input, 'jan.txt');
  rewrite (output, 'jan.mai');

  repeat
    next_member (lines, lines_count);
    for lines_index := 1 to lines_count do
      writeln (output, lines [lines_index]);
    for lines_index := lines_count + 1 to 6 do
      writeln (output);
  until lines_count = 0;
  
  close (output)
end.
 