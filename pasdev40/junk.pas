program junk;

var
  case_number : integer;
  number_cases : integer;
  number_messages : integer;

begin
  number_cases := 5;
  for number_messages := 1 to 100 do begin
    case_number := ((time () + time()) mod number_cases) + 1;
    case case_number of
      01 : writeln (tty, 'Bunme!  Now!');
      02 : writeln (tty, 'We want a shrubbery!');
      03 : writeln (tty, 'There''s a penguin on the telly!');
      04 : writeln (tty, 'Your mother was a hamster, ',
			 'and your father smelt of elderberries!');
      05 : writeln (tty, 'He''s not the Messiah!  ',
			 'He''s a very, very bad boy!');
    end (* case *);
  end (* for *);
end.
    