r (pasdev1)pascal
/enable(adp)/nocheck/stat/trace
bg
bgio
bgeval

gfd pascal10c
del bg.*
do link
bg[,320225],bgio[,320225],bgeval[,320225]
/s rdlib[,274427]
/s paslib [,274427]
/s forlib[,320155]
bg/ssave/g

do filex
bg.exe=bg.shr

gfd
del bg.exe
copy (pascal10c)bg.exe to same
gfd pascal10c
del bg.*
gfd
r (upl)com;bgio

r (upl)com;bgvax

 