%% Generation of stop primitive j0 = 0

% Find the final position function of the initial jerk j0 = 0

sf_j0 = simplify(solve(j_opt(0,v0,a0,sf,0,0,T)==0,sf));
finalOptPosj0_fun = matlabFunction(sf_j0,'Vars',[v0,a0,T],'File','finalOptPosj0.m');

% Find the optimal time

Tsf_j0 = solve(finalOptTimeStop(v0,a0,finalOptPosj0(v0,a0,T)) == T,T);
finalOptTimeStopj0_fun = matlabFunction(Tsf_j0(2),'Vars',[v0,a0],'File','finalOptTimeStopj0.m');

%% Generation of pass primitive j0 = 0

% Find the final velocity function of the initial jerk j0 = 0

vf_j0 = simplify(solve(j_opt(0,v0,a0,sf,vf,0,T)==0,vf));
finalOptVelj0_fun = matlabFunction(vf_j0,'Vars',[v0,a0,sf,T],'File','finalOptVelj0.m');

% Find the optimal time in terms of vf_j0
syms j0;

Tvf_j0 = simplify(1./solve(subs(finalOptTime(v0,a0,sf,finalOptVelj0(v0,a0,sf,T)),T,1/j0) == 1/j0,j0));
finalOptTimej0_fun = matlabFunction(Tvf_j0,'Vars',[v0,a0,sf],'File','finalOptTimej0.m');
