$LENGTH 42
$TITLE BANNER -- PROGRAM TO PRINT TITLE PAGES
program banner;

(*****   CONSTANT DEFINITIONS   *****)

const
    page_width = 100;
    page_height = 44;
    char_width = 5;
    char_height = 7;
    ch_desc_size = 35;				(* = CHAR_WIDTH * CHAR_HEIGHT *)
    hspace = 3;					(* HORIZONTAL SPACE BETWEEN CHARACTERS *)
    vspace = 2;					(* VERTICAL SPACE BETWEEN CHARACTERS *)
    max_chars = 12;				(* MAX CHARACTERS / ROW *)
    max_rows = 5;				(* MAX ROWS / PAGE *)


(*****   TYPE DECLARATIONS   *****)

type
    prt_chars = ' ' .. '_';			(* ASCII COLUMNS 2 - 5 *)
    row = string [max_chars];
    ch_desc = packed array [1..ch_desc_size] of char;


(*****   VARIABLE DECLARATIONS   *****)

var
    num_rows: 0 .. max_rows;
    rows: array [1..max_rows] of row;
    file_id: string [256];
    vfill: 0 .. page_height;
    vsp: 0 .. page_height;
    row_index: 1 .. max_rows;
    stop_flag: boolean;
$PAGE CHARACTER REPRESENTATIONS

type rep_array = array [prt_chars] of ch_desc;

const rep: rep_array =
     (  '                                   ',	(*   *) 
	' $$   $$   $$   $$        $$   $$  ',	(* ! *) 
	' $ $  $ $                          ',	(* " *) 
	'      $ $ $$$$$ $ $ $$$$$ $ $      ',	(* # *) 
	'  $   $$$ $ $   $$$   $ $ $$$   $  ',	(* $ *) 
	'$$   $$  $   $   $   $   $  $$   $$',	(* PERCENT SIGN *) 
	' $   $ $  $ $   $  $$ $ $$  $  $$ $',	(* & *) 
	'   $   $                           ',	(* ' *) 
	'    $   $   $    $    $     $     $',	(* ( *) 
	'$     $     $    $    $   $   $    ',	(* ) *) 
	'     $ $ $ $$$ $$$$$ $$$ $ $ $     ',	(* * *) 
	'       $    $  $$$$$  $    $       ',	(* + *) 
	'                $$   $$    $    $  ',	(* , *) 
	'               $$$$$               ',	(* - *) 
	'                          $$   $$  ',	(* . *) 
	'         $   $   $   $   $         ',	(* / *) 
	'  $$  $  $ $  $ $  $ $  $ $  $  $$ ',	(* 0 *) 
	'  $   $$    $    $    $    $   $$$ ',	(* 1 *) 
	' $$$ $   $    $ $$$ $    $    $$$$$',	(* 2 *) 
	' $$$ $   $    $  $$     $$   $ $$$ ',	(* 3 *) 
	'   $   $$  $ $ $  $ $$$$$   $    $ ',	(* 4 *) 
	'$$$$$$    $$$$     $    $$   $ $$$ ',	(* 5 *) 
	'  $$  $   $    $ $$ $$  $$   $ $$$ ',	(* 6 *) 
	'$$$$$    $   $   $   $   $    $    ',	(* 7 *) 
	' $$$ $   $$   $ $$$ $   $$   $ $$$ ',	(* 8 *) 
	' $$$ $   $$  $$ $$ $    $   $  $$  ',	(* 9 *) 
	'      $$   $$        $$   $$       ',	(* : *) 
	' $$   $$        $$   $$    $   $   ',	(* ; *) 
	'    $   $   $   $     $     $     $',	(* < *) 
	'          $$$$$     $$$$$          ',	(* = *) 
	'$     $     $     $   $   $   $    ',	(* > *) 
	' $$$ $   $   $   $    $         $  ',	(* ? *) 
	' $$$ $   $    $ $$ $$ $ $$ $$  $$  ',	(* @ *) 
	' $$$ $   $$   $$$$$$$   $$   $$   $',	(* A *) 
	'$$$$  $  $ $  $ $$$  $  $ $  $$$$$ ',	(* B *) 
	' $$$ $   $$    $    $    $   $ $$$ ',	(* C *) 
	'$$$$  $  $ $  $ $  $ $  $ $  $$$$$ ',	(* D *) 
	'$$$$$$    $    $$$  $    $    $$$$$',	(* E *) 
	'$$$$$$    $    $$$  $    $    $    ',	(* F *) 
	' $$$$$    $    $ $$$$   $$   $ $$$ ',	(* G *) 
	'$   $$   $$   $$$$$$$   $$   $$   $',	(* H *) 
	' $$$   $    $    $    $    $   $$$ ',	(* I *) 
	'    $    $    $    $    $$   $ $$$ ',	(* J *) 
	'$   $$  $ $ $  $$   $ $  $  $ $   $',	(* K *) 
	'$    $    $    $    $    $    $$$$$',	(* L *) 
	'$   $$$ $$$ $ $$ $ $$   $$   $$   $',	(* M *) 
	'$   $$$  $$ $ $$  $$$   $$   $$   $',	(* N *) 
	' $$$ $   $$   $$   $$   $$   $ $$$ ',	(* O *) 
	'$$$$ $   $$   $$$$$ $    $    $    ',	(* P *) 
	' $$$ $   $$   $$   $$ $ $$  $  $$ $',	(* Q *) 
	'$$$$ $   $$   $$$$$ $ $  $  $ $   $',	(* R *) 
	' $$$ $   $$     $$$     $$   $ $$$ ',	(* S *) 
	'$$$$$  $    $    $    $    $    $  ',	(* T *) 
	'$   $$   $$   $$   $$   $$   $ $$$ ',	(* U *) 
	'$   $$   $$   $ $ $  $ $   $    $  ',	(* V *) 
	'$   $$   $$   $$ $ $$ $ $$ $ $ $ $ ',	(* W *) 
	'$   $$   $ $ $   $   $ $ $   $$   $',	(* X *) 
	'$   $$   $ $ $   $    $    $    $  ',	(* Y *) 
	'$$$$$    $   $   $   $   $    $$$$$',	(* Z *) 
	'  $$$  $    $    $    $    $    $$$',	(* [ *) 
	'     $     $     $     $     $     ',	(* BACK SLASH *) 
	'$$$    $    $    $    $    $  $$$  ',	(* ] *) 
	'  $   $ $ $   $                    ',	(* ^ *) 
	'                              $$$$$'  );   (* _ *) 
$PAGE READ A COMMAND LINE
procedure read_a_command_line;

var
    line: string [255];
    len: 0 .. 256;
    ind: 0..256;

begin
    loop
	line := '';
	write (tty,'*');
	break;
	readln (tty);
	while not eoln(tty) do begin
	    line := line || uppercase(tty^);
	    get (tty);
	end;
	if line = '' then begin
	    stop_flag := true;
	    return;
	end;
	ind := search(line,['/'],length(line));
    exit if ind <> length(line);
	writeln (tty,'**  NO BANNER TEXT  **');
    end;

    stop_flag := false;
    file_id := substr(line,1,ind-1);
    ind := ind + 1;
    len := length(line) + 1;
    num_rows := 0;
    while (ind <> len) and (num_rows <> max_rows) do begin
	num_rows := num_rows + 1;
	rows[num_rows] := '';
	loop
	    while (ind <> len) andif (line[ind] <> '/') do begin
		if line[ind] in [' '..'_'] then
		    rows[num_rows] := rows[num_rows] || line[ind];
		ind := ind + 1;
	    end;
	    if ind <> len then ind := ind + 1;
	exit if (ind = len) orif (line[ind] <> '/');
	    rows[num_rows] := rows[num_rows] || '/';
	    ind := ind + 1;
	end;
    end;
end;
$PAGE PRINT_ROW -- PUT OUT ONE ROW OF CHARACTERS
procedure print_row (r:row);

var
    ind: 0 .. ch_desc_size;
    hfill: 1 .. page_width;
    len: 0 .. max_chars;
    i: 1 .. max_chars;

begin
    len := length(r);
    if len = 0 then return;
    hfill := (page_width + hspace - (char_width+hspace)*len) div 2;
    ind := 0;
    while ind <> ch_desc_size do begin
	write (output,' ':hfill);
	for i := 1 to len do begin
	    write (output,substr(rep[r[i]],ind+1,char_width));
	    if i <> len then write (output,' ':hspace);
	end;
	writeln (output);
	ind := ind + char_width;
    end;
end;
$PAGE MAIN PROGRAM
begin
    open (tty);
    rewrite (tty);
    loop
	read_a_command_line;
    exit if stop_flag;
	rewrite (output,'DSK:BANNER.LPT[,] '||file_id);
	if iostatus <> io_ok then
	    writeln (tty,'**  BAD FILE  **')
	else begin
	    vfill :=
		(page_height + vspace - (char_height+vspace)*num_rows) div 2;
	    for vsp := 1 to vfill do
		writeln (output);
	    for row_index := 1 to num_rows do begin
		print_row (rows[row_index]);
		if row_index <> num_rows then
		    for vsp := 1 to vspace do
			writeln (output);
	    end;
	end;
    end;
end .
   