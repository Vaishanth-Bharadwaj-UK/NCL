syms x;
f = x^2 - 5*x + 6;
%disp(factor(f))
solx = solve(f==0,x);
disp(solx)