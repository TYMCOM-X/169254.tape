PMF VERSION 1 LIB FILE
E
E
E
E
E
M           7         175 #CHANGE
)~A"),10,~A!#if ("#nec ("#prevmacro,change),$skip
$ind left 19
$par -19
CHANGES:
$skip
)
#assign (#prevmacro,change)$justify
$par -16
#setsubstr ("#setsubstr(\\\\\\\\\\\\\\\\,1,
E
E
E
E
E
E
M           5          44 #COPY
-1)))~A","#num(~A!&#copy (~A!,0),,~A"#if ("#len(
E
E
E
L           8           0 #SYSNAME

E
E
E
E
E
E
E
E
E
M           7          96 #DASHES
)~A!#substr (---------------------------------------------------------------------------------,1,
E
M           4          72 #END
#assign(#prevmacro,end)
$justify
$ind left 0
$skip
#dashes ("#hdrwidth)

E
E
M           7          96 #BLANKS
)~A!#substr (                                                                                 ,1,
E
E
E
E
E
E
M           7          55 #CENTER
)~A"))/2+1),~A")-#length(~A!,"#num("(#length(~A!#setsubstr(
E
E
E
E
M          10          76 #ALGORITHM
#assign(#prevmacro,algorithm)
$justify
$skip
$ind left 3
$par -3
ALGORITHM:\
E
M           7         507 #MODULE

$skip
$justify
$ind left 3
$par -3
PURPOSE:\~A"))))
|#blanks ("#hdrwidth-2)|
+#dashes ("#hdrwidth-2)+
$justify
$skip
MDSI, Company Confidential
#if ("#sysname,"$skip
SYSTEM:\ #sysname
)$skip
STARTED:\ ~A!))
#center ("|#blanks ("#hdrwidth-2)|,"#explode("#copy(-,"#length(~A!#assign(#prevmacro,module)
$number off
$margin 0
$length 0
$width #hdrwidth
$tabs 9,17,25,33,41,49,57,65,73,81,89
$top 0
$bottom 0
$verbatim
+#dashes ("#hdrwidth-2)+
|#blanks ("#hdrwidth-2)|
#center ("|#blanks ("#hdrwidth-2)|,"#explode(
E
E
E
E
E
E
E
L          10           4 #PREVMACRO
none
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
E
M          13          82 #REQUIREMENTS
#assign(#prevmacro,requirements)
$justify
$skip
$ind left 3
$par -3
REQUIREMENTS:\
E
E
E
E
E
M           7          21 #SYSTEM
)~A!#assign (#sysname,
E
M           6          75 #USAGE
#assign (#prevmacro,usage)
$skip
$ind left 3
$par -3
USAGE:
$skip
$verbatim
E
E
E
E
E
E
E
M          10          68 #SETSUBSTR
)))~A#+#length (~A","#num ("~A!&#substr (~A#-1))&~A",1,"#num (~A!#substr (
L           9           2 #HDRWIDTH
64
E
E
E
E
M           7         194 #OUTPUT
))),
$par
)~A!),12),#copy (\,"#num("12-#length(~A!&#if ("#ltn ("#length (~A!#if ("#nec ("#prevmacro,output),$skip
$ind left 15
$par -15
OUTPUT:
)
#assign (#prevmacro,output)$skip
$justify
$par -12

M           6          22 #WIDTH
)~A!#assign (#hdrwidth,
E
M           9         141 #EXTERNAL

~A!#if ("#nec ("#prevmacro,external),$skip
$ind left 15
$par -15
EXTERNAL REFERENCES:
$skip
)
#assign (#prevmacro,external)$justify
$par -12

E
M          12          76 #RESPONSIBLE

~A!#assign(#prevmacro,responsible)
$justify
$skip
$ind left 0
RESPONSIBLE:\ 
E
E
E
E
E
E
E
M           6          68 #NOTES
#assign(#prevmacro,notes)
$justify
$skip
$ind left 3
$par -3
NOTES:\
E
E
E
E
E
E
M           8          73 #EFFECTS
#assign (#prevmacro,effects)
$justify
$skip
$ind left 3
$par -3
EFFECTS:\
E
M           6         191 #INPUT
))),
$par
)~A!),12),#copy (\,"#num("12-#length(~A!&#if ("#ltn ("#length (~A!#if ("#nec ("#prevmacro,input),$skip
$ind left 15
$par -15
INPUT:
)
#assign (#prevmacro,input)$skip
$justify
$par -12

E
E
M           6         198 #ENTRY
))),
$par
)~A!),12),#copy (\,"#num("12-#length(~A!&#if ("#ltn ("#length (~A!#if ("#nec ("#prevmacro,entry),$skip
$ind left 15
$par -15
ENTRY POINTS:
)
#assign (#prevmacro,entry)$skip
$justify
$par -12

E
M           8         142 #INCLUDE

~A!#if ("#nec ("#prevmacro,include),$skip
$ind left 15
$par -15
INCLUDE FILES REQUIRED:
$skip
)
#assign (#prevmacro,include)$justify
$par -12

E
E
E
E
E
E
E
E
E
E
E
E
E
M           8          70 #EXPLODE
,2)))~A!,1,1)\#explode("#substr(~A!,#substr(~A!),1),~A!#if("#eqn("#length(
E
    