program lngth;

(* Test program to see how much space is allocated for a variable of
   type qbuffer. *)

var
   bufpt : ^qbuffer;

begin
new (bufpt);
end.
   