do (pasdev10)pascal
:targ vax
/source/assemb/stat/nocheck/trace/overlay
plot11.obj,plot11.lst=ovlplt/enable(plot1,ver1)
.p
plot12.obj,plot12.lst=ovlplt/enable(plot1,ver2)
.p
plot21.obj,plot21.lst=ovlplt/enable(plot2,ver1)
.p
plot22.obj,plot22.lst=ovlplt/enable(plot2,ver2)
.p

 