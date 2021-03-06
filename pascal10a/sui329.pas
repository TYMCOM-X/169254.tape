
(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

(*       This program test seek and update.  It first writes 15 integers
        to a  'file of integer' and then reads them back in and compares
        what was read with what was written.  The program deviates if eof
        is encountered or if any of the integers read is different from
        what was written.
*)
program sui329;

const str_val : array[io_status] of string := ('io_ok',',io_novf',
        'io_povf', 'io_dgit', 'io_govf', 'io_intr', 'io_rewr',
        'io_eof', 'io_outf', 'io_inpf', 'io_seek', 'io_illc',
        'io_nepf', 'io_opnf');
      Max = 15;

var f : file of integer;
    i, j : integer;
        
begin
        rewrite(output,'suite.txt',[preserve]);


(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

        update(f,[seekok,retry]);
        for i := 1 to Max do
                write(f,i);

        if extent(f) <> Max then
                writeln('sui329 deviates (extent)');
        i := 1;
        seek(f,i);      (*move cursor to beginning of file*)
        loop
                read(f,j);
                exit if iostatus(f)<> io_ok do
                        writeln('sui329 deviates iostatus = ',
                                str_val[iostatus(f)]);
                exit if (i <> j) do
                        writeln('sui329 deviates (read or write error)');
                exit if i = Max do writeln('sui329 conforms');
                i := i + 1;
        end
end.

(****           (c) 1981 Strategic Information                  ****)
(****           division of Ziff Davis Publishing Co.           ****)

   