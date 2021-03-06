program inshis;

(*     Print histogram of instruction executions produced by ANCIH *)

type  (* An object module name *)
  modname = packed array [1..32] of char;

const
  blankname: modname := '                                ';
  bucketsize := 64;       (* number of bytes in a bucket *)

procedure lookup_module(bucketaddr: integer; var result: modname);

  (*     Given the first address of a bucket, find the last object module
	making a contribution to it by scanning the VAX Link map.
       Many pathological data references.      *)

  static var
    mapfile: text;  (* the link map file *)
    baseaddr: integer := -1;        (* the base address of the current module in the scan *)
    lastmod, modulename: modname := blankname;      (* the last and current module names *)

  var
    mapfilename: string;    (* the link map file name *)
    mapline: string[254];   (* a line read from the map file *)

begin
  if baseaddr = -1 then begin       (* if first call then ... *)
    write(tty, 'Map file: '); 
    break;        (* open the map file and find psect synopsis *)
    readln(tty); 
    read(tty, mapfilename);
    reset(mapfile, '.MAP ' || mapfilename);
    repeat
      readln(mapfile, mapline)
    until index(mapline, 'Program Section Synopsis') <> 0
  end;

  while baseaddr < bucketaddr + bucketsize do begin       (* scan until first module past this bucket *)
    lastmod := modulename;
    loop    (* scan for a module line *)
      readln(mapfile, mapline);
    exit if index(mapline, 'Symbols By Name') <> 0 do begin
							modulename := blankname;        (* nothing more, give up *)
							baseaddr := maximum(integer);
							close(mapfile)
						      end;
    exit if (length(mapline) >= 33) andif (mapline[33] = '0') do
      getstring(mapline, modulename:32, baseaddr:8:h)
    end
  end;
  result := lastmod (* the result is the last one, not current *)
end;

const
  nbuckets := 7168;       (* number of buckets *)
  hist_width := 60;       (* maximum histogram width *)
  starstring :=
    '************************************************************';

var
  outfile: text;  (* where to print the histogram *)
  outfilename: string;    (* its file name *)
  infile: text;   (* the input file of bucket counts *)
  hist_max, hist_delta, hist_total, i: integer;

  (* size of highest spike, size of each asterisk, total insts counted, counter *)

  hist: array [1..nbuckets] of integer;   (* the histogram*)
  nskips: integer;        (* number of entries to skip in printing *)
  mname: modname; (* object module name for this line of histogram *)

begin

  open(tty); 
  rewrite(tty);

  reset(infile, 'INSTRHIS.DAT');      (* initialize the input file *)

  (* read in histogram file, calculate statistics *)

  hist_max := 0;
  hist_total := 0;
  for i := 1 to nbuckets do begin
    readln(infile, hist[i]);
    hist_total := hist_total + hist[i];
    if hist[i] > hist_max then hist_max := hist[i]
  end;

  hist_delta := (hist_max + hist_width - 1) div hist_width;
  if hist_delta <= 0 then hist_delta := 1;

  (* establish output file *)

  loop
    write(tty, 'Output to: '); 
    break;
    readln(tty); 
    read(tty, outfilename);
    if outfilename = '' then outfile := ttyoutput
    else rewrite(outfile, '.LIS ' || outfilename);
  exit if eof(outfile);
    writeln(tty, 'Error.')
  end;

  (* write out heading of histogram *)

  writeln(outfile, 'Histogram of PC values at instruction termination:');
  writeln(outfile, nbuckets:0, ' buckets of', bucketsize, ' bytes each.');
  writeln(outfile, 'Total instruction executions =', hist_total);
  writeln(outfile, '    One unit =', hist_delta, ' instructions.');

  (* write out the histogram itself *)

  nskips := 0;
  for i := 1 to nbuckets do begin
    if nskips > 0 then nskips := nskips - 1;
    if nskips = 0 then begin
      while ((i + nskips) <= nbuckets) andif
		(hist[i + nskips] = 0) do nskips := nskips + 1;
      if nskips < 10 then begin
	nskips := 0;
	lookup_module((i-1)*bucketsize, mname);
	writeln(outfile, mname, (i-1)*bucketsize:8:h, '  ',
	  starstring:
	      ((hist[i] + hist_delta - 1) div hist_delta) )
      end
      else writeln(outfile,'. . . . . . . . . . . . . . .')
    end
  end
end.
  