del ???bld.cmd
do build
c0,1,2,3,4,6,7;qf
rename ???bld.cmd as 000bld.cmd
do qed
l 000bld.cmd
1,2d
w
y
q
do xref
p10.xrf=@000bld.cmd,@(pasdev1)librry.cmd
Pascal Version 2, Composite xref of all PDP10 Optimizer passes
delete 000bld.cmd
 