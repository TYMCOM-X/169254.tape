do (pasdev10)pascal
:targ vax
/source/assemb/stat/nocheck/trace/overlay
link11.obj,link11.lst=ovllnk/enable(link1,ver1)
.p
link12.obj,link12.lst=ovllnk/enable(link1,ver2)
.p
link21.obj,link21.lst=ovllnk/enable(link2,ver1)
.p
link22.obj,link22.lst=ovllnk/enable(link2,ver2)
.p

 