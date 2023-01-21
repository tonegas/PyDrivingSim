import sys
from datetime import datetime
import ctypes as ct
import agent_interfaces_connector as agent

sys.path.append('../../out/python_interfaces')
import interfaces_python_data_structs as agent_interface

lib_file = "../../../bin/lib/libagent.dylib"
c = agent.AgentConnector(lib_file)

# Define types
type_integer_4 = ct.c_int32 * 4
type_integer_10 = ct.c_int32 * 10
type_integer_20 = ct.c_int32 * 20
type_double_10 = ct.c_double * 10
type_double_20 = ct.c_double * 20
type_double_100 = ct.c_double * 100

# Function to test if the library is loaded correctly
c.test_lib()

#Network Initialization
#IP = [0,0,0,0]      # Local usage
IP = [0,0,0,0]     # Remote usage
PORT = 30000         # Default port for agent
log_enable = False   # The log can be True only in local usage
type_of_log = 0      # Different level of log

# Function for agent initialization
c.client_agent_init_num(type_integer_4(*IP),PORT,log_enable,type_of_log)

# Define the structures
input_data_type = agent_interface.input_data_str
output_data_type = agent_interface.output_data_str
scenario_msg = input_data_type()
manoeuvre_msg = output_data_type()

# This is are test numbers
scenario_msg.ID = 1                             # integer - Is the scenario and 11 for the manoeuvre
scenario_msg.Status = 0                         # integer - Must be set to 0 for running 1 for closing
scenario_msg.Version = 1204                     # integer - Interface code 1204

# Ego vehicle dimensions
scenario_msg.VehicleLen = 5.0                   # double - lenght dimension [m]
scenario_msg.VehicleWidth = 2.0                 # double - width dimension [m]

# Packet information
scenario_msg.CycleNumber = 0                    # integer - Loop number, This is an increasing number
scenario_msg.AVItime = 0.0                      # double - Time of AVI video [s]
scenario_msg.ECUupTime = 0.0                    # double - Up time of sender unit [s]
scenario_msg.TimeStamp = 0.0                    # double - Absolute time of message data, UTC time difference after 1st January 1970, obtained from GPS time with leap seconds (Unix epoch) [s]

# Ego Requested velocity
scenario_msg.RequestedCruisingSpeed = 50.0      # double - requested cruising speed [m/s]
# Ego input
scenario_msg.SteerWhlAg = 0.0                   # double - Steering wheel angle, it is used to evaluate the sideslip [rad]
# State of the ego Vehicle
scenario_msg.VLgtFild = 15.0                    # double - velocity of the vehicle [m/s]
scenario_msg.ALgtFild = 0.0                     # double - Acc of the vehicle [m/s^2]
scenario_msg.ALatFild = 0.0                     # double - Lateral acceleration of the vehicle [m/s^2]
scenario_msg.YawRateFild = 0.0                  # double - Filtered yaw-rate [rad/s]
# agent Stimuli
scenario_msg.ObjContourPoint1X[0] = 0.0         # double - bias Longitudinale
scenario_msg.ObjContourPoint1X[1] = 0.0         # double - bias Laterale
# Ego Position
scenario_msg.CurrentLane = 2                    # integer - Nomenclature from ADASIS: 0 = Unknown, 1 = Emergency lane, 2 = Single-lane road, 3 = Left-most lane, 4 = Right-most lane, 5 = One of middle lanes on road with three or more lanes
scenario_msg.LaneHeading = 0.0                  # double - Relative heading of the vehicle with respect to the lane [rad]
scenario_msg.LatOffsLineL = 2.0                 # double - Lateral offset to the left lane line [m]
scenario_msg.LatOffsLineR = -2.0                # double - Lateral offset to the right lane line positive to the left [m]

# Road profile
scenario_msg.AdasisCurvatureNrP1 = 30           # integer - number of segment in CurvatureDist and CurvatureValues
scenario_msg.AdasisCurvatureDist = type_double_100(*[x*10.0-100.0 for x in range(100)])              # 100 double - Curvature distance [m]
scenario_msg.AdasisCurvatureValues = type_double_100(*[0.0 for x in range(100)])                     # 100 double - Curvature value, Positive for left curves [1/m]
scenario_msg.LaneCrvt = 0.0                     # double - Lane curvature [1/m]
scenario_msg.LaneWidth = 6.0                    # double - Ego lane width [m]
scenario_msg.LeftLineType = 1                   # integer - 0 = dashed, 1 = solid, 2 = undecided, 3 = road edge, 4 = double lane, 5 = botts dots, 6 = not visible, 7 = invalid
scenario_msg.RightLineType = 1                  # integer - 0 = dashed, 1 = solid, 2 = undecided, 3 = road edge, 4 = double lane, 5 = botts dots, 6 = not visible, 7 = invalid

# Speed limits
scenario_msg.AdasisSpeedLimitNrP1 = 0           # integer - Number of values in effective speed limit profile (main path)
scenario_msg.AdasisSpeedLimitDist = type_double_10(*[0.0 for x in range(10)])                       # 10 double - Speed limit distance [m]
scenario_msg.AdasisSpeedLimitValues = type_integer_10(*[0 for x in range(10)])                      # 10 integer - Speed limit value [km/h]

# Obstacles
scenario_msg.NrObjs = 0                                                 # integer - Total number of objects
scenario_msg.ObjSensorInfo = type_integer_20(*[0 for x in range(20)])   # integer 20 - Which sensor has detected the object (coded as bit, D=1 means sensor has detected)
scenario_msg.ObjID = type_integer_20(*[0 for x in range(20)])           # integer 20 - Track ID
scenario_msg.ObjClass = type_integer_20(*[0 for x in range(20)])        # integer 20 - Object class, includes vehicle type from communication
scenario_msg.ObjLen = type_double_20(*[0.0 for x in range(20)])         # double 20 - Object length Along object speed direction, along vehicle axis for stationary obstacles. 0 means unknown. [m]
scenario_msg.ObjWidth = type_double_20(*[0.0 for x in range(20)])       # double 20 - Object width Perpendicular to object speed direction, perpendicular to vehicle axis for stationary obstacles. 0 means unknown [m]
scenario_msg.ObjX = type_double_20(*[0.0 for x in range(20)])           # double 20 - X position relative to ego vehicle [m]
scenario_msg.ObjY = type_double_20(*[0.0 for x in range(20)])           # double 20 - Y position relative to ego vehicle [m]
scenario_msg.ObjCourse = type_double_20(*[0.0 for x in range(20)])      # double 20 - Orientation of the object speed vector. In vehicle reference system, positive to the left [rad]
scenario_msg.ObjVel = type_double_20(*[0.0 for x in range(20)])         # double 20 - Object speed (absolute) [m/s]
scenario_msg.ObjAcc = type_double_20(*[0.0 for x in range(20)])         # double 20 - Derivative of object speed (absolute),Tangential acceleration [m/s^2]
scenario_msg.ObjCourseRate = type_double_20(*[0.0 for x in range(20)])  # double 20 - Derivative of object course angle [rad/s]

# Traffic light
scenario_msg.NrTrfLights = 0                        # integer - 1 if there is a traffic light Only first traffic ligh is described if available
scenario_msg.TrfLightDist = -1.0                    # double - negative there is no traffic light [m]
scenario_msg.TrfLightCurrState = 0                  # integer - 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing
scenario_msg.TrfLightFirstNextState = 0             # integer - 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing
scenario_msg.TrfLightSecondNextState = 0            # integer - 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing
scenario_msg.TrfLightFirstTimeToChange = 0.0        # double - Time to first change of state [s]
scenario_msg.TrfLightSecondTimeToChange = 0.0       # double - Time to second change of state [s]
scenario_msg.TrfLightThirdTimeToChange = 0.0        # double - Time to third change of state [s]

# Create the pointer for the function call
scenario_msg_pointer = ct.pointer(scenario_msg)
manoeuvre_msg_pointer = ct.pointer(manoeuvre_msg)

start = datetime.now()
# Loop
for i in range(5):
    scenario_msg.CycleNumber = i
    scenario_msg.TimeStamp = ct.c_double(datetime.timestamp(datetime.now()))
    delta_time = datetime.now()-start
    scenario_msg.ECUupTime = ct.c_double(delta_time.total_seconds())
    # Function call agent compute
    c.client_agent_compute(scenario_msg_pointer,manoeuvre_msg_pointer)
    print("ID = " + str(manoeuvre_msg.ID))
    print("Version = " + str(manoeuvre_msg.Version))
    print("agentVersion = " + str(manoeuvre_msg.agentVersion))
    print("Inizializated = " + str(manoeuvre_msg.agentParamInt3))
    print("CycleNumber = " + str(manoeuvre_msg.CycleNumber))
    print("AVItime = " + str(manoeuvre_msg.AVItime))
    print("ECUupTime = " + str(manoeuvre_msg.ECUupTime))
    print("TimeStamp = " + str(manoeuvre_msg.TimeStamp))
    print("Status = " + str(manoeuvre_msg.Status))

    # Decided trajectory
    print("Long manoeuvre 1 - type = " + str(manoeuvre_msg.FirstManoeuverTypeLong))
    print("T0 = " + str(manoeuvre_msg.T0))
    print("V0 = " + str(manoeuvre_msg.V0) + " A0 = " + str(manoeuvre_msg.A0) + " J0 = " + str(manoeuvre_msg.J0) + " S0 = " + str(manoeuvre_msg.S0) + " Cr0 = " + str(manoeuvre_msg.Cr0) + " T1 = " + str(manoeuvre_msg.T1))
    print("Lat manoeuvre 1 - type = " + str(manoeuvre_msg.FirstManoeuverTypeLat))
    print("Sn0 = " + str(manoeuvre_msg.Sn0) + " Alpha0 = " + str(manoeuvre_msg.Alpha0) + " Delta0 = " + str(manoeuvre_msg.Delta0) + " Jdelta0 = " + str(manoeuvre_msg.Jdelta0) + " Sdelta0 = " + str(manoeuvre_msg.Sdelta0) + " Crdelta0 = " + str(manoeuvre_msg.Crdelta0) + " T1n = " + str(manoeuvre_msg.T1n))
    print("Lateral Positions = " + str([manoeuvre_msg.LateralPositions[i] for i in range(40)]))
    print("Relative Heading = " + str([manoeuvre_msg.RelativeHeading[i] for i in range(40)]))
    print("TargetEgoSpeed = " + str(manoeuvre_msg.TargetEgoSpeed))
    print("TargetEgoLongitudinalAcceleration = " + str(manoeuvre_msg.TargetEgoLongitudinalAcceleration))

    # Second manoeuvre
    #manoeuvre_msg.Jdelta1
    #manoeuvre_msg.Sdelta1
    #manoeuvre_msg.Crdelta1
    #manoeuvre_msg.T2n

    print("Network safety velocity = " + str(manoeuvre_msg.TargetDistance))                             # Velocity set by the neural network for pedestrian saferyprint("Network safety velocity:" + str(manoeuvre_msg.TargetDistance)) # Velocity set by the neural network for pedestrian safery
    print("Eavluation Metrics = " + str([manoeuvre_msg.ArcStartAbscissa[i] for i in range(30)])) # Score obtained

    # Number of Trajectory points
    print("NTrajectoryPoints = " + str(manoeuvre_msg.NTrajectoryPoints))
    print("TrajectoryPointITime = " + str([manoeuvre_msg.TrajectoryPointITime[i] for i in range(23)]))
    print("TrajectoryPointIX = " + str([manoeuvre_msg.TrajectoryPointIX[i] for i in range(23)]))
    print("TrajectoryPointIY = " + str([manoeuvre_msg.TrajectoryPointIY[i] for i in range(23)]))

# Close the connection and the log files
c.client_agent_close()

# Not used Scenario - LRM
# scenario_msg.LastPredLaneNr
# scenario_msg.NrLaneConnectivity
# scenario_msg.ConnectingPathId
# scenario_msg.LaneConnectivityDist
# scenario_msg.FirstPredLaneNr
# scenario_msg.LastPredLaneSideOffset
# scenario_msg.FirstPredLaneSideOffset
# scenario_msg.NrPedCross
# scenario_msg.PedCrossDist
# scenario_msg.PredLanesPathId
# scenario_msg.NrStubs
# scenario_msg.StubDist
# scenario_msg.TurnAngle
# scenario_msg.StubNrLanesDrivingDirection
# scenario_msg.StubNrLanesOppositeDirection
# scenario_msg.SuccLaneNr
# scenario_msg.SuccLanePathId
# scenario_msg.RightOfWay

# Not used manoeuvre
# Set to zero
# manoeuvre_msg.agentParamInt2
# manoeuvre_msg.agentParamInt3
# manoeuvre_msg.agentParamInt4
# manoeuvre_msg.agentParamInt5
# manoeuvre_msg.agentParamDouble1
# manoeuvre_msg.agentParamDouble2
# manoeuvre_msg.agentParamDouble3
# manoeuvre_msg.agentParamDouble4
# manoeuvre_msg.agentParamDouble5
# manoeuvre_msg.TargetID
# manoeuvre_msg.TargetClass
# manoeuvre_msg.TargetSensorInformation
# manoeuvre_msg.TargetX
# manoeuvre_msg.TargetY
# manoeuvre_msg.TargetWidth
# manoeuvre_msg.TargetLength
# manoeuvre_msg.TargetSpeed
# manoeuvre_msg.TargetCourse
# manoeuvre_msg.TargetAcceleration
# manoeuvre_msg.TargetCourseRate
# manoeuvre_msg.TargetDrivingMode
#
# manoeuvre_msg.TimeHeadwayPolicy
# manoeuvre_msg.LegalSpeedPolicy
# manoeuvre_msg.LegalSpeedLimit
#
# manoeuvre_msg.LandmarkPolicy
# manoeuvre_msg.LandmarkType
#
# manoeuvre_msg.AccelerationPolicyForCurve
#
# manoeuvre_msg.RearTimeHeadwayPolicyLeft
# manoeuvre_msg.RearTimeHeadwayPolicyRight
# manoeuvre_msg.LeftThreatType
# manoeuvre_msg.RightThreatType
# manoeuvre_msg.LeftLanePolicy
# manoeuvre_msg.RightLanePolicy
#
# manoeuvre_msg.TravelTimePolicy
#
# manoeuvre_msg.RecommendedGear
#
# manoeuvre_msg.T2
# manoeuvre_msg.J1
# manoeuvre_msg.S1
# manoeuvre_msg.Cr1
#
# manoeuvre_msg.NrArcs
# manoeuvre_msg.ArcCurvature
#
# manoeuvre_msg.LateralPositionTimeInterval
# manoeuvre_msg.TargetEgoDistanceToPreceedingVehicle