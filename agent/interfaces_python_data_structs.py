# File for interfaces
# WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
# Originf file: interfaces_v1.2.csv
# Origin CRC32: 4097400712

import ctypes as ct

class input_data_str(ct.Structure):
    _pack_ = 1
    _fields_=[
        ("ID", ct.c_int32),
		("Version", ct.c_int32),
		("CycleNumber", ct.c_int32),
		("ECUupTime", ct.c_double),
		("Status", ct.c_int32),
		("VLgtFild", ct.c_double),
		("ALgtFild", ct.c_double),
		("YawRateFild", ct.c_double),
		("SteerWhlAg", ct.c_double),
		("VehicleLen", ct.c_double),
		("VehicleWidth", ct.c_double),
		("RequestedCruisingSpeed", ct.c_double),
		("AutomationLevel", ct.c_int32),
		("CurrentLane", ct.c_int32),
		("NrObjs", ct.c_int32),
		("ObjID", ct.c_int32*20),
		("ObjX", ct.c_double*20),
		("ObjY", ct.c_double*20),
		("ObjLen", ct.c_double*20),
		("ObjWidth", ct.c_double*20),
		("ObjVel", ct.c_double*20),
		("ObjCourse", ct.c_double*20),
		("LaneWidth", ct.c_double),
		("LatOffsLineR", ct.c_double),
		("LatOffsLineL", ct.c_double),
		("LaneHeading", ct.c_double),
		("LaneCrvt", ct.c_double),
		("AdasisCurvatureNr", ct.c_int32),
		("AdasisCurvatureDist", ct.c_double*100),
		("AdasisCurvatureValues", ct.c_double*100),
		("AdasisSpeedLimitNr", ct.c_int32),
		("AdasisSpeedLimitDist", ct.c_double*10),
		("AdasisSpeedLimitValues", ct.c_int32*10),
		("NrTrfLights", ct.c_int32),
		("TrfLightDist", ct.c_double),
		("TrfLightCurrState", ct.c_int32),
		("TrfLightFirstTimeToChange", ct.c_double),
		("TrfLightFirstNextState", ct.c_int32),
		("TrfLightSecondTimeToChange", ct.c_double),
		("TrfLightSecondNextState", ct.c_int32),
		("TrfLightThirdTimeToChange", ct.c_double)
	]
class output_data_str(ct.Structure):
    _pack_ = 1
    _fields_=[
        ("ID", ct.c_int32),
		("Version", ct.c_int32),
		("CycleNumber", ct.c_int32),
		("ECUupTime", ct.c_double),
		("Status", ct.c_int32),
		("NTrajectoryPoints", ct.c_int32),
		("TrajectoryPointITime", ct.c_double*23),
		("TrajectoryPointIX", ct.c_double*23),
		("TrajectoryPointIY", ct.c_double*23),
		("TargetSpeed", ct.c_double),
		("RequestedAcc", ct.c_double),
		("ManoeuverType", ct.c_int32),
		("RequestedSteerWhlAg", ct.c_double)
	]
