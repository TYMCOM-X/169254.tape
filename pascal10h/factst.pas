module factst;

  public function fact (x: integer): integer;
   begin
    if x <= 1
      then fact := 1
      else fact := x * fact (x - 1)
   end.
  