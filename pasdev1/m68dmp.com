do pascal
/search ((pasdev2))
/enable stats
m68dmp

do link
m68dmp/ssave=
m68dmp
/sea fio[31024,320156]
/sea paslib[31024,320155]
/sea forlib[31024,320155]
/g
    