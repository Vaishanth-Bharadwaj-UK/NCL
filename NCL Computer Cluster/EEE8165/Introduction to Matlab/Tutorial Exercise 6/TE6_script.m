syms x(t);

dx = diff(x,t);
xsol = dsolve(dx + 2*x == 4, x(0) == 0.5);
disp(xsol)
n=0:0.01:5;
plot(n,subs(xsol,t,n))

%For Simulink
% dx/dt = -2x + 4 --> Test: x(0) = 0.5 and x(0) = 3