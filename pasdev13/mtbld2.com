ru (pasdev13)odms
.p
use mtest
build mt12 using mt12a,paslib[,320155]/s,forlib[,320155]/s
build mt13 using mt13a,paslib[,320155]/s,forlib[,320155]/s
build mt21 using mt21a,paslib[,320155]/s,forlib[,320155]/s
build mt22 using mt22a,paslib[,320155]/s,forlib[,320155]/s
build mt23 using mt23a,paslib[,320155]/s,forlib[,320155]/s
q

 