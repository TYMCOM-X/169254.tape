copy dtime.vax to dtime.typ
do pascal
:targ vax
/notrace,nocheck
addday
(pasdev2)chars2
(pasdev2)cmdutl
(pasdev2)cvbins
daysdi
daytim
(pasdev2)dayofw
(pasdev2)dcdate
(pasdev2)dcdtim
(pasdev2)dcext
(pasdev2)dcmont
(pasdev2)dctime
dirmch
(pasdev2)ecdate
(pasdev2)ecdcda
(pasdev2)ecdcti
(pasdev2)ecdtim
(pasdev2)ecext
(pasdev2)ectime
extrda
(pasdev2)filutl
lookup
(pasdev2)nsd1
(pasdev2)nsd2
(pasdev2)nst1
query
(pasdev2)tempfi
fhndlr
mapimg

del dtime.typ
 