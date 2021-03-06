(*   SCANNER ALGORITHM CREATED BY LEXGEN    *)
(********************************************)

PROGRAM ??????;

CONST
   MAXINDEX    =  ???;  (* MAX INDEX USED TO ACCESS BUFFER *)
   BUFFERSIZE  =  ???;  (* MAXINDEX + 1 *)
   MAXTOKEN    =    4;
   DFASTATE1   =    3;  (* CODE FOR INITIAL STATE OF DFA *)
   MAXDFASTATE =   32;  (* CODE FOR MAX STATE OF DFA *)
   MINTERMINAL =  -13;  (* MIN TERMINAL CODE *)
   EODATA      =   -1;  (* CODE FOR END-OF-DATA *)


TYPE
   STATERANGE  = 1..MAXDFASTATE;
   EXSTATERANGE= 0..MAXDFASTATE;
   INDEXRANGE  = 0..MAXINDEX;
   LEXTOKEN    = RECORD
                    TOKEN_TYPE: ???;
                    MORE: ???  (* POINTER TO SYMBOL TABLE, CODE
                                  TO DIFFERENTIATE DIFFERENT SYMBOLS
                                  SUCH AS RELATIONAL OPERATORS OF THE
                                  SAME TOKEN_TYPE, ETC.  *)
                 END;

VAR
   DELTA: PACKED ARRAY [STATERANGE, MINTERMINAL..EODATA] OF EXSTATERANGE := (
      0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,18,0,17,0,0,2,2,2,0,7,0,0,0,18,
      10,6,0,0,28,2,2,1,0,0,0,0,0,0,17,0,0,4,4,4,0,0,0,0,0,0,0,0,31,0,0,
      0,14,0,0,0,0,0,0,0,12,0,0,4,4,4,0,0,0,0,13,0,0,0,0,0,0,9,9,0,0,0,0,
      0,0,0,0,0,0,0,0,5,0,0,20,19,30,0,0,0,0,0,0,15,15,0,7,0,0,0,0,0,0,0,
      0,10,10,10,0,0,0,0,0,0,0,0,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,29,29,29,
      0,0,0,0,0,0,0,0,0,0,0,22,22,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,20,0,0,
      0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,12,0,21,26,26,26,0,7,0,0,0,0,0,0,0,
      21,24,24,24,0,7,0,0,0,0,0,27,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,23,0,
      0,0,0,0,0,13,0,0,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,20,0,30,
      0,0,0,0,0,0,15,15,0,0,20,0,0,0,0,0,0,0,23,0,0,0,7,0,0,0,0,0,25,0,
      21,24,24,24,0,7,0,0,0,0,0,0,0,21,25,25,25,0,7,0,0,0,0,0,17,0,21,
      26,26,26,0,0,0,0,0,0,0,12,0,0,27,27,27,0,7,0,0,0,18,0,16,0,0,28,2,
      2,0,0,0,0,0,0,0,25,0,0,29,29,29,0,0,0,0,0,0,0,0,0,0,0,15,15,0,7,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27,0,0,32,0,0,0);

   (* FINAL [X] = 0 IF STATE X IS NOT A FINAL STATE
                 1 IF STATE X RECOGNIZES <*****END OF DATA*****>
                 2 IF STATE X RECOGNIZES <file spec>
                 3 IF STATE X RECOGNIZES <file defaults>
                 4 IF STATE X RECOGNIZES <bad spec>
                                                                 *)
   FINAL: PACKED ARRAY [EXSTATERANGE] OF 0..MAXTOKEN := (
      0,1,2,0,0,0,0,0,0,2,2,0,0,0,0,2,2,2,2,0,0,0,2,2,2,2,2,0,2,0,0,2,0);

   BEGIN_INDEX, END_INDEX: INDEXRANGE;
   LEXEME: LEXTOKEN;
   BUFFER: ARRAY [INDEXRANGE] OF MINTERMINAL..EODATA;


PROCEDURE SCAN (VAR BEGIN_INDEX, END_INDEX: INDEXRANGE;
               VAR LEXEME: LEXTOKEN);

   VAR
      NEWTOKEN:  BOOLEAN;
      CURRSTATE, CURRFINAL: EXSTATERANGE;
      OLDINDEX:  INDEXRANGE;


   PROCEDURE GETCHAR (NEWTOKEN: BOOLEAN);
      BEGIN
         <  THIS PROCEDURE OBTAINS THE NEXT INPUT CHARACTER (WHICH
            IS ASSUMED TO BE EODATA IF NO MORE INPUT) AND MODIFIES
            BEGIN_INDEX AND END_INDEX AS NECESSARY DEPENDING ON
            THE BUFFERING SCHEME SO THAT
             (1) IF NEWTOKEN, THEN BEGIN_INDEX POINTS TO THE INPUT
                 CHARACTER JUST OBTAINED, ELSE BEGIN_INDEX POINTS
                 TO THE SAME CHARACTER IT POINTED TO BEFORE.
             (2) END_INDEX IS THE INDEX OF THE NEW CHARACTER JUST
                 OBTAINED.
            SCAN ALLOWS FOR EITHER SEQUENTIAL OR CIRCULAR BUFFER  >
      END (* GETCHAR *);


   BEGIN (* SCAN *)
      NEWTOKEN  := TRUE;
      CURRSTATE := DFASTATE1;  (* START IN INITIAL STATE *)
      CURRFINAL := 0;
      OLDINDEX  := 0;  (* WIDTH OF LEXEME AS OF LAST FINAL STATE *)

      WHILE CURRSTATE <> 0 DO
         BEGIN
            IF FINAL [CURRSTATE] <> 0 THEN
               BEGIN
                  CURRFINAL := CURRSTATE;
                  OLDINDEX := (END_INDEX - BEGIN_INDEX) MOD BUFFERSIZE
               END;
            GETCHAR (NEWTOKEN);
            NEWTOKEN := FALSE;
            CURRSTATE := DELTA [CURRSTATE, BUFFER [END_INDEX]]
         END;
      END_INDEX := (BEGIN_INDEX + OLDINDEX) MOD BUFFERSIZE;

       < COMPUTE LEXEME GIVEN FINAL [CURRFINAL], BEGIN_INDEX, END_INDEX, 
         ETC.                                                          >

   END (* SCAN *);


BEGIN (* MAINLINE *)
          .
          .
          .
   SCAN (BEGIN_INDEX, END_INDEX, LEXEME);
              (* AS NEEDED UNTIL END-OF-DATA LEXEME IS OBTAINED *)
          .
          .
          .
END. (* MAINLINE *)
  