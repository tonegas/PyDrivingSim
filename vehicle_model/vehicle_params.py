from dataclasses import dataclass
import math

# ----------------------------------------------------------------
## Function purpose: define a struct containing vehicle data.
#                    All parameters refer to the vehicle Chimera Evoluzione
# ----------------------------------------------------------------


# ----------------------------------------------------------------
#  ___                           _            ___       _
# / __|_  _ ____ __  ___ _ _  __(_)___ _ _   |   \ __ _| |_ __ _
# \__ \ || (_-< '_ \/ -_) ' \(_-< / _ \ ' \  | |) / _` |  _/ _` |
# |___/\_,_/__/ .__/\___|_||_/__/_\___/_||_| |___/\__,_|\__\__,_|
#             |_|
# ----------------------------------------------------------------

# SUSPENSIONS
@dataclass
class SuspensionData:
    Ks : float          = ((26000)**(-1) + (100*10**3)**(-1))**(-1) # [N/m] Suspension+tire
    Cs : float          = 2125                                  # [N*s/m] Suspension damping
    Cs_b : float        = 1750                                  # [N*s/m] Suspension damping bound
    Cs_r : float        = 2500                                  # [N*s/m] Suspension damping rebound
    Karb : float        = 0                                     # [Nm/rad] Anti-roll bar stiffness
    stroke : float      = 0.06                                  # [m] Maximum damper stroke
    K_es : float        = 50000                                 # [N/m] Damper's end-stops stiffness
    C_es : float        = 2000                                  # [N*s/m] Rear damper's end-stops damping
    h_rc : float        = 0.033                                 # [m] Rear roll center height
    z__rlx : float      = 0.175                                 # [m] Spring free length
    reg_fact : float    = 1e5                                   # [1/m] Regularized sign steepness factor (equal for front and rear)
    camber_gain: float  = 0.997836                              # [-] camber gain constant (linear fitting from suspension kinematic model)
    tau_N : float       = 0.06                                  # [s] time constant for the vertical loads dynamics

# ----------------------------------------------------------------
#   ___ _               _      ___       _
#  / __| |_  __ _ _____(_)___ |   \ __ _| |_ __ _
# | (__| ' \/ _` (_-<_-< (_-< | |) / _` |  _/ _` |
#  \___|_||_\__,_/__/__/_/__/ |___/\__,_|\__\__,_|
#
# ----------------------------------------------------------------

# CHASSIS (including all the sprung mass)
@dataclass
class ChassisData:
# Inertia tensor for the chassis
# is =  |  is_xx   0   -is_xz |
#       |    0   is_yy    0   |
#       | -is_xz   0    is_zz |
    is_xx : float       = 0.9*85                                # [kg*m^2] chassis moment of inertia about x axis
    is_yy : float       = 0.9*850                               # [kg*m^2] chassis moment of inertia about y axis
    is_zz : float       = 0.9*800                               # [kg*m^2] chassis moment of inertia about z axis
    is_xz : float       = 0.9*60                                # [kg*m^2] chassis product of inertia xz

# ----------------------------------------------------------------
#  _   _                                   ___       _
# | | | |_ _  ____ __ _ _ _  _ _ _  __ _  |   \ __ _| |_ __ _
# | |_| | ' \(_-< '_ \ '_| || | ' \/ _` | | |) / _` |  _/ _` |
#  \___/|_||_/__/ .__/_|  \_,_|_||_\__, | |___/\__,_|\__\__,_|
#               |_|                |___/
# ----------------------------------------------------------------

# UNSRPUNG BODY IS MADE OF 4 WHEELS, SUSPENSIONS, TRANSMISSION AND BRAKE MASSES
@dataclass
class WheelData:
# Inertia tensor of the wheel
# iwd = | iwd   0  0  |
#       |  0  iwa  0  |
#       |  0   0  iwd |
    R : float           = 0.203                                 # [m] Wheel Radius
    width : float       = 6*25.4*10**(-3)                       # [m] Wheel width
    mass : float        = 8                                     # [kg] Wheel mass
    iwd : float         = mass / 12 * (3 * R ** 2 + width ** 2) # [kg*m^2] Inertia of the wheel
    iwa : float         = 0.5                                   # [kg*m^2] Inertia of the whole wheel assembly
    static_camber :float= 1.5                                   # [deg] Static camber for rear wheels


# ----------------------------------------------------------------
#   _____                       _       _            ___       _
#  |_   _| _ __ _ _ _  ____ __ (_)_____(_)___ _ _   |   \ __ _| |_ __ _
#    | || '_/ _` | ' \(_-< '  \| (_-<_-< / _ \ ' \  | |) / _` |  _/ _` |
#    |_||_| \__,_|_||_/__/_|_|_|_/__/__/_\___/_||_| |___/\__,_|\__\__,_|
#
# ----------------------------------------------------------------

@dataclass
class TransmissionData:
    tau_red : float       = 52/15                                 # [-] Transmission ratio of the gearbox
    eff_red : float  = 0.93                                  # [-] Efficiency of the gearbox

# ----------------------------------------------------------------
#   ___ _               _             ___             ___       _
#  / __| |_ ___ ___ _ _(_)_ _  __ _  / __|_  _ ___   |   \ __ _| |_ __ _
#  \__ \  _/ -_) -_) '_| | ' \/ _` | \__ \ || (_-<_  | |) / _` |  _/ _` |
#  |___/\__\___\___|_| |_|_||_\__, | |___/\_, /__(_) |___/\__,_|\__\__,_|
#                             |___/       |__/
# ----------------------------------------------------------------
@dataclass
class SteeringSystemData:
    tau_D : float       = 10 #3.67                              # [-] Steering transmission ratio (pinion-rack)
    tau_H : float       = 0.03                                  # [s] Time constant for steering wheel dynamics

# # ----------------------------------------------------------------
#   ___          _   _             ___       _
#  | _ )_ _ __ _| |_(_)_ _  __ _  |   \ __ _| |_ __ _
#  | _ \ '_/ _` | / / | ' \/ _` | | |) / _` |  _/ _` |
#  |___/_| \__,_|_\_\_|_||_\__, | |___/\__,_|\__\__,_|
#                          |___/
# ----------------------------------------------------------------
# Braking system
@dataclass
class BrakingSystemData:
    max_brake_torque_front : float  = 600                       # [Nm] max front braking torque that the hydraulic system can provide
    max_brake_torque_rear : float   = 600                       # [Nm] max rear braking torque that the hydraulic system can provide
    brakeRatio : float              = 0.5                       # [-] front/rear brake circuits pressure distribution
    totBrakeTorque : float          = 750                       # [Nm] max total brake torque that the braking system can develop (it is then split btween front/rear axles)
    tau_br : float                  = 0.03                      # [s] time constant for brake actuation dynamics
    regularSignScale : float        = 1                         # [rad/s] scale parameter for the regularized sign function

# ----------------------------------------------------------------
#  __  __     _               ___
# |  \/  |___| |_  ___  _ _  |   \ __ _| |_ __ _
# | |\/| / _ |  _|/ _ \| '_| | |) / _` |  _/ _` |
# |_|  |_\___/\_ |\___/|_|   |___/\__,_|\__\__,_|
#
# ----------------------------------------------------------------

@dataclass
class MotorData:
# Electric motor parameters (motor model: Emrax 208, with Chimera Evoluzione powertrain)
    maxTorque : float               = 80                        # [Nm] max torque that the motor can provide
    speedForTorqueCut : float       = 4800                      # [rpm] motor rotational speed at which torque is decreased a lot
    maxRotSpeed : float             = 5200                      # [rpm] max rotational speed of the motor
    k_torque : float                = 0.83                      # [-] motor torque constant
    I_max : float                   = 100                       # [A] max motor current
    tau_mot : float                 = 0.03                      # [s] time constant for motor actuation dynamics
    tau_ped : float                 = 0.03                      # [s] time constant for pedal dynamics

# ----------------------------------------------------------------
#  ___       _   _                  ___       _
# | |)) __ _| |_| |_ ___ _ _ _  _  |   \ __ _| |_ __ _
# | |)\/ _` |  _|  _/ -_) '_| || | | |) / _` |  _/ _` |
# |___/\__,_|\__\\__\___|_|  \_, | |___/\__,_|\__\__,_|
#                            |__/ 
# ----------------------------------------------------------------
@dataclass
class AccumulatorData:
    maxPower : float                = 75                        # [kW] max output power for the battery pack


# ----------------------------------------------------------------
#    ___                   _ _  __   __   _    _    _       ___       _
#   / _ \__ _____ _ _ __ _| | | \ \ / /__| |_ (_)__| |___  |   \ __ _| |_ __ _
#  | (_) \ V / -_) '_/ _` | | |  \ V / -_) ' \| / _| / -_) | |) / _` |  _/ _` |
#   \___/ \_/\___|_| \__,_|_|_|   \_/\___|_||_|_\__|_\___| |___/\__,_|\__\__,_|
#
# ----------------------------------------------------------------

@dataclass
class VehicleData():
# VEHICLE
    Lf : float          = 0.904                                 # [m] Distance between vehicle CoM and front wheels axle
    Lr : float          = 0.636                                 # [m] Distance between vehicle CoM and front wheels axle
    L : float           = Lf + Lr                               # [m] Vehicle wheelbase
    hGs : float         = 0.30                                  # [m] CoM vertical position
    Wf : float          = 1.27                                  # [m] Front track width
    Wr : float          = 1.24                                  # [m] Rear track width
    lx : float          = 0.015                                 # [m] Tire relaxation length, for longitudinal slip dynamics (it was 0.3)
    ly : float          = 0.015                                 # [m] Tire relaxation length, for lateral slip dynamics (it was 0.3)
# Inertia and mass
    m : float           = 315                                   # [kg] Total mass of the vehicle + driver : float = 245 + 70 : float = 315 kg
    i_xx : float        = 85                                    # [kg*m^2] Moment of inertia of the vehicle w.r.t. x axis
    i_yy : float        = 850                                   # [kg*m^2] Moment of inertia of the vehicle w.r.t. y axis
    i_zz : float        = 800                                   # [kg*m^2] Moment of inertia of the vehicle w.r.t. z axis
    i_xz : float        = 200                                   # [kg*m^2] Product of inertia of the vehicle
# Areodynamics
    CAx : float         = 1.5563680                             # [N*s^2/m^2] Aero drag coefficient
    CAzf : float        = 0.6412236160                          # [N*s^2/m^2] Aero downforce coeff at front axle
    CAzr : float        = 0.9151443840                          # [N*s^2/m^2] Aero downforce coeff at rear axle
# Low velocity tire correction
    Vlow_long : float   = 4                                     # [m/s] speed threshold to use low-speed corrections in the tire longit slip and force models
    Vlow_lat : float    = 4                                     # [m/s] speed threshold to use low-speed corrections in the tire lateral slip and force models

# ----------------------------------------------------------------
#
# ██╗   ██╗███████╗██╗  ██╗██╗ ██████╗██╗     ███████╗
# ██║   ██║██╔════╝██║  ██║██║██╔════╝██║     ██╔════╝
# ██║   ██║█████╗  ███████║██║██║     ██║     █████╗
# ╚██╗ ██╔╝██╔══╝  ██╔══██║██║██║     ██║     ██╔══╝
#  ╚████╔╝ ███████╗██║  ██║██║╚██████╗███████╗███████╗
#   ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝╚══════╝
#
# ----------------------------------------------------------------

# Store all sub-structures of sub-systems data in vehicle structure
class VehicleParams():
    def __init__(self,
                 vehile = VehicleData(),
                 chassis = ChassisData(),
                 transmission = TransmissionData(),
                 steering_system = SteeringSystemData(),
                 braking_system = BrakingSystemData(),
                 motor = MotorData(),
                 accumulator = AccumulatorData(),
                 front_wheel = WheelData(static_camber = 3),
                 rear_wheel = WheelData(),
                 front_suspension = SuspensionData(
                    Ks = ((20000)**(-1) + (100*10**3)**(-1))**(-1),
                    Karb = 195.4*180/math.pi,
                    h_rc = 0.056
                 ),
                 rear_suspension = SuspensionData()
                 ):
        self.vehicle            = vehile
        self.chassis            = chassis
        self.transmission       = transmission
        self.steering_system    = steering_system
        self.braking_system     = braking_system
        self.motor              = motor
        self.accumulator        = accumulator
        self.rear_wheel         = rear_wheel
        self.front_wheel        = front_wheel
        self.front_suspension   = front_suspension
        self.rear_suspension    = rear_suspension
        self.front_unsprung_mass= front_wheel.mass * 2
        self.rear_unsprung_mass = rear_wheel.mass * 2
        self.sprung_mass        = vehile.m - front_wheel.mass * 2 - rear_wheel.mass * 2