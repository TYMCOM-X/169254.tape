PROGRAM TEST46 OPTIONS DUMP;

(*  SET EXPRESSIONS AND CONSTANTS  *)

VAR I, J, K, L: INTEGER;
    A: ARRAY [1..2] OF INTEGER;

CONST
    C1 = [];
    C2 = [4];
    C3 = [3..5];
    C4 = [1,3];
    C5 = [1,3,5..7,9];
    C6 = ([1..5] * [3..7]) + [1,7] - [5];
    C7 = ['A'..'Z'] + ['0'..'9'] - ['A','0'];

    C8: SET OF 1 .. 10 = [1,3,5,7,9];
    C9: SET OF 1 .. 10 = [4,8,12];
    C10 = C8 + C9;

BEGIN
  IF I IN [] THEN;
  IF I IN [I] THEN;
  IF I IN [I..J] THEN;
  IF I IN [I,J..K,L] THEN;

  IF I IN [1..3,'C'] THEN;
  IF I IN [1..'C',3] THEN;
  IF I IN [J,A,K] THEN;
END.
   