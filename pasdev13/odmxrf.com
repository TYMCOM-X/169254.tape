do xref
odmxrf.xrf=mmblds.sym,
mmbldp.sym,
mmdbpr.sym,
mmdbop.sym,
mmprnt.sym,
mmpack.sym,
mmodms.sym,
mmmsym.sym,
mmmdls.sym,
mmmdlp.sym,
mdlpro.sym
ODMS - Pascal Overlay System -- June 8, 1981

do runcop
wem
odmxrf.xrf
done
del odmxrf.xrf
del mmblds.sym,mmbldp.sym,mmdbpr.sym,mmdbop.sym
del mmprnt.sym,mmpack.sym,mmodms.sym,mmmsym.sym
del mmmdls.sym,mmmdlp.sym,mdlpro.sym,mmmpub.sym
   