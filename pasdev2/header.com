do qed
l header.lis
set wild on
1,$s@/*@@
f::.cop a.;.-1,.join/.tmp=/;s@@.doc/lib:header[31024,320156]/nopascal@
n
w headr1.tmp
y
l header.lis
set wild on
1,$s@/*@@
f::.cop a.;.-1,.join/.hdr=/;s@@.tmp/n@
n
w headr2.tmp
y
q
do pmf
@headr1.tmp

do scribe
@headr2.tmp

r(upl)com;(pasdev2)headr1

   