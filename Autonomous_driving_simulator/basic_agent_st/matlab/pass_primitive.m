%% Passing primitive algorithm

function [m1, m2, t1, t2, v_min, v_max] = pass_primitive(a0,v0,sf,v_min,v_max,t_min,t_max)
    if a0 >= 0
        tv_min = finalOptTime(v0,a0,sf,v_min);
        tv_max = finalOptTime(v0,a0,sf,v_max);
    else
        t_bar = finalOptTimeVel(a0,sf);
        v_bar = finalOptVel(v0,a0,sf,t_bar);
        if (v_bar < v_min) && (v_min < v_max)
            tv_min = finalOptTime(v0,a0,sf,v_min);
            tv_max = finalOptTime(v0,a0,sf,v_max);
        else
            if (v_min < v_bar) && (v_bar < v_max)
                tv_min = t_bar;
                tv_max = finalOptTime(v0,a0,sf,v_max);
            else
                tv_min = 0.;
                tv_max = 0.;
            end
        end
    end
    if t_min == 0 && t_max == 0
        t1 = tv_max;
        t2 = tv_min;
    else
        t1 = max(tv_max,t_min);
        t2 = min(tv_min,t_max);  
    end
    if (0 < t1) && (t1 <= t2)
        v_min = finalOptVel(v0,a0,sf,t2);
        v_max = finalOptVel(v0,a0,sf,t1);
        m1 = evalPrimitiveCoeffs(v0,a0,sf,v_max,0,t1);
        m2 = evalPrimitiveCoeffs(v0,a0,sf,v_min,0,t2);
    else
        m1 = zeros(1,6);
        m2 = zeros(1,6);
        t1 = 0.;
        t2 = 0.;
        v_min = 0.;
        v_max = 0.;

    end