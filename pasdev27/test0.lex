scanner test0;
alphabet is numeric;
a = 0;
b = 0 1;
c = 0 | 1;
d = 0 1 | 1 0;
e = 1 *;
f = 0 | 1 | 0 1 | 1 0;
a { x := y };
symbols {x = &1}
  foo = 0 | 1;
ignore 1 1 1 1 1;
end
    