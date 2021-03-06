(*$M-,C- *)
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

        external function look$up
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
        declaring and calling a look$upXXX,  where XXX is distinct for
        each scalar type.  The linker then links all these references
        to the common LOOKUP.  This is a  KLUDGE  to  be  fixed  when
        PASCAL allows.

     RESPONSIBLE: Software Tools

     CHANGES: NONE.

     ---------------------------------------------------------------- *)
$PAGE
$include rlb:cmdutl.typ
$PAGE
type
  scalar = 0..0;				(* to simulate scalar types *)

  name_string = packed array[1..10] of char;

  cmdlist =
    record
      name: name_string;
      abbrev: 1..10
    end;

  lookup_list = array [scalar] of cmdlist;


$PAGE
public function look$up
     (	line: cmdline; var lindex: cmdlineidx;
	var list: lookup_list; maxscalar: scalar;
	var nameidx: scalar			  ): boolean;

 var name: name_string;
 var i: scalar;
 var l: cmdlineidx;

 begin
  loop						(* skip blanks *)
    if lindex > length (line) then begin	(* blanks all the way to end *)
      look$up := false;				(* error return *)
      return
    end;
  exit if line[lindex] > ' ';			(* treat cntrl chars like blanks *)
    lindex := lindex + 1
  end;

  name := '';					(* get token, if not alphanumeric, then just one char *)
  l := 1;
  loop
    if l <= length (name) then
      name [l] := uppercase (line[lindex]);	(* know that there is at least one nonblank in line *)
    lindex := lindex + 1;
  exit if (lindex > length (line)) orif (not (uppercase (line [lindex]) in ['A'..'Z']));
    l := l + 1
  end;

  if l <= length (list[0].name) then begin	(* length must be less than longest possible *)
    for i := minimum (scalar) to maxscalar do	(* scan list *)
      if list[i].abbrev <= l then		(* must be longer than minimum *)
	if substr (list[i].name, 1, l) = name	(* must match to length of token *)
	  then begin				(* found it *)
	    nameidx := i;
	    look$up := true;
	    return				(* lindex left at character after token *)
	  end
  end;						(* test on longest length *)

  look$up := false;				(* search failed *)
  lindex := lindex - l				(* leave pointing to start of token  *)
 end.
   