$TITLE pascv - conversion and formatting utilities
$LENGTH 42

module pascv;
$PAGE includes
$INCLUDE pascal.inc
$INCLUDE ptmcon.inc
$PAGE width
(* WIDTH returns the minimum number of character positions required to
   print its integer parameter *)

public function width (val: integer): integer;

var
    absval: integer;

begin
  width := ord (val < 0);
  absval := abs (val);
  repeat
    width := width + 1;
    absval := absval div 10
  until absval = 0;
end;
$PAGE cv_int
(* CV_INT converts an integer to a minimal length string *)

public function cv_int (val: integer): parm_string;

begin
  putstring (cv_int, val: 0);
end;
$PAGE cvf_int
(* CVF_INT converts an integer to a fixed length string. Returns a string
    of '*'s if the fieldwidth is exceeded *)

public function cvf_int (val: integer; columns: line_index): parm_string;

begin
  putstring (cvf_int, val: columns);
  if length (cvf_int) > columns then
    cvf_int := substr ('********************', 1, columns);
end;
$PAGE cv_radix
(*  CV RADIX returns a fixed-length string with leading zeros (or a varying-
    length string, if Columns is zero), containing the representation of an
    integer in the machine radix.  *)

public function cv_radix ( val: integer; columns: line_index ): parm_string;

var width: line_index;

begin
  if columns = 0
    then width := upperbound (cv_radix)
    else width := columns;
  if radix = hex_radix
    then putstring (cv_radix, val: width: h)
    else putstring (cv_radix, val: width: o);
  if columns = 0 then
    cv_radix := substr (cv_radix, verify (cv_radix, [cv_radix [1]], length (cv_radix)));
end;
$PAGE cv_real

(* CV_REAL converts a real number to a string of the form:
        (-)I.F  if  -4 <= log10(value) <= 10, or
        (-)I.Fe(+-)N  otherwise         *)


public function cv_real (val: real_type): parm_string;

var str: string [2 * maximum (prec_type) + 2];
    m, n: integer;

begin
  putstring (str, val: upperbound (str): maximum (prec_type));
  str := substr (str, verify (str, [' ']));
  m := search (str, ['E'], length (str) + 1);
  n := m - 1;
  while str [n] = '0' do
    n := n - 1;
  cv_real := substr (str, 1, n) || substr (str, m);
end;
$PAGE cv_fp
(* CV_FP converts a file_no/page_no pair to a string *)


public function cv_fp (src: source_id): parm_string;

begin
  with src do
    if file_no = 0
      then cv_fp := cv_int (page_no)
      else cv_fp := cv_int (file_no) || '-' || cv_int (page_no);
end;
$PAGE cv_source_id
(* CV_SOURCE_ID converts a fileno/pageno/lineno trio to a string of the form
   "f-p/l", omitting zero fields *)


public function cv_source_id (src: source_id): parm_string;

begin
  with src do begin
    cv_source_id := '';
    if file_no <> 0 then
      cv_source_id := cv_int (file_no) || '-';
    if page_no <> 0 then
      cv_source_id := cv_source_id || cv_int (page_no) || '/';
    cv_source_id := cv_source_id || cv_int (line_no);
  end; (* with *)
end (* cv_source_id *) .
   