program djw11 options dump(noro);

type
  one_word_base_0 = set of 0..15;
  one_word_base_1 = set of 16..31;
  one_word_base_2 = set of 32..47;
  two_word_base_0 = set of 0..31;
  two_word_base_1 = set of 16..47;
  three_word_base_0 = set of 0..47;
  three_word_base_1 = set of 16..63;
  four_word_base_0 = set of 0..4*16 - 1;
  five_word_base_0 = set of 0..5*16-1;
  six_word_base_0 = set of 0..6*16-1;
  seven_word_base_0 = set of 0..7*16-1;
  eight_word_base_0 = set of 0..8*16-1;
  nine_word_base_0 = set of 0..9*16-1;
  ten_word_base_0 = set of 0..10*16-1;
  eleven_word_base_0 = set of 0..11*16-1;
  eleven_word_base_4 = set of 4*16..15*16-1;
  twelve_word_base_0 = set of 0..12*16-1;
  fifteen_word_base_0 = set of 0..15*16-1;
  twentythree_word_base_0 = set of 0..23*16-1;

var
  ipos, jpos: 0..maximum (integer);
  i, j, k: integer;
  s1, t1, u1: one_word_base_0;
  i1, j1: lowerbound (one_word_base_0)..upperbound (one_word_base_0);
  s2, t2, u2: two_word_base_0;
  i2: lowerbound (two_word_base_0)..upperbound (two_word_base_0);
  s3, t3, u3: three_word_base_0;
  s3_b1: three_word_base_1;
  i3_b1, j3_b1: lowerbound (three_word_base_1)..upperbound (three_word_base_1);
  s4, t4, u4:four_word_base_0;
  i4, j4: lowerbound (four_word_base_0)..upperbound (four_word_base_0);
  s5, t5, u5: five_word_base_0;
  s6, t6, u6: six_word_base_0;
  s7, t7, u7: seven_word_base_0;
  s8, t8, u8: eight_word_base_0;
  s9, t9, u9: nine_word_base_0;
  s10, t10, u10: ten_word_base_0;
  s11, t11, u11: eleven_word_base_0;
  i11, j11: lowerbound (eleven_word_base_0)..upperbound (eleven_word_base_0);
  s11_b4, t11_b4: eleven_word_base_4;
  i11_b4, j11_b4: lowerbound (eleven_word_base_4)..upperbound (eleven_word_base_4);
  s12, t12, u12: twelve_word_base_0;
  i15, j15: lowerbound (fifteen_word_base_0)..upperbound (fifteen_word_base_0);
  s15, t15, u15: fifteen_word_base_0;
  s23, t23, u23: twentythree_word_base_0;
  i23, j23: lowerbound (twentythree_word_base_0)..upperbound (twentythree_word_base_0);

  rec: packed record
    i_packed_byte,
    j_packed_byte: 0..255;
    i_packed_word,
    j_packed_word: 0..65535
  end;
  bool: boolean;

begin
  if 1 in s1 then
    i := 1;
  if 16 in s1 then
    i := 2;
  if 1 in s3_b1 then
    i := 3;
  if 16 in s3_b1 then
    i := 4;
  if i3_b1 in s3_b1 then
    i := 5;
  if i4 in s3_b1 then
    i := 6;
  if i in s3_b1 then
    i := 7;

  if 1 in [0] then
    i := 8;
  if 1 in [1] then 
    i := 9;
  if 1 in [10] then
    i := 10;
  if i1 in [0] then
    i := 11;
  if i in [5] then
    i := 12;
  if i in [256] then
    i := 13;
  
  if 1 in [0..3] then
    i := 14;
  if 1 in [2..4] then
    i := 15;
  if i in [0..3] then
    i := 16;
  if i1 in [0..15] then
    i := 17;
  if 1 in [1,3,5] then
    i := 18;
  if i3_b1 in [64..100] then
    i := 19;
  if i3_b1 in [16..63] then
    i := 190;
  if i3_b1 in [1,4,16,63,100] then
    i := 20;
  if i3_b1 in [i3_b1..j3_b1] then
    i := 21;
  if i3_b1 in [i3_b1,j3_b1] then
    i := 22;
  if i in [j..k] then
    i := 23;
  if i in [j,k] then
    i := 24;
  if 100 in [j,k] then
    i := 240;
  if i in [rec.i_packed_byte] then
    i := 25;
  if i in [rec.i_packed_byte..rec.j_packed_byte] then
    i := 26;
  if rec.i_packed_byte in [rec.i_packed_byte..rec.j_packed_byte] then
    i := 27;
  if rec.i_packed_byte in s11_b4 then
    i := 28;


  if not (1 in s1) then
    i := 1;
  if not (16 in s1) then
    i := 2;
  if not (1 in s3_b1) then
    i := 3;
  if not (16 in s3_b1) then
    i := 4;
  if not (i3_b1 in s3_b1) then
    i := 5;
  if not (i4 in s3_b1) then
    i := 6;
  if not (i in s3_b1) then
    i := 7;

  if not (1 in [0]) then
    i := 8;
  if not (1 in [1]) then 
    i := 9;
  if not (1 in [10]) then
    i := 10;
  if not (i1 in [0]) then
    i := 11;
  if not (i in [5]) then
    i := 12;
  if not (i in [256]) then
    i := 13;
  
  if not (1 in [0..3]) then
    i := 14;
  if not (1 in [2..4]) then
    i := 15;
  if not (i in [0..3]) then
    i := 16;
  if not (i1 in [0..15]) then
    i := 17;
  if not (1 in [1,3,5]) then
    i := 18;
  if not (i3_b1 in [64..100]) then
    i := 19;
  if not (i3_b1 in [16..63]) then
    i := 190;
  if not (i3_b1 in [1,4,16,63,100]) then
    i := 20;
  if not (i3_b1 in [i3_b1..j3_b1]) then
    i := 21;
  if not (i3_b1 in [i3_b1,j3_b1]) then
    i := 22;
  if not (i in [j..k]) then
    i := 23;
  if not (i in [j,k]) then
    i := 24;
  if not (i in [rec.i_packed_byte]) then
    i := 25;
  if not (i in [rec.i_packed_byte..rec.j_packed_byte]) then
    i := 26;
  if not (rec.i_packed_byte in [rec.i_packed_byte..rec.j_packed_byte]) then
    i := 27;
  if not (rec.i_packed_byte in s11_b4) then
    i := 28;



  bool := 1 in s1;
  bool := 16 in s1;
  bool := 1 in s3_b1;
  bool := 16 in s3_b1;
  bool := i3_b1 in s3_b1;
  bool := i4 in s3_b1;
  bool := i in s3_b1;

  bool := 1 in [0];
  bool := 1 in [1]; 
  bool := 1 in [10];
  bool := i1 in [0];
  bool := i in [5];
  bool := i in [256];
  
  bool := 1 in [0..3];
  bool := 1 in [2..4];
  bool := i in [0..3];
  bool := i1 in [0..15];
  bool := 1 in [1,3,5];
  bool := i3_b1 in [64..100];
  bool := i3_b1 in [16..63];
  bool := i3_b1 in [1,4,16,63,100];
  bool := i3_b1 in [i3_b1..j3_b1];
  bool := i3_b1 in [i3_b1,j3_b1];
  bool := i in [j..k];
  bool := i in [j,k];
  bool := 100 in [j,k];
  bool := i in [rec.i_packed_byte];
  bool := i in [rec.i_packed_byte..rec.j_packed_byte];
  bool := rec.i_packed_byte in [rec.i_packed_byte..rec.j_packed_byte];
  bool := rec.i_packed_byte in s11_b4;


  bool := not (1 in s1);
  bool := not (16 in s1);
  bool := not (1 in s3_b1);
  bool := not (16 in s3_b1);
  bool := not (i3_b1 in s3_b1);
  bool := not (i4 in s3_b1);
  bool := not (i in s3_b1);

  bool := not (1 in [0]);
  bool := not (1 in [1]); 
  bool := not (1 in [10]);
  bool := not (i1 in [0]);
  bool := not (i in [5]);
  bool := not (i in [256]);
  
  bool := not (1 in [0..3]);
  bool := not (1 in [2..4]);
  bool := not (i in [0..3]);
  bool := not (i1 in [0..15]);
  bool := not (1 in [1,3,5]);
  bool := not (i3_b1 in [64..100]);
  bool := not (i3_b1 in [16..63]);
  bool := not (i3_b1 in [1,4,16,63,100]);
  bool := not (i3_b1 in [i3_b1..j3_b1]);
  bool := not (i3_b1 in [i3_b1,j3_b1]);
  bool := not (i in [j..k]);
  bool := not (i in [j,k]);
  bool := not (i in [rec.i_packed_byte]);
  bool := not (i in [rec.i_packed_byte..rec.j_packed_byte]);
  bool := not (rec.i_packed_byte in [rec.i_packed_byte..rec.j_packed_byte]);
  bool := not (rec.i_packed_byte in s11_b4);
end.
 