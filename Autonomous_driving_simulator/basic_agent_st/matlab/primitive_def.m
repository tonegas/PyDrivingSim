%% Stopping primitive

% Find the optimal time solution
syms f;

Txf = 1./solve(subs(diff(totalCost(v0,a0,sf,0,0,T),T),T,1/f)==0,f);
finalOptTimeStop_fun = matlabFunction(Txf(1),'Vars',[v0,a0,sf],'File','finalOptTimeStop.m');

%% Passing primitive

% Find the optimal final velocity in terms of tf

vf_bar = solve(diff(totalCost(v0,a0,sf,vf,0,T),vf)==0,vf);
finalOptVel_fun = matlabFunction(vf_bar,'Vars',[v0,a0,sf,T],'File','finalOptVel.m');

% Find the optimal time to reach of vf
syms f;

T_vf = 1./solve(subs(vf_bar,T,1/f)==vf,f);
finalOptTime_fun = matlabFunction(T_vf(2),'Vars',[v0,a0,sf,vf],'File','finalOptTime.m');

% Find the optimal time to reach v_bar (minimal velocity) 

t_bar = solve(diff(finalOptVel(v0,a0,sf,T),T)==0,T);
finalOptTimeVel_fun = matlabFunction(t_bar(2),'Vars',[a0,sf],'File','finalOptTimeVel.m');
