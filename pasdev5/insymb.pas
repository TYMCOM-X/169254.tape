$LENGTH 43
$OPTIONS special,notrace,nocheck

module insym$;

$INCLUDE debtyp.inc
$PAGE
const cr = chr(15b);	(* carriage return *)
external var 
   cur$ch:char;	    (* holds char from last call to next$char *)
public var
   cur$sy:symbol;
   cur$id:alfa;
   cur$val:constant;

external procedure next$char;

type numarray = packed array[1..30] of char;
external procedure cnvtor(s: numarray; var r: real);


public procedure in$symbol;

  type ssytype = array[' '..'~'] of symbol;
  const ssy: ssytype :=
     (  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  lparent,    rparent,    mulop,      plus,      
	comma,      minus,      period,     slash,      otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  colon,      semicolon,  relop,      relop,      
	relop,      otherssy,  atsign,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  lbrack,   
	otherssy,  rbrack,   arrow,      otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  otherssy,  
	otherssy,  otherssy,  otherssy,  otherssy,  otherssy   );

   var 
      charcnt:integer;
      base,i :integer;
      digit: packed array[1..20] of char;
      lit_delim: char;

   begin	    (* in$symbol *)
      charcnt := 0;
      while cur$ch = ' ' do next$char;
      case uppercase(cur$ch) of


      cr: begin
	    cur$sy := eofsy;
	  end;

     '.': begin
	    next$char;
	    if cur$ch = '.'
	      then begin
		cur$sy := elipsis;
		next$char;
	      end
	      else cur$sy := period;
	  end;

     ':': begin
	    next$char;
	    if cur$ch = '=' 
	       then begin
		  cur$sy := becomes;
		  next$char;
	       end else cur$sy := colon;
	   end; 

     'A'..'Z':
	   begin
	      cur$id := '';
	     while uppercase(cur$ch) in ['A'..'Z', '0'..'9', '_'] do begin
		 if charcnt < 10
		    then begin
		       (* convert lower to upper *)
		       charcnt := charcnt + 1;
		       cur$id[charcnt] := uppercase(cur$ch);
		    end;
		 next$char;
	      end;  (* while *)
	      cur$sy := ident;
	    end;

    '''','"':
	  begin
	     lit_delim:= cur$ch;   (* save delimiter *)
	     cur$val.sval := '';
	     loop
		loop
		   next$char;
		  exit if (cur$ch = lit_delim) or (cur$ch = cr);
		   charcnt := charcnt + 1;
		   cur$val.sval[charcnt] := cur$ch;
		end;	(* inner loop *)
		if cur$ch <> cr then next$char;
	       exit if cur$ch <> lit_delim;
		charcnt:= charcnt+1;
		cur$val.sval[charcnt] := lit_delim;
	     end;   (* outer loop *)
	     cur$val.slgth := charcnt;
	     cur$sy := stringconst;
	  end;

     '0'..'9':
	  begin
	     while cur$ch in ['0'..'9'] do begin
		charcnt := charcnt + 1;
		digit[charcnt]:= cur$ch;
		next$char;
	     end;   (* while *)
	     if (cur$ch <> '.') and (uppercase(cur$ch)<>'E')
		then begin
		   cur$val.intval := 0;
		   if (uppercase(cur$ch) = 'B') and
		    (search(substr(digit,1,charcnt),['8','9'])=0) then begin
		     base:= 8; next$char
		   end (*assume B is not part of number if digit 8 or 9 present*)
		   else base:= 10;
		   for i := 1 to charcnt do
		      cur$val.intval := (cur$val.intval * base) + ord(digit[i]) - ord('0');
		   cur$sy := intconst;
		end 	(* cur$ch <> '.' *)
	     else begin (*real constant*)
		if cur$ch='.' then begin (*eat fraction*)
		  charcnt:= charcnt+1;
		  digit[charcnt]:= '.';
		  next$char;
		  while cur$ch in ['0'..'9'] do begin
		    charcnt:= charcnt+1;
		    digit[charcnt]:= cur$ch;
		    next$char
		  end
		end;
		if uppercase(cur$ch)='E' then begin
		  charcnt:= charcnt+1;
		  digit[charcnt]:= 'E';
		  next$char;
		  if cur$ch in ['+','-'] then begin
		    charcnt:= charcnt+1;
		    digit[charcnt]:= cur$ch;
		    next$char
		  end;
		  while cur$ch in ['0'..'9'] do begin (*eat exponent*)
		    charcnt:= charcnt+1;
		    digit[charcnt]:= cur$ch;
		    next$char
		  end
		end;
		cnvtor(substr(digit,1,charcnt),cur$val.rval);
		cur$sy:= realconst
	     end
	  end;

  others: begin 
	     cur$sy := ssy[cur$ch];
	     next$char;
	  end

      end;	    (* case *)
   end.		    (* in$symbol *)
 