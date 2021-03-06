program tst102;

 const
   cstr := 'abcedf';
   cch := 'C';

 type
   fs = packed array[1..10] of char;
   fsl = packed array[1..100] of char;
   xs = packed array[1..*] of char;
   vs = string[5];
   vsl = string[120];
   xvs = string[*];

 var
   ch: char;
   ifs: fs;
   ifsl: fsl;
   ivs: vs;
   ivsl: vsl;

   i,j: 0..16000;

   p: ^ record
	  a: boolean;
	  rxs: xs
	end;

  q: ^ record
	 a: boolean;
	 rxvs: string[*]
       end;

procedure pch (valch: char);
 begin
  i := ord (valch);
 end;

procedure pfs (valfs: fs);
 var ch: char;
 begin
  ch := lowercase (valfs);
  i := length (valfs);
 end;

procedure pfsl (valfsl: fsl);
 var lvsl: vsl;
 begin
  lvsl := valfsl;
 end;

procedure pxs (valxs: xs);
 var lvs: vs;
 begin
  lvs := substr (valxs, 4);
  lvs := substr (substr (valxs, i, j), i, 2);
 end;

procedure pvs (valvs: vs);
 begin
  q^.rxvs := valvs;
 end;

procedure pvsl (valvsl: vsl);
 begin
  ifs := valvsl;
 end;

procedure pxvs (valxvs: xvs);
 begin
  i := upperbound (valxvs);
  ifs := valxvs;
  ifs[i] := valxvs[i];
 end;

begin
 ch := ch;
 ch := ifs[i];
 ch := ifsl [j + 4];
 ch := ivs [length (ivs)];
 ch := p^.rxs [i];
 ch := q^.rxvs [i];

 ch := ifs;
 ifs := ivs;
 ivs := ivsl;
 ifsl := ch;
 ivsl := ifsl;
 p^.rxs := 'test';
 q^.rxvs := ifs;

 pfs ('c');
 pfs (cch);
 pfs ('string constant');
 pfs (cstr);
 pfs (ifs);
 pfs (ifsl);
 pfs (ivs);
 pfs (ivsl);
 pfs (p^.rxs);
 pfs (q^.rxvs);
 pfs (substr (ifsl, 2, 3));

 pfsl ('c');
 pfsl (cch);
 pfsl ('string constant');
 pfsl (cstr);
 pfsl (ifs);
 pfsl (ifsl);
 pfsl (ivs);
 pfsl (ivsl);
 pfsl (p^.rxs);
 pfsl (substr (ifsl, 2, 3));
 pfsl (q^.rxvs);

 pxs ('c');
 pxs (cch);
 pxs ('string constant');
 pxs (cstr);
 pxs (ifs);
 pxs (ifsl);
 pxs (ivs);
 pxs (ivsl);
 pxs (substr (ifsl, 2, 3));
 pxs (p^.rxs);
 pxs (q^.rxvs);

 pvs ('c');
 pvs (cch);
 pvs ('string constant');
 pvs (cstr);
 pvs (ifs);
 pvs (ifsl);
 pvs (ivs);
 pvs (substr (ifsl, 2, 3));
 pvs (ivsl);
 pvs (p^.rxs);
 pvs (q^.rxvs);

 pvsl ('c');
 pvsl (cch);
 pvsl ('string constant');
 pvsl (cstr);
 pvsl (ifs);
 pvsl (ifsl);
 pvsl (substr (ifsl, 2, 3));
 pvsl (ivs);
 pvsl (ivsl);
 pvsl (p^.rxs);
 pvsl (q^.rxvs);

 pxvs ('c');
 pxvs (cch);
 pxvs ('string constant');
 pxvs (cstr);
 pxvs (ifs);
 pxvs (ifsl);
 pxvs (ivs);
 pxvs (ivsl);
 pxvs (p^.rxs);
 pxvs (q^.rxvs);

 pch ('c');
 pch (cch);
 pch ('string constant');
 pch (cstr);
 pch (ifs);
 pch (ifsl);
 pch (ivs);
 pch (ivsl);
 pch (p^.rxs);
 pch (q^.rxvs);

 ch := substr (ch, 1, j);
 ifsl := substr (substr (ivs, i), 3, j);
end.
   