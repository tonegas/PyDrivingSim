%% Stopping primitive algorithm with j0 = 0

function [m, T, smax] = stop_primitivej0(v0,a0)
    if (v0 > 0) && (a0 < 0)
        T = finalOptTimeStopj0(v0,a0);
        smax = finalOptPosj0(v0,a0,T);
        m = evalPrimitiveCoeffs(v0,a0,smax,0.,0.,T);
    else
        T = 0.;
        smax = 0.;
        m = zeros(1,6);
    end