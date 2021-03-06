program erastosthenes;

$OPTIONS storage = 10000

$INCLUDE corout.inc

var n: 1..1000;
    sieve: environment;
    stk_avl: 0..10000;

procedure sieve_proc;
var prime: 1..1000;
    sieve: environment;
begin
  detach;
  prime := n;
  write (tty, prime:8);
  stk_avl := stk_avl - 50;
  sieve := create (sieve_proc, stk_avl);
  loop
    detach;
    if n mod prime <> 0 then call (sieve);
  end;
end;

begin
  rewrite (tty);
  n := 2;
  stk_avl := 9000;
  sieve := create (sieve_proc, stk_avl);
  for n := 2 to 1000 do call (sieve);
end.
    