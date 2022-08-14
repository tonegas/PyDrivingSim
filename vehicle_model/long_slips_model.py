from math import fabs

def long_slips_model(omega__rr, omega__rl, omega__fr, omega__fl, Omega, u, delta__fr, delta__fl, params):

    # ----------------------------------------------------------------
    ## Function purpose: compute steady-state longitudinal slips
    # ----------------------------------------------------------------
    
    Rr     = params.rear_wheel.R
    Rf     = params.front_wheel.R
    Wr     = params.vehicle.Wr  
    Wf     = params.vehicle.Wf     
    Lf     = params.vehicle.Lf 
    Vlow   = params.vehicle.Vlow_long
    
    # kappa_rr
    V_cx_rr = Omega*Wr/2 + u
    V_sx_rr = V_cx_rr - Rr*omega__rr
    if (max(fabs(V_cx_rr),fabs(omega__rr*Rr))>Vlow):
        kappa__rr_ss = -V_sx_rr/(max([fabs(V_cx_rr),fabs(omega__rr*Rr),fabs(V_sx_rr)]))
    else:
        # Low-speed case
        kappa__rr_ss = -(2*V_sx_rr/(Vlow + (max([fabs(V_cx_rr),fabs(omega__rr*Rr),fabs(V_sx_rr)])**2)/Vlow))
    
    
    # kappa_rl
    V_cx_rl = -Omega*Wr/2 + u
    V_sx_rl = V_cx_rl - Rr*omega__rl
    if (max(fabs(V_cx_rl),fabs(omega__rl*Rr))>Vlow):
        kappa__rl_ss = -V_sx_rl/(max([fabs(V_cx_rl),fabs(omega__rl*Rr),fabs(V_sx_rl)]))
    else:
        # Low-speed case
        kappa__rl_ss = -(2*V_sx_rl/(Vlow + (max([fabs(V_cx_rl),fabs(omega__rl*Rr),fabs(V_sx_rl)])**2)/Vlow))
    
    
    # kappa_fr
    V_cx_fr = 1/2*Omega*Wf + u + Lf*Omega*delta__fr
    V_sx_fr = V_cx_fr - Rf*omega__fr
    if (max(fabs(V_cx_fr),fabs(omega__fr*Rr))>Vlow):
        kappa__fr_ss = -V_sx_fr/(max([fabs(V_cx_fr),fabs(omega__fr*Rr),fabs(V_sx_fr)]))
    else:
        # Low-speed case
        kappa__fr_ss = -(2*V_sx_fr/(Vlow + (max([fabs(V_cx_fr),fabs(omega__fr*Rr),fabs(V_sx_fr)])**2)/Vlow))
    
    
    # kappa_fl
    V_cx_fl = -1/2*Omega*Wf + u + Lf*Omega*delta__fl
    V_sx_fl = V_cx_fl - Rf*omega__fl
    if (max(fabs(V_cx_fl),fabs(omega__fl*Rr))>Vlow):
        kappa__fl_ss = -V_sx_fl/(max([fabs(V_cx_fl),fabs(omega__fl*Rr),fabs(V_sx_fl)]))
    else:
        # Low-speed case
        kappa__fl_ss = -(2*V_sx_fl/(Vlow + (max([fabs(V_cx_fl),fabs(omega__fl*Rr),fabs(V_sx_fl)])**2)/Vlow))
    
    
    return kappa__rr_ss, kappa__rl_ss, kappa__fr_ss, kappa__fl_ss