pdp
r (upl)fudge2
paslib=[31024,320155]debmon,debug,debio,deblex,debbrk,debref,debasm,
debdmp,debscp,debsym,debprt,debbol,
pasmon,rtenv,dbsup,mmmodf,ncqfit,mmqfit,rtstrs,
rtsets,rtcnv,iotty/a

paslib=paslib,iofile,[31024,320155]iocnnl,iontxt,iochar,iochfk,ioerro,
[31024,274427]tenio,pasdis,decode,
[31024,320155]buf0,pasppn,iofake/a


r (upl)com;paslb2


 