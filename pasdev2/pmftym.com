; This COM file compiles PMF for TYMSHARE
do pascal
/search:(pasdev2)
/enable(TYMSHARE)
/optimize
pmf
pmfcmd
pmfinp
pmfput
pmfdef
pmfexp
pmfscn
pmferr

    