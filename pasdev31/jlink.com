do link
/verbosity:long
@test

do link
/verbosity:long
/require:(new.,wrtpc.,die.,dspos.,sz.ovl)
@testma

do filex
testma.exe=testma.hgh


   