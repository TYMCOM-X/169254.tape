do pascal
print,print=print/enable:trace/deb/stat

do link
clustr
build
print
cost
optim
/g
ssave clustr
do clustr
   