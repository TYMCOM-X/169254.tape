do pascal
m68dmp/enable(stats)/search((pasdev2),(pasdev1))
:tar m68
m68dmp/a/s/enable(stats)
.p

do link
m68dmp/ssave=
m68dmp
/sea fio[31024,320156]
/sea paslib[31024,320155]
/sea forlib[31024,320155]
/g
do m68dmp
str
str
do runcop
djm
m68dmp.lst
str.ls

    