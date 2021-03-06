
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(*       This program tests update and seek.
        It  writes 15    records to a 'binary file' (file of * )
        and then reads them back in and compares what was read with
        what was written.  Program deviates if eof is encountered or 
        if any of the records read is different from what was written.
*)
program sui328;
const str_val : array[io_status] of string := ('io_ok',',io_novf',
        'io_povf', 'io_dgit', 'io_govf', 'io_intr', 'io_rewr',
        'io_eof', 'io_outf', 'io_inpf', 'io_seek', 'io_illc',
        'io_nepf', 'io_opnf');
      Max = 15;
type rec = record
        int : integer;
        rea : real;
        boo : boolean
     end;       
var f : file of *;
    r : rec;
    i : integer;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

    a : array[1 .. Max] of rec;
        
begin
        rewrite(output,'suite.txt',[preserve]);

        update(f,[seekok,retry]);
        for i := 1 to Max do begin
                with a[i] do begin
                        int := i;
                        rea := sqrt(i);
                        boo := (i mod 2 = 0)
                end;
                write(f,a[i])
        end;


        seek(f,1);
        if extent(f) <> Max*size(rec) then
                writeln('sui328 deviates (extent)');
        i := 1;

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

        loop
                read(f,r);
                exit if iostatus(f)<> io_ok do
                        writeln('sui328 deviates iostatus = ',
                                str_val[iostatus(f)]);
                exit if (r.int <> a[i].int) or (r.rea <> a[i].rea)
                        or (r.boo <> a[i].boo) do
                        writeln('sui328 deviates (update,seek,read or write error)');
                exit if i = Max do writeln('sui328 conforms');
                i := i + 1;
        end
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

 