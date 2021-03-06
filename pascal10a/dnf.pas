program dutch_national_flag;

type
  color = (red, white, blue);

var
  bucket: array[1..1000] of color;
  r, w, b: 0..1001;
  colr, colw: color;
  temp: color;


begin
  r := 1;
  w := 1000;
  b := 1000;

  while w >= r do begin
    colr := bucket [r];
    while (colr = red) and (w > r) do begin
      r := r + 1;
      colr := bucket [r];
    end;

    if r < w then begin
      colw := bucket [w];
      while (colw <> red) and (w > (r+1)) do begin
	if colw = blue then begin
	  temp := bucket [w]; 
	  bucket [w] := bucket [b]; 
	  bucket [b] := temp;
	  b := b - 1;
	end;
	w := w - 1;
	colw := bucket [w];
      end;

      if colw = blue then begin
	temp := bucket [w]; 
	bucket [w] := bucket [b]; 
	bucket [b] := temp;
	b := b - 1;
      end;
      if (colw = red) or (colr <> white) then begin
	temp := bucket [r]; 
	bucket [r] := bucket [w]; 
	bucket [w] := temp;
      end;
    end;

    if colr = blue then begin
      temp := bucket [w]; 
      bucket [w] := bucket [b]; 
      bucket [b] := temp;
      b := b - 1;
    end;

    r := r + 1;
    w := w - 1;
  end;
end.
 