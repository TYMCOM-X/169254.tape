program test options dump;
type
    iptr = ^ integer;
    bptr = ^ boolean;
    cptr = ^ char;

var
    ip: iptr;
    bp: bptr;
    cp: cptr;
     p:  ptr;

    procedure foo ( i: iptr; j: ptr; var k: ptr );
    begin
    end;

begin
  ip := ip;
  ip := bp;
  ip :=  p;
  ip := iptr(ip^);
  ip := iptr(cp^);
  ip := iptr(cp);
  ip := ptr(5);
  ip := ptr(ord(cp^));
  ip := ptr(bp);

  foo (ip,bp,cp);
  foo (p,ip,bp);
  foo (bp,cp,ip);

  ip^ := p^;
  cp^ := nil^;
end.
 