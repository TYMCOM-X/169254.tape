datamodule smr001;

public var
  i: integer := 1;
  j: integer := -2;
  i_0_255: 0..255 := 200;
  i_m128_127: -128..127 := -128;
  ip: packed [8] 0..255 := 255;
  ips: packed [8] -128..127 := 127;
  ipsa: packed [7] -1..2 := -1;
  ips16: packed [16] -32768..32767 := -32000;
  ipu16: packed [16] 0..177777b := 100000b;
  b: boolean := true;
  s: (red, blue, green) := green;
  str: string := 'default length string';
  str12: string[12] := 'twelve';
  fstr20: packed array [1..20] of char := 'fixed twenty';
  ch: char := 'a';
  set0_3: set of 0..3 := [1,2];
  set0_28: set of 0..28 := [0,2,4,6,20..28];
  set2_7: set of 2..7 := [3,7];
  set7_125: set of 7..125 := [7..125];
  set0_0: set of 0..0 := [0];
  set_of_char: set of char := [' '..'g'];
  real_single: real := 1.0;
  real_double: 0..maximum(real) prec 16 := 0.5;
  proc: procedure;
 prec1: packed record b1: boolean; ch: char end := (true, ' ');
 prec2: packed record f1: 0..255; f2: -128..127 end := (128,-127);
 prec3: packed record f1: char; f2: -32768..32767;
	f3: 0..177777b end := ('A', -32768, 32767);
 prec4: packed record f1: boolean; f2: -32768..32768 end := (true,32768);
 prec5: packed record f1: 0..255; f2: real end := (1, 1.0);
 prec6: packed record f1: -128..127; 
	f2: packed array [1..4] of char end := (-1, 'abc');
 prec7: packed record f1: 0..256;
	f2: string[5] end := (256, 'five');
  urec1: record b1: boolean; ch: char end := (true, ' ');
  urec2: record f1: 0..255; f2: -128..127 end := (128,-127);
  urec3: record f1: char; f2: -32768..32767;
	f3: 0..177777b end := ('A', -32768, 32767);
  urec4: record f1: boolean; f2: -32768..32768 end := (true,32768);
  urec5: record f1: 0..255; f2: real end := (1, 1.0);
  urec6: record f1: -128..127; 
	f2: packed array [1..4] of char end := (-1, 'abc');
  urec7: record f1: 0..256;
	f2: string[5] end := (256, 'five');
  rec8: record  
    f1: 0..255;
    f2: record f21: boolean end;
  end := (255, (true));
  rec9 : record
    f1: char;
    f2: record f21: 0..256 end
  end := ('A', (256));
  rec10: record
    f1: boolean;
    f2: record f21: integer end;
  end := (false, (-37));
  prec8: packed record  
    f1: 0..255;
    f2: record f21: boolean end;
  end := (255, (true));
  prec9 : packed record
    f1: char;
    f2: record f21: 0..256 end
  end := ('A', (256));
  prec10: packed record
    f1: boolean;
    f2: record f21: integer end;
  end := (false, (-37));
  rec11: record  
    f1: 0..255;
    f2: packed record f21: boolean end;
  end := (255, (true));
  rec12 : record
    f1: char;
    f2: packed record f21: 0..256 end
  end := ('A', (256));
  rec13: record
    f1: boolean;
    f2: packed record f21: integer end;
  end := (false, (-37));
  prec11: packed record  
    f1: 0..255;
    f2: packed record f21: boolean end;
  end := (255, (true));
  prec12: packed record
    f1: char;
    f2: packed record f21: 0..256 end
  end := ('A', (256));
  prec13: packed record
    f1: boolean;
    f2: packed record f21: integer end;
  end := (false, (-37));
  rec14: ^record
    f1: boolean;
    f2: packed array [1..*] of char;
  end;
  prec14: ^ packed record
    f1: boolean;
    f2: packed array [1..*] of char;
  end;
  rec15: ^record
    f1: boolean;
    f2: string[ * ];
  end;
  prec15: ^packed record
    f1: boolean;
    f2: string[ * ];
  end;
  rec16: ^record
    f1: char;
    f2: array [1..*] of 0..177777b;
  end;
  prec16: ^packed record
    f1: char;
    f2: array [1..*] of 0..177777b;
  end;
  rec17: ^ record
    f1: char;
    f2: packed array [1..*] of 0..177777b;
  end;
  prec17: ^packed record
    f1: char;
    f2: packed array [1..*] of 0..177777b;
  end;
  rec18: record
    f1: boolean;
    case boolean of
      true: (f2: char);
      false: (f3: boolean);
  end;
  rec19: record
    f1: char;
    case integer of
      1: (f2: char);
      2: (f3: string[3]);
  end;
  rec20: record
    f1: boolean;
    case char of
      'A': (f2: boolean);
      'Z': (f3: integer);
  end;
  rec21: record
    f1: char;
    case f2: -1..128 of
      -1: (f3: boolean);
      0:  (f4: char);
  end;
  rec22: record
    f1: boolean;
    case f2: 1..2 of
      1: (f3: record f31: string[5] end);
      2: (f4: record f41: 0..255 end);
  end;
  prec18: packed record
    f1: boolean;
    case boolean of
      true: (f2: char);
      false: (f3: boolean);
  end;
  prec19: packed record
    f1: char;
    case integer of
      1: (f2: char);
      2: (f3: string[3]);
  end;
  prec20: packed record
    f1: boolean;
    case char of
      'A': (f2: boolean);
      'Z': (f3: integer);
  end;
  prec21: packed record
    f1: char;
    case f2: -1..128 of
      -1: (f3: boolean);
      0:  (f4: char);
  end;
  prec22: packed record
    f1: boolean;
    case f2: 1..2 of
      1: (f3: record f31: string[5] end);
      2: (f4: record f41: 0..255 end);
  end;
  rec23: record
    f1: boolean;
    case f2: 1..2 of
      1: (f3: packed record f31: string[5] end);
      2: (f4: packed record f41: 0..255 end);
  end;
  prec23: packed record
    f1: boolean;
    case f2: 1..2 of
      1: (f3: packed record f31: string[5] end);
      2: (f4: packed record f41: 0..255 end);
  end;
  flxarr1: ^array [-2..*] of -32768..32767;
  pflxarr1: ^packed array [-2..*] of -32768..32767;
  flxarr2: ^array [7..*] of char;
  pflxarr2: ^packed array [7..*] of char;

end.
    