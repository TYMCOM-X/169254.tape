program rnf5 options nocheck;

(*  This program tests parameter list allocation within a quick block.  *)

type dreal = 0..1 prec 16;

const a : dreal = 0.1;
      b : dreal = 0.2;

function f12 ( x : integer ) : integer;
var y : dreal;
begin
  f12 := trunc ( x*a + y/b );
end;

function f11 ( x : integer ) : integer;
var y : dreal;
begin
  f11 := trunc ( x*a + y/b );
end;

function f10 ( x : integer ) : integer;
var y : dreal;
begin
  f10 := trunc ( x*a + y/b + f12 (x) );
end;

function f9 ( x : integer ) : integer;
var y : dreal;
begin
  f9 := trunc ( x*a + y/b + f11 (x) + f12 (x) );
end;

function f8 ( x : integer ) : integer;
var y : dreal;
begin
  f8 := trunc ( x*a + y/b + f11 (x) );
end;

function f7 ( x : integer ) : integer;
var y : dreal;
begin
  f7 := trunc ( x*a + y/b );
end;

function f6 ( x : integer ) : integer;
var y : dreal;
begin
  f6 := trunc ( x*a + y/b );
end;

function f5 ( x : integer ) : integer;
var y : dreal;
begin
  f5 := trunc ( x*a + y/b );
end;

function f4 ( x : integer ) : integer;
var y : dreal;
begin
  f4 := trunc ( x*a + y/b + f9 (x) + f10 (x) );
end;

function f3 ( x : integer ) : integer;
var y : dreal;
begin
  f3 := trunc ( x*a + y/b + f7 (x) + f8 (x) );
end;

function f2 ( x : integer ) : integer;
var y : dreal;
begin
  f2 := trunc ( x*a + y/b + f5 (x) + f6 (x) );
end;

function f1 ( x : integer ) : integer;
var y : dreal;
begin
  f1 := trunc ( x*a + y/b + f1 (x) + f2 (x) + f3 (x) + f4 (x) );
end;

var y, z : integer;

begin
  y := trunc ( f1 (z) );
end.
   