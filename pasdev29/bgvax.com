r (pasdev1)pascal
:targ vax
/stat/enable(vax)/nocheck/trace/nodebug
bg
bgio
bgeval

    