from math import atan, fabs

def lat_slips_model(Omega, u, v, delta__fr, delta__fl, params):

    # ----------------------------------------------------------------
    ## Function purpose: compute steady-state lateral slips
    # ----------------------------------------------------------------
    
    Wr     = params.vehicle.Wr  
    Wf     = params.vehicle.Wf     
    Lr     = params.vehicle.Lr   
    Lf     = params.vehicle.Lf        
    Vlow   = params.vehicle.Vlow_lat
    
    # alpha_rr
    V_sy_rr = -Lr*Omega + v
    V_cx_rr = Omega*Wr/2 + u
    if (fabs(V_cx_rr) <= Vlow):
        alpha__rr_ss = -atan(2*V_sy_rr/(Vlow + (V_cx_rr**2)/Vlow))
    else:
        alpha__rr_ss = -atan(V_sy_rr/fabs(V_cx_rr))

    # alpha_rl
    V_sy_rl = -Lr*Omega + v
    V_cx_rl = -Omega*Wr/2 + u
    if (fabs(V_cx_rl) <= Vlow):
        alpha__rl_ss = -atan(2*V_sy_rl/(Vlow + (V_cx_rl**2)/Vlow))
    else:
        alpha__rl_ss = -atan(V_sy_rl/fabs(V_cx_rl))

    # alpha_fr
    V_sy_fr = Omega*Lf + v - ((Omega*Wf + 2*u)*delta__fr)/2
    V_cx_fr = 1/2*Omega*Wf + u + Lf*Omega*delta__fr
    if (fabs(V_cx_fr) <= Vlow):
        alpha__fr_ss = -atan(2*V_sy_fr/(Vlow + (V_cx_fr**2)/Vlow))
    else:
        alpha__fr_ss = -atan(V_sy_fr/fabs(V_cx_fr))

    # alpha_fl
    V_sy_fl = ((Omega*Wf - 2*u)*delta__fl)/2 + Omega*Lf + v
    V_cx_fl = -1/2*Omega*Wf + u + Lf*Omega*delta__fl
    if (fabs(V_cx_fl) <= Vlow):
        alpha__fl_ss = -atan(2*V_sy_fl/(Vlow + (V_cx_fl**2)/Vlow))
    else:
        alpha__fl_ss = -atan(V_sy_fl/fabs(V_cx_fl))
    
    
    return alpha__rr_ss, alpha__rl_ss, alpha__fr_ss, alpha__fl_ss

