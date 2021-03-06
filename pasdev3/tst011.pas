(* TST011 tests for the proper deallocation of dynamic temps.  *)

program tst011 options nocheck;

var
  fs1,fs2: ^string[ * ];
  i: integer;
  b: boolean;

label 100;

procedure gone ( s: string[ * ] );
  begin
    goto 100;
  end;


begin
  100:  if uppercase( fs1^ ) = fs2^ then goto 100;

  b := uppercase ( fs1^ ) = fs2^;
  case i of
    2: i := 0;
    3: i := 1;
    4: i := 2;
    others: i := maximum(integer)
  end;

  if uppercase ( fs1^ ) = fs2^
    then b := true
    else b := false;

  gone ( fs1^ || fs2^ );
  i := i + 1;

  while uppercase ( fs1^ ) = fs2^ do begin
    i := i + 1;
  exit if uppercase ( fs1^ ) = fs2^;
    i := i - 1;
  end;

  b := ( (uppercase ( fs1^ ) = fs2^ ) orif
	 (fs1^ = lowercase ( fs2^ ) ) ) andif
       ( uppercase ( fs1^ ) = uppercase ( fs2^ ) );
  i := 27;

  repeat
    i := i ** i;
  until uppercase ( fs1^ ) = fs2^;

  for i := 1 to 10 * ord ( uppercase(fs1^) = fs2^) do
    fs1^ := fs1^ || fs2^;
  i := 0;
end.
    