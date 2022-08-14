def load_transfer_model(g, Omega, u, u__dot, FAz__r, FAz__f, AM__rr, AM__rl, AM__fr, AM__fl, params):

    # ----------------------------------------------------------------
    ## Function purpose: compute vertical loads for the 4 wheels 
    # ----------------------------------------------------------------

    # Extract the vehicle data
    Ks__r = params.rear_suspension.Ks
    Ks__f = params.front_suspension.Ks
    hrr   = params.rear_suspension.h_rc
    hrf   = params.front_suspension.h_rc
    hG    = params.vehicle.hGs
    Lr = params.vehicle.Lr
    Lf = params.vehicle.Lf
    Wr = params.vehicle.Wr
    Wf = params.vehicle.Wf
    m  = params.vehicle.m
    hr = hrf + ( hrr - hrf ) * Lf / ( Lr + Lf )  # [m] height from ground of the projection of the CoM G on the roll axis
    hs = hG - hr

    # Compute the steady-state vertical loads
    Fz__rr = (((Lf + Lr) * Wr * (Ks__f + Ks__r) * FAz__r + 2 * ((hrr * Lf + hs * (Lf + Lr)) * Ks__r + hrr * Ks__f * Lf) * m * Omega * u + (2 * hrr * AM__fl + 2 * hrr * AM__fr + 2 * hrr * AM__rl + 2 * hrr * AM__rr + Wr * m * (g * Lf + hG * u__dot)) * (Ks__f + Ks__r)) / (Lf + Lr) / Wr / (Ks__f + Ks__r)) / 0.2e1
    Fz__rl = (((Lf + Lr) * Wr * (Ks__f + Ks__r) * FAz__r - 2 * ((hrr * Lf + hs * (Lf + Lr)) * Ks__r + hrr * Ks__f * Lf) * m * Omega * u + (Ks__f + Ks__r) * (-2 * hrr * AM__fl - 2 * hrr * AM__fr - 2 * hrr * AM__rl - 2 * hrr * AM__rr + Wr * m * (g * Lf + hG * u__dot))) / (Lf + Lr) / Wr / (Ks__f + Ks__r)) / 0.2e1
    Fz__fr = (((Lf + Lr) * Wf * (Ks__f + Ks__r) * FAz__f + 2 * m * ((hrf * Lr + hs * (Lf + Lr)) * Ks__f + hrf * Ks__r * Lr) * Omega * u + (-2 * hrf * AM__fl - 2 * hrf * AM__fr - 2 * hrf * AM__rl - 2 * hrf * AM__rr + Wf * m * (g * Lr - hG * u__dot)) * (Ks__f + Ks__r)) / (Lf + Lr) / Wf / (Ks__f + Ks__r)) / 0.2e1
    Fz__fl = (((Lf + Lr) * Wf * (Ks__f + Ks__r) * FAz__f - 2 * m * ((hrf * Lr + hs * (Lf + Lr)) * Ks__f + hrf * Ks__r * Lr) * Omega * u + (Ks__f + Ks__r) * (2 * hrf * AM__fl + 2 * hrf * AM__fr + 2 * hrf * AM__rl + 2 * hrf * AM__rr + Wf * m * (g * Lr - hG * u__dot))) / (Lf + Lr) / Wf / (Ks__f + Ks__r)) / 0.2e1

    if Fz__rr >= 0:
        Fz_rr_ss = Fz__rr
    else:
        Fz_rr_ss = 0

    if Fz__rl >= 0:
        Fz_rl_ss = Fz__rl
    else:
        Fz_rl_ss = 0

    if Fz__fr >= 0:
        Fz_fr_ss = Fz__fr
    else:
        Fz_fr_ss = 0

    if Fz__fl >= 0:
        Fz_fl_ss = Fz__fl
    else:
        Fz_fl_ss = 0

    return Fz_rr_ss, Fz_rl_ss, Fz_fr_ss, Fz_fl_ss

