do decmac
mmovlm=mmovlm[,320210]

copy mmovlm.rel+infpac.rel to mmovlm.rel
do link
@odms
do link
@mdlpro
do filex
odms.exe=odms.shr
mdlpro.exe=mdlpro.shr

del odms.shr,odms.low
del mdlpro.shr,mdlpro.low
 