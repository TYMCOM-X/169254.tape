PROGRAM TEST25 OPTIONS DUMP;
VAR
    S1: STRING [10];
    S2: STRING [5];
    S3: STRING [1];
    P1: PACKED ARRAY [1..10] OF CHAR;
    P2: PACKED ARRAY [1..5] OF CHAR;
    P3: PACKED ARRAY [1..1] OF CHAR;
    C1, C2, C3: CHAR;

BEGIN
  P1 := P2 || P2;
  P2 := S2;
  P3 := C3;
  S1 := C1;
  S1 := P1;
  S1 := S2 || S3;
  S2 := C1 || P1;
  P2 := C1 || C2 || C3 || C2 || C1;
END.
  