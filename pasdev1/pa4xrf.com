del ???bld.cmd
do build
c4;qf
rename ???bld.cmd as 000bld.cmd
do qed
l 000bld.cmd
1,2d
w
y
q
do xref
p10ocg.xrf=@000bld.cmd,@(pasdev1)librry.cmd
Pascal Version 2, Pass 4:  PDP-10 Optimizing Code Generator
del 000bld.cmd
r (upl)com;(pasdev1)pa5xrf

 