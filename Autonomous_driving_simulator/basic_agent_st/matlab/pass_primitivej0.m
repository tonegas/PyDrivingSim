%% Passing primitive algorithm with j0 = 0

function [m, tfj0, vfj0] = pass_primitivej0(v0,a0,sf,v_min,v_max)
    T_bar = finalOptTimej0(v0,a0,sf);
    vfj0 = finalOptVelj0(v0,a0,sf,T_bar(1));
    if (v_min < vfj0) && (vfj0 < v_max)
        tfj0 = T_bar(1);
        m = evalPrimitiveCoeffs(v0,a0,sf,vfj0,0,tfj0);
    else
        vfj0 = finalOptVelj0(v0,a0,sf,T_bar(2));
        if (v_min < vfj0) && (vfj0 < v_max)
            tfj0 = T_bar(2);
            m = evalPrimitiveCoeffs(v0,a0,sf,vfj0,0,tfj0);
        else
            m = zeros(1,6);
            tfj0 = 0.;
            vfj0 = 0.;
        end
    end