from math import sin, atan, fabs

def brake_model( reqBrakeTorque, omega_r, omega_l, max_brake_torque, params ):

    # ----------------------------------------------------------------
    ## Function purpose: compute braking torques at rear wheels with brake model
    # ----------------------------------------------------------------

    regularSignScale = params.braking_system.regularSignScale
    
    # Check that the braking torques have correctly been specified as
    # negative quantities. Otherwise, correct them by changing the sign
    if reqBrakeTorque > 0:
        reqBrakeTorque = - reqBrakeTorque
    
    # Check that the requested braking torque is lower than the one that
    # the hydraulic system can apply. 
    # Use regularized sign functions (sin(atan(.))) to make sure that the 
    # vehicle correctly stops at zero forward speed, to avoid that negative 
    # speed values could be reached during braking
    if fabs(reqBrakeTorque) <= fabs(max_brake_torque):
        Tw_r = reqBrakeTorque * sin( atan( omega_r / regularSignScale ) )
        Tw_l = reqBrakeTorque * sin( atan( omega_l / regularSignScale ) )
    else:
        Tw_r = -max_brake_torque * sin( atan( omega_r / regularSignScale ) )
        Tw_l = -max_brake_torque * sin( atan( omega_l / regularSignScale ) )

    return Tw_r, Tw_l