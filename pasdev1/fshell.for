      SUBROUTINE SHELL(A,N)
      INTEGER I,J,K,M,N,A(100)

      I=1
5     IF (I.GE.N) GO TO 10
        M=2*I-1
        I=I+I
      GO TO 5
10    CONTINUE
      M=M/2
20    IF (M.EQ.0) GO TO 80
        K=N-M
        DO 70 J=1,K
          I=J
30        IF (I.LT.1) GO TO 60
            IF (A(I+M).GE.A(I)) GO TO 1
            W=A(I)
            A(I)=A(I+M)
            A(I+M)=W
            I=I-M
          GO TO 30
60        CONTINUE
1         CONTINUE
70      CONTINUE
        M=M/2
      GO TO 20
80    CONTINUE
      END
   