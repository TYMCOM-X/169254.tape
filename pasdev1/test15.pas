PROGRAM TEST15;

TYPE
  REC_TYPE = RECORD
    FLD1: CHAR;
    FLD2: STRING [10];
    FLD3: 0 .. 1000;
    FLD4: ^ REC_TYPE
  END;

VAR
  I,J,K: 0 .. 1000;
  C1, C2, C3: CHAR;
  R1, R2, R3: REC_TYPE;
  P1, P2, P3: ^ REC_TYPE;
  A1, A2, A3: ARRAY [1 .. 10] OF REC_TYPE;
  S1, S2, S3: STRING;

CONST
  C_1 = '';
  C_2 = 'X';
  C_3: CHAR = 'ABC';

BEGIN
  I := 10;
  S1 := A1[I].FLD4^.FLD2[1:5];
END.
 