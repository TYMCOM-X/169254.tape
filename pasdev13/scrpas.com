r (pasdev1)pascal
/debug,mainseg,search:(pasdev2)
scribe[,320156]
doscri[,320156]
/debug,nomainseg,overlay
getlin[,320156]
reader[,320156]
writer[,320156]
justfy[,320156]
scan[,320156]
/exit
   