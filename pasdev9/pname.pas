$options special, noch
$include pascal.inc
$include pasist.inc
$include pascv.inc
type caller = (ccenter, cleft, cright);
var fff: text;
public procedure nm_dump;
  type rptr = ^rec;
       rec = record
	 num: integer;
	 next: rptr
       end;
       str = packed array[1..20] of char;
  var i: integer;
      p: ^str;
      index, weight: integer;
      counter: integer;
      c,count: rptr;
      maxdepth: integer;
function count_names (n: nam; depth: integer): integer;
begin
  with n^ do begin
    weight := weight + depth;
    maxdepth := max (maxdepth, depth);
    if alink = nil then scopechain := ptr (0)
    else scopechain := ptr (count_names (alink, depth+1));
    if zlink = nil then self_nam := ptr (0)
    else self_nam := ptr (count_names (zlink, depth+1));
    count_names := 1 + ord (scopechain) + ord (self_nam);
  end;
end;
 procedure dmp (n: nam; depth: integer; calledfrom: caller; ctr: rptr);
 begin
   with n^, ctr^ do begin
     if next = nil then begin
	new (next);
	next^.num := 0;
	next^.next := nil;
     end;
     num := num + 1;
     p^[depth] := ' ';
     if calledfrom = cleft then p^[depth-1] := '|'
     else p^[depth-1] := ' ';
     if zlink <> nil then dmp (zlink, depth+2, cright, next);
     p^[depth] := '-';
     p^[depth-1] := '+';
     write (fff,substr (p^,1,depth),substr (text,1,len));
     write (fff,' (d=',cv_int (depth div 2));
     if ord (scopechain) <> 0 then
	write (fff,' l=',cv_int (ord (scopechain)));
     if ord (self_nam) <> 0 then
	write (fff,' r=',cv_int (ord (self_nam)));
     writeln (fff,')');
     if calledfrom = cright then p^[depth-1] := '|'
     else p^[depth-1] := ' ';
     p^[depth] := ' ';
     if alink <> nil then dmp (alink,depth+2,cleft,next);
    end;
  end;
begin
  rewrite (fff,'dump.lst');
  maxdepth := 0; weight := 0;
  counter := count_names(root_name,1);
  new (p: maxdepth);
  for i := 1 to maxdepth do p^[i] := ' ';
  maxdepth := maxdepth div 2;
  new (count);
  count^.num := 0;
  count^.next := nil;
  dmp (root_name, 2, ccenter, count);
  writeln (fff);
  writeln (fff,counter:4,' distinct names.');
  writeln (tty,counter:4,' distinct names.');
  writeln (fff); writeln (tty);
  writeln (tty,'Level     #     %');
  writeln (fff,'Level     #     %');
  index := 1;
  while count <> nil do with count^ do begin
   if num > 0 then begin
    writeln (tty,index:3,num:8,num*100/(2.0**(index-1)):10:4,'%');
    writeln (fff,index:3,num:8,num*100/(2.0**(index-1)):10:4,'%');
   end;
    c := next;
    dispose (count);
    count := c;
    index := index + 1;
  end;
  writeln (tty);
  writeln (fff);
  writeln (tty,'Average depth = ',weight/counter:7:2);
  writeln (fff,'Average depth = ',weight/counter:7:2);
  close (fff);
  break (tty);
  stop;
end.
    