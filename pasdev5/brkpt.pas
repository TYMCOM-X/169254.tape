$LENGTH 43
$OPTIONS nocheck,special,notrace

module brkpt$;

(*        Pascal Debugger Breakpoint Management Routines

  entry points include:

  info$stmt: given a statement block pointer, return source_id description.
  set$brkpt: set a breakpoint.
  clr$brkpt: clear a previously set breakpoint.
  clr$all$brkpt: clear all breakpoints, i.e., initialize breakpoint routines.
  find$block: find program block given module name.
  find$file: find file block given program block, file name/number.
  find$page: find page block given file block, page name/number.
  find$stmt: find stmt block given page block, line number. *)

$INCLUDE debtyp.inc
$INCLUDE debrun.inc
$PAGE search routines -- find program/file/page/stmt blocks

(*Routine to find a program block given module name.  Nil is returned if
  no program block exists, and error code gives details, with possible
  values (notdefined, notpascal, notdebug, debug (on non-nil return) ) *)

external function mod$lookup(name: alfa): linkentryptr;

public function find$block(name: alfa; var err: scopereturn): progblkptr;
  var lnkptr: linkentryptr;
begin
  lnkptr:= mod$lookup(name);
  find$block:= nil;
  if lnkptr=nil then err:= notdefined
  else with lnkptr^ do begin
    if (modname mod 1000000b) <> firstword^.right_r50 then
      err:= notpascal
    else if firstword^.prog_blk=nil then err:= notdebug
    else begin
      find$block:= firstword^.prog_blk;
      err:= debug
    end
  end
end (*find$block*);


(*Routine to find a file block given program block and file name or number.
  File block chain is searched for match or previous file block pointer
  zero, indicating end of list.*)

public function find$file(pb: progblkptr; name: alfa; number: integer): fileblkptr;
begin
  find$file:= pb^.last_file; (*pointer to last block in chain*)
  if name<>' ' then (*search for name*)
    while ord(find$file)<>0 do begin
    exit if uppercase (find$file^.file_name) = uppercase (name);
      find$file:= find$file^.previous_file
    end
  else (*search for number*)
    while ord(find$file)<>0 do begin
    exit if find$file^.file_number=number;
      find$file:= find$file^.previous_file
    end;
  if ord(find$file)=0 then find$file:= nil (*clean up compiler shortcoming*)
end (*find$file*);


(*Routine to find a page block given file block and page name or number.
  Page block chain is searched for match or previous page block pointer
  equal to file block pointer, indicating end of chain.*)

public function find$page(fb: fileblkptr; name: alfa; number: integer): pageblkptr;
begin
  find$page:= fb^.last_page;
  if name<>' ' then (*search for name*)
    while ord(find$page)<>ord(fb) do begin
    exit if uppercase (find$page^.subtitle) = uppercase (name);
      find$page:= find$page^.previous_page
    end
  else (*search for number*)
    while ord(find$page)<>ord(fb) do begin
    exit if find$page^.page_number=number;
      find$page:= find$page^.previous_page
    end;
  if ord(find$page)=ord(fb) then find$page:= nil (*flag not found*)
end (*find$page*);


(*Routine to find closest statement block given page block and number.
  Statement block chain is searched for closest statement whose line
  number is greater or equal to passed number, or previous statement block
  pointer equal to page block pointer, indicating end of chain.*)

public function find$stmt(pb: pageblkptr; number: integer): stmtblkptr;
begin
  find$stmt:= pb^.last_stmt;
  while (ord(find$stmt^.previous_stmt)<>ord(pb)) (*last stmt on chain*)
   andif (find$stmt^.previous_stmt^.line_number >= number) (*not closest*)
      do find$stmt:= find$stmt^.previous_stmt
end (*find$stmt*);
$PAGE info$stmt

(*Routine to return stmt, page, and file info of passed stmtblkptr.
  Line number, page number/name, and file number/name returned.
  Two horrible kludges described in code are used to locate page and
  file block respectively.*)

external function find$module(pb: progblkptr): alfa;

public procedure info$stmt(sb: stmtblkptr; var info: source_id);

  var cursb: stmtblkptr;
      pb, curpb: pageblkptr;
      fb: fileblkptr;

begin

  (* First find the page block.  The first word of a statement block contains
		previous statement ptr,,line number
     where the previous statement ptr of the first statement actually points
     to the page block.  The first word of a page block contains
		previous page ptr,,last statement ptr
     The search which follows assumes that the address of the last statement
     (which looks like the line number of a statement block) is greater than
     the first line number in any page.  If code is relocated in the high
     segment, this assumption is probably valid, as the address will be
     greater than 400000b.  Watch out if code is very low in the low segment.*)

  cursb:= sb;
  loop  (*assume good sb, else strange results...*)
    exit if cursb^.line_number < cursb^.previous_stmt^.line_number do
      pb:= ptr(ord(cursb^.previous_stmt)); (*coerce to page block ptr*)
    cursb:= cursb^.previous_stmt
  end;

  (* Now find the file block.  The first word of a file block contains
		previous file ptr,,last page block ptr
     The previous page ptr of the first page block in the file points to the
     file block.  The trick is: if there is really another page block before
     a given page block, the previous page block's statement ptr will contain
     an address less than that of the current page block.  If the previous
     block is really a file, then its "last statement ptr" will actually point
     to the last page block, hence the address will, of necessity, be greater
     than or equal to the address of the current page block. *)

  curpb:= pb;
  loop
    exit if ord(curpb^.previous_page^.last_stmt) >= ord(curpb) do
      fb:= ptr(ord(curpb^.previous_page));
    curpb:= curpb^.previous_page
  end;

  (* Now fetch and return the goodies *)

  with info do begin
    fname:= fb^.file_name; fnumber:= fb^.file_number;
    pname:= pb^.subtitle; pnumber:= pb^.page_number;
    lnumber:= sb^.line_number;
    mname:= find$module(fb^.mod_word_ptr^.prog_blk)
  end
end (*info$stmt*);
$PAGE set$brkpt -- set breakpoint

type brknumtype = 0..maxbrkpt;

public function set$brkpt(sb: stmtblkptr; var brknumber: brknumtype): boolean;
  var brkidx: brknumtype;
begin
  set$brkpt:= false;
  for brkidx:= minimum(brknumtype) to maximum(brknumtype) do
    exit if brk$table[brkidx]=nil do begin
      set$brkpt:= true;
      brknumber:= brkidx;
      brk$table[brkidx]:= sb
    end
end (*set$brkpt*);
$PAGE clr$brkpt/clr$all$brkpt -- clear breakpoint(s)

public function clr$brkpt(brknumber: brknumtype): boolean;
begin
  clr$brkpt:= brk$table[brknumber]<>nil; (*true if breakpoint previously set*)
  brk$table[brknumber]:= nil
end (*clr$brkpt*);


public procedure clr$all$brkpt;
  var brknumber: brknumtype;
begin
  for brknumber:= minimum(brknumtype) to maximum(brknumtype) do
    brk$table[brknumber]:= nil
end (*clr$all$brkpt*).
  