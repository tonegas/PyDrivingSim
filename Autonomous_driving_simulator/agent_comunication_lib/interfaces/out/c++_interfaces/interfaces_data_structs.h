// File for interfaces
// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
// Origin file: interfaces_v1.2.csv
// Origin CRC32: 4097400712

#ifndef interfaces_data_structs_h
#define interfaces_data_structs_h

#if defined(_DS1401)
#include "ds1401_defines.h"
#else
#include <stdint.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

// interfaces version for printing
#define AGENTINTERFACESVER 12

#if defined(MATLAB_MEX_FILE) || defined(_DS1401) || defined(_WIN32)
#pragma pack(push, 1)
typedef struct {
#else
typedef struct __attribute__((packed)) {
#endif
  int32_t ID; /* Enumeration 1=Scenario message2=Manoeuvre message, */
  int32_t Version; /* if Version>0 the simulator expects lateral control from ADBoT agent. For Version==0 the built-in lateral control in enabled */
  int32_t CycleNumber; /* This is an increasing number increamented at every time-step. It allow to relate the manoeuvre with the corresponding scenario */
  double ECUupTime; /* Means system up-time. It starts from zero when the simulation begins */
  int32_t Status; /* 0 = ACTIVE, 0 > Faild  (means working correctly or not), 0 < Closing */
  double VLgtFild;
  double ALgtFild;
  double YawRateFild; /* Note that yaw-rate is the derivative of the heading, i.e. chassis rotation rate, not speed rotation rate */
  double SteerWhlAg; /* Positive when the car is turning left */
  double VehicleLen; /* Total length from front bumper to the rear bumper */
  double VehicleWidth;
  double RequestedCruisingSpeed;
  int32_t AutomationLevel; /* 0 = NO AUTOMATION, 1 = ASSISTED, 2 = PARTIAL AUTOMATION, 3 = CONDITIONAL AUTOMATION, 4 = HIGH AUTOMATION, 5 = FULL AUTOMATION, 6 = UNKNOWN  */
  int32_t CurrentLane; /* Nomenclature from ADASIS: 0 = Unknown, 1 = Emergency lane, 2 = Single-lane road, 3 = Left-most lane, 4 = Right-most lane, 5 = One of middle lanes on road with three or more lanes */
  int32_t NrObjs; /* Limited to 20 max number of objects, selection needed (if more might be limited to nearest objects) */
  int32_t ObjID[20];
  double ObjX[20]; /* Center of the object */
  double ObjY[20]; /* Centre of the object */
  double ObjLen[20]; /* Along object speed direction, along vehicle axis for stationary obstacles. 0 means unknown. */
  double ObjWidth[20]; /* Perpendicular to object speed direction, perpendicular to vehicle axis for stationary obstacles. 0 means unknown. */
  double ObjVel[20]; /* Speed module, not longitudinal speed */
  double ObjCourse[20]; /* In vehicle reference system, positive to the counter-clockwise */
  double LaneWidth;
  double LatOffsLineR; /* positive to the left */
  double LatOffsLineL;
  double LaneHeading; /* Positive counter-clockwise  */
  double LaneCrvt; /* Positive for left curves, current curvature (at the cars position) */
  int32_t AdasisCurvatureNr;
  double AdasisCurvatureDist[100];
  double AdasisCurvatureValues[100]; /* Positive for left curves */
  int32_t AdasisSpeedLimitNr;
  double AdasisSpeedLimitDist[10];
  int32_t AdasisSpeedLimitValues[10]; /* 0 means unknown */
  int32_t NrTrfLights; /* Only first traffic ligh is described if available */
  double TrfLightDist;
  int32_t TrfLightCurrState; /* 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing */
  double TrfLightFirstTimeToChange;
  int32_t TrfLightFirstNextState; /* 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing */
  double TrfLightSecondTimeToChange;
  int32_t TrfLightSecondNextState; /* 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing */
  double TrfLightThirdTimeToChange;
} input_data_str;
#if defined(MATLAB_MEX_FILE) || defined(_DS1401) || defined(_WIN32)
#pragma pack(pop)
#endif

#if defined(MATLAB_MEX_FILE) || defined(_DS1401) || defined(_WIN32)
#pragma pack(push, 1)
typedef struct {
#else
typedef struct __attribute__((packed)) {
#endif
  int32_t ID; /* Enumeration 1=Scenario message2=Manoeuvre message, */
  int32_t Version; /* if Version>0 the simulator expects lateral control from ADBoT agent. For Version==0 the built-in lateral control in enabled */
  int32_t CycleNumber; /* This is an increasing number increamented at every time-step. It allow to relate the manoeuvre with the corresponding scenario */
  double ECUupTime; /* Means system up-time. It starts from zero when the simulation begins */
  int32_t Status; /* 0 = ACTIVE, 0 > Faild  (means working correctly or not), 0 < Closing */
  int32_t NTrajectoryPoints; /* Limited to 23 max number of trajectory points */
  double TrajectoryPointITime[23]; /* Unix epoch */
  double TrajectoryPointIX[23]; /* In vehicle reference system */
  double TrajectoryPointIY[23]; /* In vehicle reference system */
  double TargetSpeed; /* Speed of the vehicle at the end of the manoeuvre */
  double RequestedAcc; /* ECU up time when the primitive starts (based on ECUs given by Scenario Messages) */
  int32_t ManoeuverType; /* E.g: follow object, free flow, stopping, etc. */
  double RequestedSteerWhlAg; /* Comanded steering wheel angle, positive counter clockwise. */
} output_data_str;
#if defined(MATLAB_MEX_FILE) || defined(_DS1401) || defined(_WIN32)
#pragma pack(pop)
#endif


// Scenario message union
typedef union {
  input_data_str data_struct;
  char data_buffer[sizeof(input_data_str)];
} scenario_msg_t;

// Manoeuvre message union
typedef union {
  output_data_str data_struct;
  char data_buffer[sizeof(output_data_str)];
} manoeuvre_msg_t;

#ifdef __cplusplus
} // extern "C"
#endif

#endif
