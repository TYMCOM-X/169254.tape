
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number  64*)
(*TEST 6.4.2.2-5, CLASS=CONFORMANCE*)
(* The Pascal Standard states that the upper-case letters A-Z are
  ordered, but not necessarily contiguous.
  This program determines if this is so, and prints
  a message as to whether the compiler passes or not . *)
program t6p4p2p2d5;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #064');
   if ('A' < 'B') and ('B' < 'C') and ('C' < 'D') and
      ('D' < 'E') and ('E' < 'F') and ('F' < 'G') and
      ('G' < 'H') and ('H' < 'I') and ('I' < 'J') and
      ('J' < 'K') and ('K' < 'L') and ('L' < 'M') and
      ('M' < 'N') and ('N' < 'O') and ('O' < 'P') and
      ('P' < 'Q') and ('Q' < 'R') and ('R' < 'S') and
      ('S' < 'T') and ('T' < 'U') and ('U' < 'V') and
      ('V' < 'W') and ('W' < 'X') and ('X' < 'Y') and
      ('Y' < 'Z') then
      writeln(' PASS...6.4.2.2-5')
   else

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

      writeln(' FAIL...6.4.2.2-5: NO ORDERING')
end.
   