	% File for interfaces
	% WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
	% Originf file: interfaces_v1.2.csv
	% Origin CRC32: 4097400712

	      in_struct.ID = int32(zeros(1,1));
in_struct.Version = int32(zeros(1,1));
in_struct.CycleNumber = int32(zeros(1,1));
in_struct.ECUupTime = double(zeros(1,1));
in_struct.Status = int32(zeros(1,1));
in_struct.VLgtFild = double(zeros(1,1));
in_struct.ALgtFild = double(zeros(1,1));
in_struct.YawRateFild = double(zeros(1,1));
in_struct.SteerWhlAg = double(zeros(1,1));
in_struct.VehicleLen = double(zeros(1,1));
in_struct.VehicleWidth = double(zeros(1,1));
in_struct.RequestedCruisingSpeed = double(zeros(1,1));
in_struct.AutomationLevel = int32(zeros(1,1));
in_struct.CurrentLane = int32(zeros(1,1));
in_struct.NrObjs = int32(zeros(1,1));
in_struct.ObjID = int32(zeros(20,1));
in_struct.ObjX = double(zeros(20,1));
in_struct.ObjY = double(zeros(20,1));
in_struct.ObjLen = double(zeros(20,1));
in_struct.ObjWidth = double(zeros(20,1));
in_struct.ObjVel = double(zeros(20,1));
in_struct.ObjCourse = double(zeros(20,1));
in_struct.LaneWidth = double(zeros(1,1));
in_struct.LatOffsLineR = double(zeros(1,1));
in_struct.LatOffsLineL = double(zeros(1,1));
in_struct.LaneHeading = double(zeros(1,1));
in_struct.LaneCrvt = double(zeros(1,1));
in_struct.AdasisCurvatureNr = int32(zeros(1,1));
in_struct.AdasisCurvatureDist = double(zeros(100,1));
in_struct.AdasisCurvatureValues = double(zeros(100,1));
in_struct.AdasisSpeedLimitNr = int32(zeros(1,1));
in_struct.AdasisSpeedLimitDist = double(zeros(10,1));
in_struct.AdasisSpeedLimitValues = int32(zeros(10,1));
in_struct.NrTrfLights = int32(zeros(1,1));
in_struct.TrfLightDist = double(zeros(1,1));
in_struct.TrfLightCurrState = int32(zeros(1,1));
in_struct.TrfLightFirstTimeToChange = double(zeros(1,1));
in_struct.TrfLightFirstNextState = int32(zeros(1,1));
in_struct.TrfLightSecondTimeToChange = double(zeros(1,1));
in_struct.TrfLightSecondNextState = int32(zeros(1,1));
in_struct.TrfLightThirdTimeToChange = double(zeros(1,1));


	      out_struct.ID = int32(zeros(1,1));
out_struct.Version = int32(zeros(1,1));
out_struct.CycleNumber = int32(zeros(1,1));
out_struct.ECUupTime = double(zeros(1,1));
out_struct.Status = int32(zeros(1,1));
out_struct.NTrajectoryPoints = int32(zeros(1,1));
out_struct.TrajectoryPointITime = double(zeros(23,1));
out_struct.TrajectoryPointIX = double(zeros(23,1));
out_struct.TrajectoryPointIY = double(zeros(23,1));
out_struct.TargetSpeed = double(zeros(1,1));
out_struct.RequestedAcc = double(zeros(1,1));
out_struct.ManoeuverType = int32(zeros(1,1));
out_struct.RequestedSteerWhlAg = double(zeros(1,1));

