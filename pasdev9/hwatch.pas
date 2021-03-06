module heapwatch options nocheck, notrace, special;

public var hfile: text;

public const hpatch: array[1..100] of integer := (
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );

public procedure hinit;

begin
  rewrite (hfile, 'hwatch.ls');
  writeln (hfile,'OPERATION   SIZE    ADDRESS     CALLER');
  writeln (hfile,'---------   ----    -------     ------');
  break (hfile);
end;

public procedure hnew (loc, pc: integer);

var
  p: ^ integer;

begin
  p := ptr (loc-4);
  writeln (hfile,'NEW        ',p^:5,'    ',loc:8:h,'    ',pc:8:h);;
  break (hfile);
end;

public procedure hdispose (loc, pc: integer);

var
  p: ^ integer;

begin
  p := ptr (loc-4);
  writeln (hfile,'DISPOSE    ',p^:5,'    ',loc:8:h,'    ',pc:8:h);
  break (hfile);
end.
  