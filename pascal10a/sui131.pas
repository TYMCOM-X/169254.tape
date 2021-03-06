
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 131*)
(*TEST 6.5.1-2, CLASS=QUALITY*)
(* This test checks that long declaration lists are allowed by
  the compiler. The test may detect a small compiler limit . *)
program t6p5p1d2;
var
   i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,
   i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,
   i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,
   i30,i31,i32,i33,i34,i35,i36,i37,i38,i39,
   i40,i41,i42,i43,i44,i45,i46,i47,i48,i49,
   i50,i51,i52,i53,i54,i55,i56,i57,i58,i59,
   i60,i61,i62,i63,i64,i65,i66,i67,i68,i69,
   i70,i71,i72,i73,i74,i75,i76,i77,i78,i79,
   i80,i81,i82,i83,i84,i85,i86,i87,i88,i89,
   i90,i91,i92,i93,i94,i95,i96,i97,i98,i99
   : integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #131');
  i0:=0; i1 :=1; i2:=2; i3:=3; i4:=4; i5:=5; i6:=6; i7:=7;i8:=8; i9:=9;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

  i10:=i0+1; i11:=i1+1; i12:=i2+1; i13:=i3+1; i14:=i4+1;
  i15:=i5+1; i16:=i6+1; i17:=i7+1; i18:=i8+1; i19:=i9+1;
  i20:=i10+i0; i21:=i11+i1; i22:=i12+i2; i23:=i13+i3; i24:=i14+i4;
  i25:=i15+i5; i26:=i16+i6; i27:=i17+i7; i28:=i18+i8; i29:=i19+i9;
  i30:=i20+i10; i31:=i21+i11; i32:=i22+i12; i33:=i23+i13; i34:=i24+i14;
  i35:=i25+i15; i36:=i26+i16; i37:=i27+i17; i38:=i28+i18; i39:=i29+i19;
  i40:=i30+i20; i41:=i31+i21; i42:=i32+i22; i43:=i33+i23; i44:=i34+i24;
  i45:=i35+i25; i46:=i36+i26; i47:=i37+i27; i48:=i38+i28; i49:=i39+i29;
  i50:=i40+i30; i51:=i41+i31; i52:=i42+i32; i53:=i43+i33; i54:=i44+i34;
  i55:=i45+i35; i56:=i46+i36; i57:=i47+i37; i58:=i48+i38; i59:=i49+i39;
  i60:=i50+i40; i61:=i51+i41; i62:=i52+i42; i63:=i53+i43; i64:=i54+i44;
  i65:=i55+i45; i66:=i56+i46; i67:=i57+i47; i68:=i58+i48; i69:=i59+i49;
  i70:=i60+i50; i71:=i61+i51; i72:=i62+i52; i73:=i63+i53; i74:=i64+i54;
  i75:=i65+i55; i76:=i66+i56; i77:=i67+i57; i78:=i68+i58; i79:=i69+i59;
  i80:=i70+i60; i81:=i71+i61; i82:=i72+i62; i83:=i73+i63; i84:=i74+i64;
  i85:=i75+i65; i86:=i76+i66; i87:=i77+i67; i88:=i78+i68; i89:=i79+i69;
  i90:=i80+i70; i91:=i81+i71; i92:=i82+i72; i93:=i83+i73; i94:=i84+i74;
  i95:=i85+i75; i96:=i86+i76; i97:=i87+i77; i98:=i88+i78; i99:=i89+i79;
  i0:=i90+i91+i92+i93+i94+i95+i96+i97+i98+i99;
  if (i0=2815) then

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

     writeln(' LONG DECLARATIONS ALLOWED...6.5.1-2')
  else
     writeln(' LONG DECLARATIONS NOT ALLOWED...6.5.1-2');
end.
 