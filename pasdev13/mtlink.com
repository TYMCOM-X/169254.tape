do link
@mtest
do link
@mt02
do link
@mt03
do link
@mtinit
do link
@mt11
do link
@mt12
do link
@mt13
do link
@mt21
do link
@mt22
do link
@mt23
do ped
l mt11.cmd
1,$s/mt11a/mtalt1/p
1,$s'MT11/SAVE'MTALT1/SAVE'p
w mtalt1.cmd
y
l mt02.cmd
1,$s/mt02a/mtalt0/p
1,$s'MT02/SSAVE'MTALT0/SSAVE'p
w mtalt0.cmd
y
q
do link
@mtalt0
do link
@mtalt1
r (upl)com;mtexe

   