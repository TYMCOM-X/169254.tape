module QLANG;
(*   +----------------------------------------------------------------+
     I                                                                I
     I                       QLANG                                    I
     I                                                                I
     +----------------------------------------------------------------+

     MDSI, COMPANY CONFIDENTIAL

     STARTED: 26 August 1982

     PURPOSE: The ANC people want the QED embedded in ANC to be able
              to put out prompts and error messages in languages other
              than English.  For each language to be used there are two
              files: a prompt file and an error message file.  There
              are relatively few prompts, and they should come up fast,
              so they are stored in an array of prompt_text.  The
              error messages are comparatively lengthy, and somewhat com-
              plex in arrangement, and the penalty of reading them
              from a file each time one is needed is not prohibitive.
              This routine takes two file name parameters, in the form
              of strings.  The first is the name of the appropriate
              prompt file.  This routine initializes the prompt array
              from the named file.  The second is the name of the error
	      message file.  This routine puts that name into a public
              variable, from which it can be retrieved when it is
              needed.  This routine indicates that it has been called
              by setting a public Boolean to TRUE.

     USAGE:
       QLANG (Prompt file name, error file name);

     RESPONSIBLE: Developement Software (or whatever they're calling it
                  this week).

     +---------------------------------------------------------------*)

public var
   prompt : array [qprompts] of prompt_text;
   errfilename : file_name;
   qlang_called : Boolean := false;

public procedure qlang (promptname : file_name; errname : file_name);

var
   promptfile : text;
   errorfile : text;
   idx : qprompts;

begin
reset (promptfile, promptname); 
if iostatus (promptfile) <> io_ok then
   begin
   ttwrite ('File ');
   ttwrite (promptname);
   ttwrite (' missing or access not allowed.');
   ttwtln;
   end
else
   begin
   for idx := minimum (qprompts) to maximum (qprompts) do
      begin
      if eof (promptfile) then
	 begin
	 ttwrite ('Not enough prompts in ');
         ttwrite (filename (promptfile));
	 ttwtln;
         stop;
	 end
      else
	 readln (promptfile, prompt [idx]);
      end;
   end;
close (promptfile);

reset (errorfile, errname); 
if iostatus (errorfile) <> io_ok then
   begin
   ttwrite ('File ');
   ttwrite (errname);
   ttwrite (' missing or access not allowed.');
   ttwtln;
   end
else
   errfilename := errname;
close (errorfile);
qlang_called := true
end.
  