run mtest
.o mt111:
.b 1
yes
.o mt021:
.b 1
yes
.p
c121
111
.d b
.p
011
v mt11 1
c021
.d b
.p
111
021
.o mt111:
.b 1
yes
.p
111
.p
011
f mtalt1.exe
a mt11
c121
021
.d b
.p
111
021
.o mt012:
.b mt012/1
yes
.p
011
d
f mtalt0.exe
a mt02
c012
.d b
.p
021

.p

d
c021
021
011
012
.clear
yes
.p
021
111
021
211
211
221
131
012
111
121
131
031
011
111
121
121
021
021
211
221
131
012
231
011
q
 