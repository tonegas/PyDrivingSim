clear
close all
clc

%% Plant equations

% Create symbolic scalar variables
% [s(t), v(t), a(t)]: longitudinal vehicle model
% [l1(t), l2(t), l3(t)]: Lagrangian multipliers

syms s(t) v(t) a(t) u(t) l1(t) l2(t) l3(t);

% Create ode equations
ode1 = diff(s) == v;
ode2 = diff(v) == a;
ode3 = diff(a) == u;

%% Cost function inside the integral

% Lagrangian cost function in order to minimize the jerks
L = u^2;

%% Definition of the Hamiltonian

H = L + l1*rhs(ode1) + l2*rhs(ode2) + l3*rhs(ode3);

%% Co-state euqations

Dl1 = diff(l1,t) == -functionalDerivative(H,s);
Dl2 = diff(l2,t) == -functionalDerivative(H,v);
Dl3 = diff(l3,t) == -functionalDerivative(H,a);

%% Solve the Hamiltonian for control u

du = functionalDerivative(H,u);
syms opt_u;
opt_u = solve(subs(du,u(t),opt_u) == 0, opt_u);

%% Substitute u to state equation

ode3s = diff(a) == subs(rhs(ode3), u, opt_u);

%% Boundary conditions

% Initial conditions
ICs = 's(0) = 0, v(0) = v0, a(0) = a0';

% Final conditions 
FCs = 's(T) = sf, v(T) = vf, a(T) = af';

% Convert symbolic objects to strings for using 'dsolve'

%% Solution of the optimal control problem

sol_opt = dsolve([ode1,ode2,ode3s,Dl1,Dl2,Dl3],ICs,FCs);

disp('Optimal polynomial longitudinal position:');
pretty(sol_opt.s)

disp('Optimal polynomial velocity:');
pretty(sol_opt.v)

disp('Optimal polynomial acceleration:');
pretty(sol_opt.a)

%% Assign to functions

% obtain optimal control
sol_opt.j = subs(opt_u,l3(t),sol_opt.l3);

syms t v0 a0 sf vf af T

s_opt_fun = matlabFunction(sol_opt.s,'Vars',[t,v0,a0,sf,vf,af,T],'File','s_opt.m');
v_opt_fun = matlabFunction(sol_opt.v,'Vars',[t,v0,a0,sf,vf,af,T],'File','v_opt.m');
a_opt_fun = matlabFunction(sol_opt.a,'Vars',[t,v0,a0,sf,vf,af,T],'File','a_opt.m');
j_opt_fun = matlabFunction(sol_opt.j,'Vars',[t,v0,a0,sf,vf,af,T],'File','j_opt.m');

% remmeber to add codegen if you want to manually generate C++ code

%% Coefficient list export function

% the coeffs are moltiplied by [1,2,6,24,120] to obtain the value of c1,
% c2, c3, c4, c5

m = [0, coeffs(sol_opt.s,t) .* [1, 2, 6, 24, 120]];
evalPrimitiveCoeffs_fun = matlabFunction(m,'Vars',[v0,a0,sf,vf,af,T],'File','evalPrimitiveCoeffs.m');

%% Total cost function

cost = simplify(int(sol_opt.j.^2,t,[0 T]));
totalCost_fun = matlabFunction(cost,'Vars',[v0,a0,sf,vf,af,T],'File','totalCost.m');
