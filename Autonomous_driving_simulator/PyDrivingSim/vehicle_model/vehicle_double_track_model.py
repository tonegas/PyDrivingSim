from math import sin, cos, fabs, tanh
import numpy as np

from vehicle_model.motor_model import motor_model
from vehicle_model.brake_model import brake_model
from vehicle_model.camber_model import camber_model
from vehicle_model.perfect_ackermann_model import perfect_ackermann_model
from vehicle_model.areo_model import areo_model
from vehicle_model.pacejka_model import pacejka_model
from vehicle_model.load_transfer_model import load_transfer_model
from vehicle_model.lat_slips_model import lat_slips_model
from vehicle_model.long_slips_model import long_slips_model

# ----------------------------------------------------------------
## AUXILIARY FUNCTIONS
# ----------------------------------------------------------------

def posPart(x):
    # Regularized positive part
    regFactor = 0.01
    y = x*(tanh(x/regFactor)+1)/2
    return y

def negPart(x):
    # Regularized negative part
    regFactor = 0.01
    y = x*(tanh(x/regFactor)-1)/2
    return y

def vehicle_double_track_model(dX_prev, X, pedal_req, delta_req, pacejka_data, vehicle_data):

    # ----------------------------------------------------------------
    ## Double Track Vehicle Model of Formula SAE electric vehicle (Chimera Evoluzione)
    #  authors:  Gastone Pietro Papini Rosati & (matlab version of Mattia Piccinini)
    #  email:  mattia.piccinini@unitn.it
    #  date:   13/10/2020
    # ----------------------------------------------------------------

    # ----------------------------------------------------------------
    ## INPUTS OF THE MODEL
    # ----------------------------------------------------------------

    # Model inputs are:
    #       - requested pedal (throttle if >0, brake if <0)
    #       - requested steering angle at the steering wheel delta_req (in [rad])

    # ----------------------------------------------------------------
    ## OUTPUTS OF THE MODEL
    # ----------------------------------------------------------------

    # The outputs of the model are the derivatives of all vehicle states,
    # collected in the dX vector, as well as some other useful extra parameters
    # to describe vehicle behavior, saved in the extra_params vector

    # ----------------------------------------------------------------
    ## STATES OF THE MODEL
    # ----------------------------------------------------------------

    g         = 9.81       # [m/s^2] acc. of gravity

    x         = X[0]       # [m] x-coord of the vehicle CoM
    y         = X[1]       # [m] y-coord of the vehicle CoM
    psi       = X[2]       # [rad] yaw angle
    u         = X[3]       # [m/s] vehicle longitudinal speed
    v         = X[4]       # [m/s] vehicle lateral speed
    Omega     = X[5]       # [rad/s] yaw rate
    Fz__rr    = X[6]       # [N] vertical force for the rear right wheel
    Fz__rl    = X[7]       # [N] vertical force for the rear left wheel
    Fz__fr    = X[8]       # [N] vertical force for the front right wheel
    Fz__fl    = X[9]       # [N] vertical force for the front left wheel
    delta     = X[10]      # [rad] steering angle [at the wheel]
    omega__rr = X[11]      # [rad/s] rotational speed rear right wheel
    omega__rl = X[12]      # [rad/s] rotational speed rear left wheel
    omega__fr = X[13]      # [rad/s] rotational speed front right wheel
    omega__fl = X[14]      # [rad/s] rotational speed front left wheel
    alpha__rr = X[15]      # [rad] side slip angle rear right wheel
    alpha__rl = X[16]      # [rad] side slip angle rear left wheel
    alpha__fr = X[17]      # [rad] side slip angle front right wheel
    alpha__fl = X[18]      # [rad] side slip angle front left wheel
    kappa__rr = X[19]      # [-] longitudinal slip rear right wheel
    kappa__rl = X[20]      # [-] longitudinal slip rear left wheel
    kappa__fr = X[21]      # [-] longitudinal slip front right wheel
    kappa__fl = X[22]      # [-] longitudinal slip front left wheel
    ped       = X[23]      # [-] pedal

    # ----------------------------------------------------------------
    ## VEHICLE DATA
    # ----------------------------------------------------------------
    m      = vehicle_data.vehicle.m
    Lf     = vehicle_data.vehicle.Lf
    Lr     = vehicle_data.vehicle.Lr
    Wf     = vehicle_data.vehicle.Wf
    Wr     = vehicle_data.vehicle.Wr
    izz    = vehicle_data.vehicle.i_zz
    tau__Nf = vehicle_data.front_suspension.tau_N
    tau__Nr = vehicle_data.rear_suspension.tau_N
    tau__D = vehicle_data.steering_system.tau_D
    tau__H = vehicle_data.steering_system.tau_H
    ly     = vehicle_data.vehicle.ly
    lx     = vehicle_data.vehicle.lx
    iwa__r = vehicle_data.rear_wheel.iwa
    iwa__f = vehicle_data.front_wheel.iwa
    Rr     = vehicle_data.rear_wheel.R
    Rf     = vehicle_data.front_wheel.R
    tau_ped = vehicle_data.motor.tau_ped
    Vlow = vehicle_data.vehicle.Vlow_long

    # ----------------------------------------------------------------
    ## AUXILIARY MODELS
    # ----------------------------------------------------------------
    # ----------------------
    ## MOTOR MODEL
    # ----------------------
    # Driving torques at the wheels
    Tm_req = posPart(ped) * vehicle_data.motor.maxTorque
    Tw__rr_traction = motor_model( Tm_req, omega__rr, vehicle_data)
    Tw__rl_traction = motor_model( Tm_req, omega__rl, vehicle_data)

    # ----------------------
    # BRAKE MODEL
    # ----------------------
    Tb_r_req = -negPart(ped) * vehicle_data.braking_system.totBrakeTorque * ( 1 - vehicle_data.braking_system.brakeRatio)
    Tb_f_req = -negPart(ped) * vehicle_data.braking_system.totBrakeTorque * vehicle_data.braking_system.brakeRatio
    # Rear wheels braking model
    max_brake_torque_rear = vehicle_data.braking_system.max_brake_torque_rear
    Tw__rr_brake , Tw__rl_brake = brake_model( Tb_r_req, omega__rr, omega__rl, max_brake_torque_rear, vehicle_data)
    # Front wheels braking model
    max_brake_torque_front = vehicle_data.braking_system.max_brake_torque_front
    Tw__fr_brake , Tw__fl_brake = brake_model( Tb_f_req, omega__fr, omega__fl, max_brake_torque_front, vehicle_data)

    # ----------------------
    # WHEEL TORQUES
    # ----------------------
    # The total torque for each wheel is the algebraic sum of motor and brake torques
    Tw__rr = Tw__rr_traction + Tw__rr_brake
    Tw__rl = Tw__rl_traction + Tw__rl_brake
    Tw__fr = Tw__fr_brake
    Tw__fl = Tw__fl_brake

    # ----------------------
    # CAMBER MODEL
    # ----------------------
    gamma__rr, gamma__rl, gamma__fr, gamma__fl = camber_model(vehicle_data)

    # ----------------------
    # ACKERMANN STEERING MODEL
    # ----------------------
    # Compute steering angles for front wheels, with perfect Ackerman steering model
    delta__fr, delta__fl = perfect_ackermann_model(delta, vehicle_data)

    # ----------------------
    # AERODYNAMIC MODEL
    # ----------------------
    # Aero drag, downforce at rear axle, downforce at front axle
    FAxc, FAz__r, FAz__f = areo_model(u, vehicle_data)

    # ----------------------
    # TIRE PACEJKA MODEL
    # ----------------------
    # Ensure symmetric behavior of left and right tires by calculating the
    # forces and moments for left tires via a previous change of sign of the
    # side slip alpha and the camber gamma
    Fx__rr, Fy__rr, AM__rr = pacejka_model(kappa__rr, Fz__rr, alpha__rr, gamma__rr, pacejka_data)
    Fx__rl, Fy__rl, AM__rl = pacejka_model(kappa__rl, Fz__rl, -alpha__rl, -gamma__rl, pacejka_data)
    Fx__fr, Fy__fr, AM__fr = pacejka_model(kappa__fr, Fz__fr,alpha__fr, gamma__fr, pacejka_data)
    Fx__fl, Fy__fl, AM__fl = pacejka_model(kappa__fl, Fz__fl, -alpha__fl, -gamma__fl, pacejka_data)
    # Now perform a second change of sign in order to restore the correct operating conditions
    Fy__rl = -Fy__rl
    AM__rl = -AM__rl
    Fy__fl = -Fy__fl
    AM__fl = -AM__fl

    # ----------------------
    # VERTICAL TIRE FORCES MODEL
    # ----------------------
    # Compute vertical tire loads
    u_dot = dX_prev[3]
    Fz__rr__ss,  Fz__rl__ss, Fz__fr__ss, Fz__fl__ss = load_transfer_model(g, Omega, u, u_dot,
                                                                          FAz__r, FAz__f,
                                                                          AM__rr, AM__rl, AM__fr, AM__fl,
                                                                          vehicle_data)

    # ----------------------
    # AXLE FORCES
    # ----------------------
    Fx__r = Fx__rr + Fx__rl
    Fx__f = Fx__fl - sin(delta__fl)*Fy__fl + Fx__fr - sin(delta__fr)*Fy__fr
    Fy__r = Fy__rl + Fy__rr
    Fy__f = sin(delta__fl)*Fx__fl + Fy__fl + sin(delta__fr)*Fx__fr + Fy__fr
    Delta__Fx__r = (Fx__rr-Fx__rl)/2
    Delta__Fx__f = ((Fx__fr - sin(delta__fr)*Fy__fr) - (Fx__fl - sin(delta__fl)*Fy__fl))/2

    # ----------------------
    # STEADY STATE SLIPS
    # ----------------------
    kappa__rr__ss, kappa__rl__ss, kappa__fr__ss, kappa__fl__ss = long_slips_model(omega__rr, omega__rl, omega__fr, omega__fl,
                                                                                      Omega, u, delta__fr, delta__fl, vehicle_data)
    alpha__rr__ss, alpha__rl__ss, alpha__fr__ss, alpha__fl__ss = lat_slips_model(Omega, u, v, delta__fr, delta__fl, vehicle_data)

    
    # ----------------------------------------------------------------
    ## VEHICLE MODEL DIFFERENTIAL EQUATIONS
    # ----------------------------------------------------------------
    
    # The following system of ODE is imported from Maple symbolic model
    
    # Evolution of vehicle pose
    x_dot        = u*cos(psi) - v*sin(psi)
    y_dot        = v*cos(psi) + u*sin(psi)
    psi_dot      = Omega
    # Newton equations
    u_Dot        = (Omega * m * v - FAxc + Fx__f + Fx__r) / m
    v_Dot        = (-Omega * m * u + Fy__f + Fy__r) / m
    # Euler equation
    Omega_Dot    = (Lf * Fy__f - Lr * Fy__r + Wf * Delta__Fx__f + Wr * Delta__Fx__r + AM__fl + AM__fr + AM__rl + AM__rr) / izz
    # Vertical loads first order dynamics
    Fz_rr_Dot    = (-Fz__rr + Fz__rr__ss) / tau__Nr
    Fz_rl_Dot    = (-Fz__rl + Fz__rl__ss) / tau__Nr
    Fz_fr_Dot    = (-Fz__fr + Fz__fr__ss) / tau__Nf
    Fz_fl_Dot    = (-Fz__fl + Fz__fl__ss) / tau__Nf
    # Steering wheel first order dynamics
    delta_Dot    = (-delta * tau__D + delta_req) / tau__D / tau__H
    # Side slip angle first order dynamics
    alpha_rr_Dot = -(alpha__rr - alpha__rr__ss) / ly
    alpha_rl_Dot = -(alpha__rl - alpha__rl__ss) / ly
    alpha_fr_Dot = -(alpha__fr - alpha__fr__ss) / ly
    alpha_fl_Dot = -(alpha__fl - alpha__fl__ss) / ly
    # Longitudinal slip first order dynamics
    kappa_rr_Dot = -(kappa__rr - kappa__rr__ss) / lx
    kappa_rl_Dot = -(kappa__rl - kappa__rl__ss) / lx
    kappa_fr_Dot = -(kappa__fr - kappa__fr__ss) / lx
    kappa_fl_Dot = -(kappa__fl - kappa__fl__ss) / lx
    # Wheel spin dynamics
    omega_rr_Dot = (-Fx__rr * Rr + Tw__rr) / iwa__r
    omega_rl_Dot = (-Fx__rl * Rr + Tw__rl) / iwa__r
    omega_fr_Dot = (-Fx__fr * Rf + Tw__fr) / iwa__f
    omega_fl_Dot = (-Fx__fl * Rf + Tw__fl) / iwa__f
    # pedal dynamics
    ped_Dot      = (pedal_req - ped) / tau_ped

    # Empty output vectors are here initialized
    dX = np.zeros(24)
    extra_params = np.zeros(22)

    # Collect states derivatives in the dX vector
    dX[0]  = x_dot
    dX[1]  = y_dot
    dX[2]  = psi_dot
    dX[3]  = u_Dot
    dX[4]  = v_Dot
    dX[5]  = Omega_Dot
    dX[6]  = Fz_rr_Dot
    dX[7]  = Fz_rl_Dot
    dX[8]  = Fz_fr_Dot
    dX[9] = Fz_fl_Dot
    dX[10] = delta_Dot
    dX[11] = omega_rr_Dot
    dX[12] = omega_rl_Dot
    dX[13] = omega_fr_Dot
    dX[14] = omega_fl_Dot
    dX[15] = alpha_rr_Dot
    dX[16] = alpha_rl_Dot
    dX[17] = alpha_fr_Dot
    dX[18] = alpha_fl_Dot
    dX[19] = kappa_rr_Dot
    dX[20] = kappa_rl_Dot
    dX[21] = kappa_fr_Dot
    dX[22] = kappa_fl_Dot
    dX[23] = ped_Dot

    # ----------------------------------------------------------------
    ## SAVE USEFUL EXTRA PARAMETERS
    # ----------------------------------------------------------------
    
    extra_params[0]  = Tw__rr
    extra_params[1]  = Tw__rl
    extra_params[2]  = Tw__fr
    extra_params[3]  = Tw__fl
    extra_params[4]  = Fx__rr
    extra_params[5]  = Fx__rl
    extra_params[6]  = Fx__fr
    extra_params[7]  = Fx__fl
    extra_params[8]  = Fy__rr
    extra_params[9]  = Fy__rl
    extra_params[10] = Fy__fr
    extra_params[11] = Fy__fl
    extra_params[12] = AM__rr
    extra_params[13] = AM__rl
    extra_params[14] = AM__fr
    extra_params[15] = AM__fl
    extra_params[16] = gamma__rr
    extra_params[17] = gamma__rl
    extra_params[18] = gamma__fr
    extra_params[19] = gamma__fl
    extra_params[20] = delta__fr
    extra_params[21] = delta__fl

    return dX, extra_params