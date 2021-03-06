program djw10 options dump(noro);

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
  i, j: integer;
  s1, t1, u1: one_word_base_0;
  i1, j1: lowerbound (one_word_base_0)..upperbound (one_word_base_0);
  s2, t2, u2: two_word_base_0;
  i2: lowerbound (two_word_base_0)..upperbound (two_word_base_0);
  s3, t3, u3: three_word_base_0;
  s3_b1: three_word_base_1;
  i3_b1: lowerbound (three_word_base_1)..upperbound (three_word_base_1);
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

begin
  s1 := t1 + u1;
  s1 := s1 + t1;
  s1 := u1 + s1;
  s1 := t1 + [];
  s1 := t1 + [3];

  s2 := t2 + u2;
  s2 := s2 + t2;
  s2 := t2 + s2;
  s3 := t3 + u3;
  s3 := s3 + t3;
  s4 := t4 + u4;
  s4 := s4 + t4;
  s5 := t5 + u5;
  s5 := s5 + t5;
  s6 := t6 + u6;
  s6 := s6 + t6;
  s7 := t7 + u7;
  s8 := t8 + u8;
  s8 := t8 + s8;
  s9 := t9 + u9;
  s9 := s9 + u9;
  s10 := t10 + u10;
  s10 := s10 + t10;
  s11 := t11 + u11;
  s11 := s11 + t11;
  s12 := t12 + u12;
  s15 := t15 + u15;
  s15 := s15 + t15;

  s23 := t23 + u23;
  s23 := t23 + s23;
  s23 := s23 + t23;

  s11_b4 := t11_b4 + s11_b4;
  s4 := t11_b4 + s11_b4;
  s4 := t11_b4 + [i11_b4];
  s4 := s4 + [i11_b4];

  s4 := t4 + (s4 + u4);
  s4 := s4 + (t4 + u4);
  s4 := (s4 + t4) + (t4 + u4);
  s4 := [i4] + s4;
  s4 := [i4] + t4;
  s4 := ([i4] + s4) + t4;
  s4 := ([i4] + s4) + s4;
  s4 := ([i4..j4] + s4) + s4;

  s4 := t4 + s1;
  s4 := t4 + s2;
  s4 := t4 + s3;
  s4 := s3_b1 + s4;
  s4 := s3_b1 + t4;

  s15 := s11_b4 + t15;
  s15 := s11_b4 + s15;
  s15 := s11_b4 + t11;
  s23 := s15 + t15;
  s23 := s15 + s23;
  s23 := s11_b4 + s23;
  s23 := s11_b4 + t23;

  s23 := [367];
  s23 := s23 + [367];
  s23 := t23 + [367];
  s23 := [360,367];
  s23 := s23 + [360,367];
  s23 := t23 + [360,367];
  s23 := [0,360,367];
  s23 := s23 + [0,360,367];
  s23 := s23 + t23 + [0,360,367];
  s23 := [0] + s23 + [360] + t23 + [367];
  s23 := s23 + [360] + t23 + [367];
  s23 := [0] + s23 + [16] + t23;
  s23 := s23 + [200] + t23;

  s11_b4 := [0] + [64] + s1 + [i11_b4..j11_b4] + s11_b4 + [i11_b4] + [i23];
end.
 