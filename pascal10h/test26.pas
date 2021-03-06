program kushnir;

type
  certainchars =  'a' .. 'z';
  littlerange = 1 .. 10;
  bigrange = 1 .. 100000;
  formalparam = procedure (char);
  spectrum = (red, green, blue);

  ptr = ^rec;
  rec = packed record
    a, b: littlerange;
    next: ptr
    end;

procedure one (a: char);
begin tty^ := a end;

var
  formal: formalparam;
  formal2: procedure (char);
  little: littlerange;
  little2: 1 .. 10;
  head: ptr;
  lowercase: certainchars;
  rainbow: spectrum;
  decoratorcolors: (pink, chartreuse, mauve, fuschia, vomit);
  newhead: ^rec;
  newrec: record one, two: littlerange end;
  newptr: ^ record one, two, three: littlerange end;

begin
  head := nil;
  newhead := nil;
  newrec.one := 4; newptr := nil;
  newptr^.two := 4;
  with head^ do begin
    next := nil;
    b := 4
    end;
  formal := one;
  formal ('C');
  formal2 := one;
  formal2 ('C');
  one ('C');
  lowercase := lowercase;
  rainbow := green;
  decoratorcolors := pink
end.
  