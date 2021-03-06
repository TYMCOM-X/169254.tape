(* TST017 - Constant pooling test program. *)

program tst017;

type
  fstr3 = packed array [1..3] of char;
  fstr4 = packed array [1..4] of char;
  fstr7 = packed array [1..7] of char;
  fstr11 = packed array [1..11] of char;
  vstr = string[80];
  sets = set of 0..71;
  rec  = record
    f1: boolean;
    f2: integer;
    f3: char
  end;
  rectwo = record
    f1: boolean;
    f2: integer;
    f3: char;
    f4: integer
  end;
  fstr1 = packed array [1..1] of char;
  fstr10 = packed array [1..10] of char;
  fstr13 = packed array [1..13] of char;
  recthree = packed record
    f1: boolean;
    f2: integer;
    f3: char
  end;
  recfour = packed record
    f1: char
  end;
  recfive = packed record
    f1: 0..77777b
  end;
  recsix = packed record
    f1: char;
    f2: char;
    f3: recfive;
    f4: char
  end;

public const
  int1: integer := 3;
  int2: integer := 4;
  str1: fstr7 := 'ABCDEFG';
  str2: fstr11 := '12345678901';
  vstr1: vstr := 'ABC';
  vstr2: vstr := 'ABCDEFG';
  set1: sets := [20,40,60];
  set2: sets := [1,2,3];
  other1: rec := (true, 4, 'A');
  int3: integer := 0;
  int4: integer := 4;
  str3: fstr3 := 'ABC';
  str4: fstr7 := 'ABCDEFG';
  vstr3: vstr := 'ABC';
  vstr4: vstr := 'ABCDEFG';
  set3: sets := [20,40,60];
  set4: sets := [20,40,60];
  other2: rec := (false, 3, 'z');
  int5: integer := 1;
  int6: integer := 1;
  int7: integer := 4;
  str5: fstr4 := 'HACK';
  str6: fstr4 := 'HACK';
  vstr5: vstr := 'ABC';
  set5: sets := [1,2,3];
  int8: integer := 5;
  str7: fstr11 := '12345678901';
  str8: fstr4 := 'HACK';
  vstr6: vstr := 'HACK';
  bool: boolean := true;
  other3: rectwo := (true, 4, 'A', 6);
  str9: fstr1 := 'x';
  str10: fstr1 := 'y';
  str11: fstr1 := 'x';
  ch1: char := 'a';
  ch2: char := 'a';
  ch3: char := 'x';
  str12: fstr10 := '1234567890';
  str13: fstr13 := 'abcdefghijklm';
  other4: recthree := (true, 1, 'c');
  other5: recthree := (true, 4, 'a');
  other6: recfour := ('a');
  other7: recfour := ('b');
  other8: recfive := (256);
  other9: recfive := (255);
  other10: recfour := ('a');
  other11: recfour := ('b');
  other12: recfive := (256);
  other13: recfive := (255);
  other14: recfour := ('c');
  other15: recsix := ('x', 'y', (255), 'z');

begin
end.
  