program QUEUE;
(* QUEUE prints the contents of each file named in #####QUE.TMP, with the options specified,
   on the VAX line printer.  ##### is the last 5 digits of the current job number.  The 
   program calls the RDLIB routine, DO_CMD, which calls the VAX DCL command,
   PRINT.  The counterpart of this program, on the DEC-10, is 'SYS:QUEUE'.
*)



$INCLUDE docmd.inc
external function jobnum: string [8];

var Print_Arg: string [256];         (* Holds the name of the file to be printed, and the 
                                        print options *)
    Result:    boolean;              (* Returns true if the call to the print
                                        commmand is successful, false otherwise *)


begin
  reset (Input, substr (jobnum,4,5) || 'QUE.TMP');      (* file name is last 5 chars of 
                                                           the jobnum + QUE.TMP *)
 
  while not eof (Input) do begin
    read (Input, Print_Arg);
    readln (Input);

    Print_Arg := substr (Print_Arg, 6);      (* strip off 'LPT:=' *)
    Print_Arg := 'PRINT ' || Print_Arg;      (* attach PRINT command to file name and options *)

    DO_CMD (Print_Arg)
  end;
end.
    