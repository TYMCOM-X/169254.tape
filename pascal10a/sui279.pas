
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 279*)
(*TEST 6.8.3.9-20, CLASS=QUALITY*)
(* This test checks that for statements may be nested to 15 levels
  The test may detect a small compiler limit, particularly
  those compilers that use a register for a control variable. *)
program t6p8p3p9d20;
var
   i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15:integer;
   j:integer;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #279');
   for i1:=1 to 2 do
     for i2:=1 to 2 do
        for i3:=1 to 2 do
           for i4:=1 to 2 do
              for i5:=1 to 2 do
                 for i6:=1 to 2 do
                    for i7:=1 to 2 do
                       for i8:=1 to 2 do
                          for i9:=1 to 2 do

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

                             for i10:=1 to 2 do
                                for i11:=1 to 2 do
                                   for i12:=1 to 2 do
                                      for i13:=1 to 2 do
                                         for i14:=1 to 2 do
                                            for i15:=1 to 2 do
                                                j:=10;
   writeln(' FOR STATEMENT NESTED TO > 15 LEVELS...6.8.3.9-20')
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    