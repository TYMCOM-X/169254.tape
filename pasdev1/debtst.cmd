:DEBTST.LOG
:TIME 130
do pascal
(pasdev3)tst015/deb
(pasdev3)tst016/deb
(pasdev3)tst021/deb
  
do link
tst015,tst016,tst021
@debug
/go
sta
.rem A null command:
  
.rem
.rem Start off by running through the display options:
.rem
.dis iostatus
.dis extstatus
.dis modules
.dis files
.dis files tst016@
.dis files tst021@
.dis pages
.dis pages tst016@
.dis pages tst021@
.dis loc
.dis b
.dis scope
.dis stack
.rem
.rem Now help, version, and kind:
.rem
.help
.com
.ver
.kind 2/7
.kind 7
y
y
.rem
.rem Open, and some display of data:
.rem
.open tst021@
.dis scope
.dis stack
acolor
an_int
bool
x
ch
.rem Abort and continue, then resume display of data:
.abort
con
neg_arr1
neg_rec1
efg
set81
brecarr[3].f3
brecarr
.w brecarr[2];f4;f3;f2;f1
.w shortrec
f2
.w f2
f3
neg_rec1
neg_rec1.f1
neg_rec1.f1:o
neg_rec1.f1:h
.rem
.rem Try the where command:
.rem
.where acolor
.where neg_rec1
.where neg_rec1.f1
.where neg_rec1.f2
.rem
.rem restore scope to default
.rem
.o
.dis scope
.rem
.rem Now some stepping:
.rem
.dis loc
.s
.dis loc
.ss
.dis loc
.s 19
.dis loc
.ss
.dis stack
.dis scope
.rem
.rem put breakpoints at end of main, and in oof_son:
.rem
.b 2/95
.b 1/18 ".if level > 0 then level"
.dis b
.rem
.rem Proceed:
.rem
.p
.p 2
.rem
.rem Play with open of frames
.rem
.dis stack
.dis scope
level
.o 4
level
.dis scope
.o 3
level
.dis scope
.o
level
.rem
.rem Try assignment (which will fail):
.rem
level := level + 3
.p 3
.b 2/93
.p
.rem
.rem use .with some more, and try assignments:
.rem
.w oof_rec_ptr^
next^
.w next^
next^
next^.lhword := 44
next^.rhword := 444
next^
.o tst021@
x
x := 0.00012345678
x
x := 999999.8765432
x
set81
set81 := [1,3,5,7]
set81
set81 := [x]
.rem
.rem proceed to final breakpoint
.rem
.p
.dis b
.clear
y
.dis b
.rem
.rem Done.
.rem
.stop
    