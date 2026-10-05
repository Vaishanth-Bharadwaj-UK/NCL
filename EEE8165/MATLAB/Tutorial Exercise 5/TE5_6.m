%a

syms x1(t);

d2x1 = diff(x1,t,2);
dx1 = diff(x1,t);
ode_x1 = d2x1 + 5*dx1 + 6*x1;
sol_x1 = dsolve(ode_x1==0);
disp(sol_x1)

%b

syms x2(t);

d3x2 = diff(x2,t,3);
d2x2 = diff(x2,t,2);
dx2 = diff(x2,t);
ode_x2 = d3x2 + 6*d2x2 + 11*dx2 + 6*x2;
sol_x2 = dsolve(ode_x2==0,x2(0)==1,dx2(0)==0,d2x2(0)==0);
disp(sol_x2)

%(c)

odefun = @(t,x) -5*x + 6;
[t,xnum] = ode45(odefun,[0 2],1);
plot(t,xnum)