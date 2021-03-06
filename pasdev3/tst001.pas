(* TST001 - file operations. *)

program tst001;

const
  zero = 0;
  null: set of 0..63 = [];

var
  f: text;
  f_typed: file of boolean;
  f_binary: file of *;
  a: array [1..10] of integer;
  s: file_name;
  i,j,k: integer;
  b1,b2: boolean;
  ch: char;
  x,y,z: real;
  set_0_63_a: set of 0..63;

begin
  open ( f );
  page ( f );
  clear ( f );
  break ( f );
  empty ( f );
  close ( f );
  scratch ( f );
  get ( f );
  put ( f );
  s := filename ( f );
  read ( f, i, ch, x, s );
  readln ( f, i, ch, x, s );
  write ( f, i, b1, x, s );
  writeln ( f, i, b1, x, s );

  (* Typed I/O.  *)

  update ( f_typed, 'tst001.dat' );
  read ( f_typed, b1, b2 );
  write ( f_typed, b1, b2 );
  seek ( f_typed, i );
  close ( f_typed );

  (* Binary I/O.  *)

  update ( f_binary, 'tst001.dat' );
  read ( f_binary, a:i, a );
  write ( f_binary, a:i, a );
  seek ( f_binary, i );
  write ( f_binary, zero, null );
  close ( f_binary );
end.
    