(* ::Package:: *)

(* ::Section:: *)
(* Interfaces File for Mathematica *)

(* ::Text:: *)
(* WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT *)
(* Originf file: interfaces_v1.2.csv *)
(* Origin CRC32: 4097400712 *)

(* ::Subsection:: *)
(* Crc code *)
CRC32 := 4097400712;
(* ::Section:: *)
(* Interfaces In *)
(* ::Subsection:: *)
(* Global Variable Input Fields *)

Declare[Integer[43] InputIntegerFields = 0];
Declare[Real[347] InputRealFields = 0];
(* ::Subsection::Closed:: *)
(* Definition of InputDataExternal function *)
InputDataExternal[Integer id_] -> {Integer[43], Real[347]} := ExternalProcedure[];
(* ::Subsection::Closed:: *)
(* Integer input fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions integer fields *)

setIDIn[Integer field_] -> {} := InputIntegerFields[[1]] = field;
setVersionIn[Integer field_] -> {} := InputIntegerFields[[2]] = field;
setCycleNumberIn[Integer field_] -> {} := InputIntegerFields[[3]] = field;
setStatusIn[Integer field_] -> {} := InputIntegerFields[[4]] = field;
setAutomationLevelIn[Integer field_] -> {} := InputIntegerFields[[5]] = field;
setCurrentLaneIn[Integer field_] -> {} := InputIntegerFields[[6]] = field;
setNrObjsIn[Integer field_] -> {} := InputIntegerFields[[7]] = field;
setObjIDIn[Integer[20] field_] -> {} := InputIntegerFields[[8;;27]] = field;
setAdasisCurvatureNrIn[Integer field_] -> {} := InputIntegerFields[[28]] = field;
setAdasisSpeedLimitNrIn[Integer field_] -> {} := InputIntegerFields[[29]] = field;
setAdasisSpeedLimitValuesIn[Integer[10] field_] -> {} := InputIntegerFields[[30;;39]] = field;
setNrTrfLightsIn[Integer field_] -> {} := InputIntegerFields[[40]] = field;
setTrfLightCurrStateIn[Integer field_] -> {} := InputIntegerFields[[41]] = field;
setTrfLightFirstNextStateIn[Integer field_] -> {} := InputIntegerFields[[42]] = field;
setTrfLightSecondNextStateIn[Integer field_] -> {} := InputIntegerFields[[43]] = field;
(* ::Subsubsection::Closed:: *)
(* Get functions integer fields *)

getID[] -> {Integer} := InputIntegerFields[[1]];
getVersion[] -> {Integer} := InputIntegerFields[[2]];
getCycleNumber[] -> {Integer} := InputIntegerFields[[3]];
getStatus[] -> {Integer} := InputIntegerFields[[4]];
getAutomationLevel[] -> {Integer} := InputIntegerFields[[5]];
getCurrentLane[] -> {Integer} := InputIntegerFields[[6]];
getNrObjs[] -> {Integer} := InputIntegerFields[[7]];
getObjID[] -> {Integer[20]} := InputIntegerFields[[8;;27]];
getAdasisCurvatureNr[] -> {Integer} := InputIntegerFields[[28]];
getAdasisSpeedLimitNr[] -> {Integer} := InputIntegerFields[[29]];
getAdasisSpeedLimitValues[] -> {Integer[10]} := InputIntegerFields[[30;;39]];
getNrTrfLights[] -> {Integer} := InputIntegerFields[[40]];
getTrfLightCurrState[] -> {Integer} := InputIntegerFields[[41]];
getTrfLightFirstNextState[] -> {Integer} := InputIntegerFields[[42]];
getTrfLightSecondNextState[] -> {Integer} := InputIntegerFields[[43]];
(* ::Subsection::Closed:: *)
(* Real input fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions real fields *)

setECUupTimeIn[Real field_] -> {} := InputRealFields[[1]] = field;
setVLgtFildIn[Real field_] -> {} := InputRealFields[[2]] = field;
setALgtFildIn[Real field_] -> {} := InputRealFields[[3]] = field;
setYawRateFildIn[Real field_] -> {} := InputRealFields[[4]] = field;
setSteerWhlAgIn[Real field_] -> {} := InputRealFields[[5]] = field;
setVehicleLenIn[Real field_] -> {} := InputRealFields[[6]] = field;
setVehicleWidthIn[Real field_] -> {} := InputRealFields[[7]] = field;
setRequestedCruisingSpeedIn[Real field_] -> {} := InputRealFields[[8]] = field;
setObjXIn[Real[20] field_] -> {} := InputRealFields[[9;;28]] = field;
setObjYIn[Real[20] field_] -> {} := InputRealFields[[29;;48]] = field;
setObjLenIn[Real[20] field_] -> {} := InputRealFields[[49;;68]] = field;
setObjWidthIn[Real[20] field_] -> {} := InputRealFields[[69;;88]] = field;
setObjVelIn[Real[20] field_] -> {} := InputRealFields[[89;;108]] = field;
setObjCourseIn[Real[20] field_] -> {} := InputRealFields[[109;;128]] = field;
setLaneWidthIn[Real field_] -> {} := InputRealFields[[129]] = field;
setLatOffsLineRIn[Real field_] -> {} := InputRealFields[[130]] = field;
setLatOffsLineLIn[Real field_] -> {} := InputRealFields[[131]] = field;
setLaneHeadingIn[Real field_] -> {} := InputRealFields[[132]] = field;
setLaneCrvtIn[Real field_] -> {} := InputRealFields[[133]] = field;
setAdasisCurvatureDistIn[Real[100] field_] -> {} := InputRealFields[[134;;233]] = field;
setAdasisCurvatureValuesIn[Real[100] field_] -> {} := InputRealFields[[234;;333]] = field;
setAdasisSpeedLimitDistIn[Real[10] field_] -> {} := InputRealFields[[334;;343]] = field;
setTrfLightDistIn[Real field_] -> {} := InputRealFields[[344]] = field;
setTrfLightFirstTimeToChangeIn[Real field_] -> {} := InputRealFields[[345]] = field;
setTrfLightSecondTimeToChangeIn[Real field_] -> {} := InputRealFields[[346]] = field;
setTrfLightThirdTimeToChangeIn[Real field_] -> {} := InputRealFields[[347]] = field;
(* ::Subsubsection::Closed:: *)
(* Get functions real fields *)

getECUupTime[] -> {Real} := InputRealFields[[1]];
getVLgtFild[] -> {Real} := InputRealFields[[2]];
getALgtFild[] -> {Real} := InputRealFields[[3]];
getYawRateFild[] -> {Real} := InputRealFields[[4]];
getSteerWhlAg[] -> {Real} := InputRealFields[[5]];
getVehicleLen[] -> {Real} := InputRealFields[[6]];
getVehicleWidth[] -> {Real} := InputRealFields[[7]];
getRequestedCruisingSpeed[] -> {Real} := InputRealFields[[8]];
getObjX[] -> {Real[20]} := InputRealFields[[9;;28]];
getObjY[] -> {Real[20]} := InputRealFields[[29;;48]];
getObjLen[] -> {Real[20]} := InputRealFields[[49;;68]];
getObjWidth[] -> {Real[20]} := InputRealFields[[69;;88]];
getObjVel[] -> {Real[20]} := InputRealFields[[89;;108]];
getObjCourse[] -> {Real[20]} := InputRealFields[[109;;128]];
getLaneWidth[] -> {Real} := InputRealFields[[129]];
getLatOffsLineR[] -> {Real} := InputRealFields[[130]];
getLatOffsLineL[] -> {Real} := InputRealFields[[131]];
getLaneHeading[] -> {Real} := InputRealFields[[132]];
getLaneCrvt[] -> {Real} := InputRealFields[[133]];
getAdasisCurvatureDist[] -> {Real[100]} := InputRealFields[[134;;233]];
getAdasisCurvatureValues[] -> {Real[100]} := InputRealFields[[234;;333]];
getAdasisSpeedLimitDist[] -> {Real[10]} := InputRealFields[[334;;343]];
getTrfLightDist[] -> {Real} := InputRealFields[[344]];
getTrfLightFirstTimeToChange[] -> {Real} := InputRealFields[[345]];
getTrfLightSecondTimeToChange[] -> {Real} := InputRealFields[[346]];
getTrfLightThirdTimeToChange[] -> {Real} := InputRealFields[[347]];


(* ::Section:: *)
(* Interfaces Out *)
(* ::Subsection:: *)
(* Global Variable Output Fields *)

Declare[Integer[6] OutputIntegerFields = 0];
Declare[Real[73] OutputRealFields = 0];
(* ::Subsection::Closed:: *)
(* Definition of OutputDataExternal function *)
OutputDataExternal[Integer id_, Integer[6] intVector_, Real[73] realVector_] -> {} := ExternalProcedure[];
(* ::Subsection::Closed:: *)
(* Integer output fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions integer fields *)

setID[Integer field_] -> {} := OutputIntegerFields[[1]] = field;
setVersion[Integer field_] -> {} := OutputIntegerFields[[2]] = field;
setCycleNumber[Integer field_] -> {} := OutputIntegerFields[[3]] = field;
setStatus[Integer field_] -> {} := OutputIntegerFields[[4]] = field;
setNTrajectoryPoints[Integer field_] -> {} := OutputIntegerFields[[5]] = field;
setManoeuverType[Integer field_] -> {} := OutputIntegerFields[[6]] = field;
(* ::Subsubsection::Closed:: *)
(* Get functions integer fields *)

getIDOut[] -> {Integer} := OutputIntegerFields[[1]];
getVersionOut[] -> {Integer} := OutputIntegerFields[[2]];
getCycleNumberOut[] -> {Integer} := OutputIntegerFields[[3]];
getStatusOut[] -> {Integer} := OutputIntegerFields[[4]];
getNTrajectoryPointsOut[] -> {Integer} := OutputIntegerFields[[5]];
getManoeuverTypeOut[] -> {Integer} := OutputIntegerFields[[6]];
(* ::Subsection::Closed:: *)
(* Real output fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions real fields *)

setECUupTime[Real field_] -> {} := OutputRealFields[[1]] = field;
setTrajectoryPointITime[Real[23] field_] -> {} := OutputRealFields[[2;;24]] = field;
setTrajectoryPointIX[Real[23] field_] -> {} := OutputRealFields[[25;;47]] = field;
setTrajectoryPointIY[Real[23] field_] -> {} := OutputRealFields[[48;;70]] = field;
setTargetSpeed[Real field_] -> {} := OutputRealFields[[71]] = field;
setRequestedAcc[Real field_] -> {} := OutputRealFields[[72]] = field;
setRequestedSteerWhlAg[Real field_] -> {} := OutputRealFields[[73]] = field;
(* ::Subsubsection::Closed:: *)
(* Get functions real fields *)

getECUupTimeOut[] -> {Real} := OutputRealFields[[1]];
getTrajectoryPointITimeOut[] -> {Real[23]} := OutputRealFields[[2;;24]];
getTrajectoryPointIXOut[] -> {Real[23]} := OutputRealFields[[25;;47]];
getTrajectoryPointIYOut[] -> {Real[23]} := OutputRealFields[[48;;70]];
getTargetSpeedOut[] -> {Real} := OutputRealFields[[71]];
getRequestedAccOut[] -> {Real} := OutputRealFields[[72]];
getRequestedSteerWhlAgOut[] -> {Real} := OutputRealFields[[73]];

