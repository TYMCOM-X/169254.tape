do filex
newpas.exe=newpas.shr
vaxdrv.exe=vaxdrv.shr
paslst.exe=paslst.shr
vaxccg.exe=vaxccg.shr
nxtpas.exe=nxtpas.shr
vaxini.exe=vaxini.shr

DEL NEWPAS.SHR,NEWPAS.LOW
DEL VAXDRV.SHR,VAXDRV.LOW
DEL PASLST.SHR,PASLST.LOW
DEL VAXCCG.SHR,VAXCCG.LOW
DEL NXTPAS.SHR,NXTPAS.LOW
DEL VAXINI.SHR,VAXINI.LOW
  