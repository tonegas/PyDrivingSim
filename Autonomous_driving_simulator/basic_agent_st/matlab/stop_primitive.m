%% Stopping primitive algorithm

function [m, tf, smax] = stop_primitive(v0,a0,sf)
    if (v0 <= 0) || (sf == 0)
        tf = 0.;
        smax = 0.;
        m = zeros(1,6);
    else
        if 4*v0.^2 + 5*a0*sf < 0
            smax = -((4*v0^2)/(5*a0));
            tf = (10*smax)/(2*v0);
        else                                                                     
            smax = sf;
            tf = finalOptTimeStop(v0,a0,smax);
        end
        m = evalPrimitiveCoeffs(v0,a0,smax,0.,0.,tf);
    end