del ???bld.cmd
do build
c9;qf
rename ???bld.cmd as 000bld.cmd
do qed
l 000bld.cmd
1,2d
w
y
q
do xref
vaxini.xrf=@000bld.cmd,@(pasdev1)librry.cmd
Pascal Version 2, Pass 9:  VAX Initialization
del 000bld.cmd
r(upl)com;(pasdev1)pa10xr

 