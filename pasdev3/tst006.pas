(* tst006 - array subscripting test *)

program tst006;

type
  double = minimum(real)..maximum(real) prec 12;
  flex_vstr = string[ * ];
  flex_fstr = packed array [1..*] of char;
  dflex_array = array [-2..*] of double;
  word_array = packed array [0..12] of -129..127;
  big_set_array = packed array [1..*] of set of char;
  string_array = packed array [1..10] of packed array [1..4] of char;
  fixed_string = packed array [1..10] of char;
  d_arr_arr = array [1..4] of array [1..10] of double;
  char_index_array = packed array ['a'..'c'] of char;
  color = (red,blue,green);
  color_index_array = packed array [color] of color;
  dflex_rec = record
    f1: ^dflex_array
  end;

var
  str: string[22];
  parr: packed array [1..11] of 0..255;
  i,j: integer;
  ch: char;
  ch_set: set of char;
  ffstr_ptr: ^flex_fstr;
  dflex_ptr: ^dflex_array;
  bs_ptr: ^big_set_array;
  dx,dy: double;
  dflx_rec: dflex_rec;
  d_a_a: d_arr_arr;
  char_idx: char_index_array;
  color_idx: color_index_array;
  a_color: color;

procedure a ( word_arr: word_array; flex_vstring: flex_vstr; 
	      big_set_arr: big_set_array );
  var
    string_arr: string_array;
    fixed_str: fixed_string;

  begin
    ch := string_arr[ 5, 3 ];
    ch := str[ 20 ];
    ch_set := big_set_arr[ 8 ];
    ch := flex_vstring[ 2 ];
    ch := fixed_str[ 3 ];
    i := parr[ 11 ];
    i := word_arr[ 0 ];
    i := word_arr[ 12 ];
    ch := string_arr[ i, j ];
    i := word_arr[ j ];
    ch := flex_vstring[ j ];
    ch_set := big_set_arr[ i ];
    ch := fixed_str[ i ];
  end;

begin
  ch := str[17];
  ch := str[ i ];
  i := parr[ 8 ];
  i := parr[ 4*i + 1 ];
  dx := dflex_ptr^[ i ];
  with dflx_rec do dx := f1^[ i ];
  ch := ffstr_ptr^[ j ];
  ch_set := bs_ptr^[ j ];
  dx := d_a_a[ i , j ];
  ch := char_idx[ 'c' ];
  ch := char_idx[ ch ];
  a_color := color_idx[ red ];
  a_color := color_idx[ a_color ];
end.
  