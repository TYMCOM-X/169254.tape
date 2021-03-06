$LENGTH 44
(*$M-,D-*)
(*   +--------------------------------------------------------------+
     I                                                              I
     I                         B U I L D                            I
     I                         - - - - -                            I
     I                                                              I
     +--------------------------------------------------------------+

     MDSI, COMPANY CONFIDENTIAL

     STARTED:  9-Mar-78

     PURPOSE: To implement the BUILD command for ODMS.

     USAGE:
        procedure MODBLD (MODPTR, MAINTV: SYMPTR);
        procedure RESBLD (MAINTV, AREAS, MODULES: SYMPTR;
                          STATSIZE: INTEGER;
                          DBNAME: string[30] );
        procedure BLDINIT (SYMFILE: string[30]);

     INPUT: 

        MODPTR     A pointer to the symbol table record of the module
                   to be built.

        MAINTV     A  pointer to the symbol table record of the first
                   symbol in the resident transfer vector.

        AREAS      A pointer to the symbol table record of the  first
                   overlay area.

        MODULES    A  pointer to the symbol table record of the first
                   module.

        STATSIZE   The size of MODULES' static storage allocation.

        DBNAME     A DEC-10 file descriptor for the default  database
                   file to be used by the overlaid program.

        SYMFILE    A  DEC-10  file  descriptor  for the output of the
                   BUILD.

     EFFECTS: The  module  will  write  out  a  file  describing  the
        transfer vector(s) suitable for direct input to MACRO-10

     NOTES: The  module  SYMWRT  contains  the  various  routines for
        laying out the assembly  code.  In  the  future,  these  will
        probably be changed to directly output a .REL file.

     RESPONSIBLE: Jerry Rosen

     CHANGES: NONE.

     ---------------------------------------------------------------- *)
 
$INCLUDE USETYP.INC[52250,247]
 
type	FILENAME = string[30];


external procedure SETUPCODE;  
 
external procedure RELOC(WHERE : INTEGER);  
 
external procedure CONSTANT(LEFT, RIGHT : INTEGER);  
 
external procedure JRST(NAME : SYMBOLIC);  
 
external procedure DEFINE(NAME : SYMBOLIC;  LOCATION : INTEGER);  
 
external procedure PUSHJ(NAME : SYMBOLIC);  
 
external procedure CALLIT(NAME : SYMBOLIC);  
 
external procedure FNAME(NAME : FILENAME);  
 
external procedure BLOCK(HOWBIG : INTEGER);  

external procedure UUORES(NAME: SYMBOLIC);
 
 
public procedure MODBLD(MODPTR, MAINTV : SYMPTR);
var	NEXTSYM : SYMPTR;  LASTNUM : INTEGER;
 
begin
SETUPCODE;
RELOC(400000B);
CONSTANT(0,MODPTR^.MODNUMBER);
NEXTSYM := MODPTR^.FIRSTSYM;
while NEXTSYM <> nil do
     begin
     JRST(NEXTSYM^.SYMNAME);
     NEXTSYM := NEXTSYM^.NEXTMODSYM
     end;
NEXTSYM := MAINTV;
while NEXTSYM <> nil do
  begin
    if NEXTSYM^.MYMODULE <> MODPTR then
      DEFINE (NEXTSYM^.SYMNAME, NEXTSYM^.TVLOC);
    NEXTSYM := NEXTSYM^.NEXTMAINSYM
  end
end;
 
 
public procedure RESBLD(MAINTV, AREAS, MODULES : SYMPTR;
		 STATSIZE : INTEGER;  DBNAME : SYMBOLIC);
var	NEXTSYM, MODTMP : SYMPTR;
	LASTADDR, MODORG : INTEGER;
 
begin
  SETUPCODE;
  RELOC (400000B);
  CONSTANT(0,0);  CONSTANT(0,0);
  DEFINE ( 'OVBASE', 400002B );
  NEXTSYM := MAINTV;
  LASTADDR := 400012B;
  (*  notice that LASTADDR, and addresses in the TVLOC field of SYMBOL
      records, are LOADED ADDRESSES, and will differ by 10B (the size
      of the Vestigle Job Data Area) from the addresses given to the
      MACRO assembler   *)
  
  while NEXTSYM <> nil do
    with NEXTSYM^ do

      begin
	while LASTADDR < TVLOC do
	  begin
	    PUSHJ ('OVLDEL');
	    LASTADDR := LASTADDR + 1
	  end;

	if MYMODULE = nil then
	  begin   (* resident symbol *)
	    if index(SYMNAME, '.') = 0 then
	    UUORES(SYMNAME)
	    else JRST(SYMNAME);		(* TO SPEED PASCAL RESIDENT CALLS *)
	    LASTADDR := LASTADDR + 1
	  end

	else
	  begin   (* overlaid symbol *)
	    CALLIT (SYMNAME);
	    PUSHJ ('OVLTV.');
	    MODTMP := MYMODULE^.FIRSTSYM;
	    MODORG := MYMODULE^.MYAREA^.ORIGIN + 11B;
		(* Remembering that we have to skip over that stupid
		   VJDA at the start of the module, and also that
		   word <0,,mod#> at the head of the .SYM file *)

	    while MODTMP <> NEXTSYM do
	      begin
		MODORG := MODORG + 1;
		MODTMP := MODTMP^.NEXTMODSYM
	      end;

	    CONSTANT (MYMODULE^.MODNUMBER, MODORG);
	    LASTADDR := LASTADDR + 2
	  end;

	NEXTSYM := NEXTMAINSYM
      end;


  CALLIT ('AREA..');
  NEXTSYM := AREAS;

  while NEXTSYM^.NEXTAREA <> nil do
    begin
      CONSTANT (0,NEXTSYM^.ORIGIN);
      NEXTSYM := NEXTSYM^.NEXTAREA
    end;

  CONSTANT (-1, NEXTSYM^.ORIGIN);
  RELOC (0);
  CALLIT ('MODULE');
  CONSTANT (400000B, 0);
  CONSTANT (0,0);  CONSTANT (0,0);
  NEXTSYM := MODULES;

  while NEXTSYM <> nil do
    with NEXTSYM^ do
      begin
	CONSTANT (0, MYAREA^.ORIGIN);
	CONSTANT (0,0);  CONSTANT (0,0);
	NEXTSYM := NEXTMOD
      end;

  CALLIT ('FILE');
  BLOCK (48);
  CONSTANT (0, 777777B);
  FNAME (DBNAME)
end.
  