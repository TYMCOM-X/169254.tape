files filex.tmp=*.shr/alpha
r(pasdev2)qed
l filex.tmp
1,5d
f::s/ /./;s/ //a;.cop a.;.-1s@SHR@EXE=@;.,.1join
n
1i
r filex
.
w

q
mod filex.tmp
$a


ex
r(upl)com;filex.tmp

   