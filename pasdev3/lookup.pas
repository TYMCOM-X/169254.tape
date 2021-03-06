(*   +--------------------------------------------------------------+
     I                                                              I
     I                        L O O K U P                           I
     I                        - - - - - -                           I
     I                                                              I
     +--------------------------------------------------------------+

     MDSI, COMPANY CONFIDENTIAL

     STARTED:  1-Aug-77

     PURPOSE: extracts the next token  from  the  command  line,  and
        looks  the  token  up in a caller supplied list of command or
        option names.  Returns the index of the name,  if found.

     USAGE:
        
        type
          cmdlist =
            record
              name: packed array[1..10] of char;  (* full name *)
              abbrev: 1..10			  (* min length *)
            end;
          caller_list: array [<scalar type>] of cmdlist;

        external function lookup
            (line: cmdline; var lindex: cmdlineidx;
             var list: caller_list; maxscalar: <scalar type>;
             var nameidx: <scalar type>	 ): boolean;

     INPUT: 

        line       is the line from which the command name  token  is
                   to be extracted.

        lindex     is  the  parsing  cursor.  LOOKUP  scans from this
                   position for the token.

        list       is the command list to be searched.

        maxscalar  is the upper bound of the list  array.  The  value
                   "maximum (<scalar type>)" should be passed.

     OUTPUT:

        lindex     If  the  token is found in the command list,  then
                   LINDEX is set to the character following  the  end
                   of the token;  if the token is not found then this
                   is set to the start of the token.  If there is  no
                   token,  this  is left pointing pass the end of the
                   line.

	nameidx	   is  the  scalar associated with the token.  Set if
		   the name is actually found.

        <return value>   is true if a token is found and  appears  in
                   the command list;  false otherwise.

     ALGORITHM: A  match  for  the token in the command list is found
        if: (1) the token is not longer than the  command  name,  (2)
        the token is not shorter than the minimum abbreviation of the
        name,  and (3) the token and name match to the length of  the
        token (upper and lower case are equivalent).

     NOTES: To  use  this  routine with command lists associated with
        different scalar types,  it is necessary  to  declare  LOOKUP
        separately  for each scalar type to be used.  This is done by
        declaring and calling a lookupXXX,  where XXX is distinct for
        each scalar type.  The linker then links all these references
        to the common LOOKUP.  This is a  KLUDGE  to  be  fixed  when
        PASCAL allows.

     RESPONSIBLE: Software Tools

     CHANGES: NONE.

     ---------------------------------------------------------------- *)
$PAGE
module lookup
  options special;
$SYSTEM cmdutl.typ[31024,320156]
$PAGE
type
  scalar = (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,
	    s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,
	    s31,s32,s33,s34,s35,s36,s37,s38,s39,s40,s41,s42,s43,s44,
	    s45,s46,s47,s48,s49,s50,s51,s52,s53,s54,s55,s56,s57,s58,
  	    s59,s60,s61,s62,s63,s64,s65,s66,s67,s68,s69,s70,s71,s72,
	    s73,s74,s75,s76,s77,s78,s79,s80,s81,s82,s83,s84,s85,s86,
	    s87,s88,s89,s90,s91,s92,s93,s94,s95,s96,s97,s98,s99,s100,
	    s101,s102,s103,s104,s105,s106,s107,s108,s109,s110,s111,s112,
	    s113,s114,s115,s116,s117,s118,s119,s120,s121,s122,s123,s124,
	    s125,s126,s127,s128,s129,s130,s131,s132,s133,s134,s135,s136,
	    s137);

  name_string = packed array[1..10] of char;

  cmdlist =
    record
      name: name_string;
      abbrev: 1..10
    end;

  lookup_list = array [scalar] of cmdlist;


$PAGE
public function lookup
     (	line: cmdline; var lindex: cmdlineidx;
	var list: lookup_list; maxscalar: scalar;
	var nameidx: scalar			  ): boolean;

 var name: name_string;
 var i: scalar;
 var l: cmdlineidx;

 begin
  while (lindex <= length (line)) andif (line[lindex] <= ' ') do
    lindex := lindex + 1; (* treat control characters like blanks *)

  if lindex > length (line) then begin (* no non-blanks in line *)
    lookup := false;
    return;
  end;

  name := '';					(* get token, if not alphanumeric, then just one char *)
  l := 0;
  repeat
    l := l + 1;
    if l <= length (name) then
      name[l] := uppercase (line[lindex]); (* there is at least one non-blank *)
    lindex := lindex + 1;
  until (lindex > length (line)) orif not (uppercase (line[lindex]) in ['A'..'Z']);

  if l <= length (list[s0].name) then begin	(* length must be less than longest possible *)
    for i := minimum (scalar) to maxscalar do	(* scan list *)
      if list[i].abbrev <= l then		(* must be longer than minimum *)
	if substr (list[i].name, 1, l) = name	(* must match to length of token *)
	  then begin				(* found it *)
	    nameidx := i;
	    lookup := true;
	    return				(* lindex left at character after token *)
	  end
  end;						(* test on longest length *)

  lookup := false;				(* search failed *)
  lindex := lindex - l				(* leave pointing to start of token  *)
 end.
    