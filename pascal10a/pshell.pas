MODULE SHELL;

(* PASCAL PROCEDURE TO PERFORM SHELL SORT *)

CONST
  MININT = MINIMUM(INTEGER);
  MAXINT = MAXIMUM(INTEGER);
TYPE
  INTEGER = MININT..MAXINT;
  PASSEDARRAY = ARRAY[1..1000] OF INTEGER;

PUBLIC PROCEDURE SHELL(VAR A:PASSEDARRAY; N: INTEGER);
VAR I,J,K,M,W: INTEGER;
LABEL 1;

BEGIN
  I:= 1;
  WHILE I<=N DO
  BEGIN
    M:= 2*I - 1;
    I:= I+I
  END;
  M:= M DIV 2;
  WHILE M<>0 DO
  BEGIN K:= N-M;
    FOR J:=1 TO K DO
    BEGIN
      I:= J;
      WHILE I>=1 DO
      BEGIN
        IF A[I+M]>=A[I] THEN GOTO 1;
        W:= A[I]; A[I]:= A[I+M]; A[I+M]:= W;
        I:= I-M
      END;
1:  END;
    M:= M DIV 2
  END
END.
  