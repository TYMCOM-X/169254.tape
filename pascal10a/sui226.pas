
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(* program number 226*)
(*TEST 6.7.2.4-1, CLASS=ERRORHANDLING*)
(* This test checks that operations on overlapping sets are detected.
  An error should be detected by the compiler or produced
  at run time. *)
program t6p7p2p4d1;
var
   a,d : set of 0..10;
   b,c : set of 5..15;
begin
        rewrite(output,'suite.txt',[preserve]);       writeln('suite program #226');
   b:=[5,10];
   a:=[0,5,10];
   d:=a+b;   (*ok*)
   b:=[5,10,15];
   c:=a+b;   (*should be an error*)
   writeln(' ERROR NOT DETECTED...6.7.2.4-1: OVERLAPPING SETS');
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 