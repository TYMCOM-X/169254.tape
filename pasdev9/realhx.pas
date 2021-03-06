module realhex;

$IF double
type real_type = minimum (real)..maximum (real) prec 16;
const upb = 8;
      width = 22;
$ENDIF

$IFNOT double
type real_type = real;
const upb = 4;
      width = 14;
$ENDIF

public function hexreal (rval: real_type): string options special(word);

const
  sign: array[boolean] of string[3] := ('+','-');

var
  s: string;
  i, j, k, exp: integer;
  cvt: packed record
    case boolean of
      true:  (r: real_type);
      false: (
$IF vax  f: packed array[1..upb] of 0..#Hff
$IF m68  f: packed array[1..upb] of 0..#Hff
$IF p10		f: packed array[1..4] of 0..#O777777
	)
    end;

begin
  with cvt do begin
    r := abs (rval);
    putstring (hexreal,rval
$IF eformat  :width:e
    ,' (',sign[rval<0.0],' ');
$IF vax  exp := f[2] * 2 + f[1] div #H80;
$IF m68  exp := f[upb];
$IF p10  exp := f[1] div #O1000;
    putstring (s,exp:2:h,' ');
    hexreal := hexreal || s;

$IF m68
    for i := 1 to upb - 1 do begin
      putstring (s,f[i]:2:h);
      hexreal := hexreal || s;
    end;
$ENDIF

$IF vax
    if rval = 0.0
      then j := 0
      else j := ((#H80 + f[1] mod #H80) * #H100 + f[4]) * #H100 + f[3];
    putstring (s,j:6:H);
    hexreal := hexreal || s;
$IF double
    j := f[6] * #H100 + f[5];
    putstring (s,j:4:H);
    hexreal := hexreal || s;
    j := f[8] * #H100 + f[7];
    putstring (s,j:4:H);
$ENDIF
$ENDIF

$IF p10
    j := ((f[1] mod #O1000) * #O1000000 + f[2]) * 2;
$IF double  j := j + f[3] div #O400000;
    putstring (s,j:7:H);
    hexreal := hexreal || s;
$IF double
    j := f[3] mod #O400000;
    putstring (s,j:4:H);
    hexreal := hexreal || s;
    j := f[4] * 4;
    putstring (s,j:5:H);
    hexreal := hexreal || s;
$ENDIF
$ENDIF

  end;
  hexreal := hexreal || ') ';
end.
  