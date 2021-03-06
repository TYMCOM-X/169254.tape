program paint;
  
type
  double = minimum (real)..maximum (real) prec 16;
  
const
  tank: double = 113750.0;
  daily_feed: double = 5128.8;
  
var
  day: 1..1000;
  lbs_old, lbs_new,
  daily_old, daily_new: double;
  
begin
  rewrite (ttyoutput);
  page (ttyoutput);
  writeln (ttyoutput, '     tank size:  ', round (tank, -1):11:1);
  writeln (ttyoutput, '     daily feed: ', round (daily_feed, -1):11:1);
  writeln (ttyoutput);
  writeln (ttyoutput);
  writeln (ttyoutput, '                     removed              tank after feeding');
  writeln (ttyoutput, '      day        old         new           old         new        % new');
  writeln (ttyoutput, '      ---    --------    --------      --------    --------       -----');
  
  lbs_old := tank;
  lbs_new := 0.0;
  
  for day := 1 to 1000 do begin
    daily_old := daily_feed * (lbs_old / tank);
    daily_new := daily_feed * (lbs_new / tank);
    lbs_old := lbs_old - daily_old;
    lbs_new := lbs_new - daily_new + daily_feed;
  
    writeln (ttyoutput, day:9, round (daily_old, -1):12:1, round (daily_new, -1):12:1,
                       round (lbs_old, -1):14:1, round (lbs_new, -1):12:1,
		       round ((lbs_new / tank) * 100.0, -3):12:3);
  end;
end.
   