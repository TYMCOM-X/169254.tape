do newpas
/s,dump(ifm0)
exe001
exe002
exe003
exe004
exe005
exe006

do runcop
smr
exe001.lst
exe002.lst
exe003.lst
exe004.lst
exe005.lst
exe006.lst
done
del exe001.lst,exe002.lst,exe003.lst,exe004.lst,exe005.lst,exe006.lst
del exe001.dmp,exe002.dmp,exe003.dmp,exe004.dmp,exe005.dmp,exe006.dmp
   