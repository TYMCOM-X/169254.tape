$LENGTH 44
(*$M-,D-,&+*)
 
const	SIZEBLOCK = 128;
	BITSPERWORD = 36;
	BITSPERBLOCK = 4608;
 
$INCLUDE USETYP.INC[52250,247]
 
$INCLUDE MODTYP.INC[52250,247]
 
$INCLUDE PASIOR.INC
 

type	FILENAME = string[30];

external procedure GETDIRECT(var PTR, INDEX, NUM : IOFILEPTR;  DBID : IOFILEID);  
 
type	MONTH = packed array[1..5] of char;
 
var	MON : array[1..12] of MONTH := (
	'-Jan-', '-Feb-', '-Mar-', '-Apr-', '-May-', '-Jun-',
	'-Jul-', '-Aug-', '-Sep-', '-Oct-', '-Nov-', '-Dec-'
	);

	ERRCO : IOERRCODE;
	ID : IOFILEID;
	INDEX, YEAR : INTEGER;
	PAGE : IOFILEPTR;
	BSIZE : IOBLOCKSIZE := SIZEBLOCK;
	BLOCK : IOBLOCK;
 

 
 
public procedure PRVERS(MODNUM : INTEGER;  DBNAME : FILENAME);
 
label	1,2;
 
begin
PASOPN(ERRCO, ID, IOIN, IONODEL, DBNAME);
if ERRCO = IOERR then goto 1;
GETDIRECT(PAGE, INDEX, MODNUM, ID);
if INDEX = 0 then
     writeln(tty,' MODULE NOT FOUND')
else begin
     RDRAND(ERRCO, ID, BLOCK, BSIZE, PAGE);
     if ERRCO = IOERR then goto 1;
     PAGE := BLOCK.WORDS[INDEX] * BSIZE;
     if PAGE = 0 then 
	  writeln(tty,' MODULE NOT FOUND')
     else while PAGE <> 0 do
	  begin
	  RDRAND(ERRCO, ID, BLOCK, BSIZE, PAGE);
	  with BLOCK, FORMAT, DATEWD do
	       begin
	       write(tty,'VERSION  ', VERNUM, '  UPDATED  ');
	       write(tty, FOO[DAY]:2, MON[FOO[MO]], 64+FOO[YR]:2, '  AT  ');
	       writeln(tty,FOO[HR]:2,':', FOO[MIN]:2, ':', FOO[SEC]:2);
	       end;
	  PAGE := BLOCK.FORMAT.POINTER * BSIZE
	  end
     end;
goto 2;
1:  writeln(tty,' File error in PRINT');
2:  PASCLS(ERRCO, ID, IONODEL)
end.
    