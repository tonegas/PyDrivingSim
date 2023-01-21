// File for interfaces
// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
// Originf file: interfaces_v1.2.csv
// Origin CRC32: 4097400712

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME interfaces_scenario_serializer

#define NUM_INPUTS 41
#define NUM_OUTPUTS 2

#define N_PARAMS 0
#define SAMPLE_TIME_0 INHERITED_SAMPLE_TIME
#define NUM_DISC_STATES 0
#define NUM_CONT_STATES 0

#include "simstruc.h"
#if defined(_DS1401)
#include "ds1401_functions.h"
#endif

/*====================*
 * S-function methods *
 *====================*/
// Function: mdlInitializeSizes =========================================
static void mdlInitializeSizes(SimStruct *S) {

  DECL_AND_INIT_DIMSINFO(inputDimsInfo);
  DECL_AND_INIT_DIMSINFO(outputDimsInfo);
  ssSetNumSFcnParams(S, N_PARAMS);
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
    return; // Parameter mismatch will be reported by Simulink
  }

  ssSetNumContStates(S, NUM_CONT_STATES);
  ssSetNumDiscStates(S, NUM_DISC_STATES);

  // Inputs -------------------------------------------------------------
  if (!ssSetNumInputPorts(S, NUM_INPUTS)) {
    return;
  }
  // Input Port 0
  ssSetInputPortWidth(S, 0, 1);
  ssSetInputPortDataType(S, 0, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 0, 1);
  ssSetInputPortRequiredContiguous(S, 0, 1); // direct input signal access
  // Input Port 1
  ssSetInputPortWidth(S, 1, 1);
  ssSetInputPortDataType(S, 1, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 1, 1);
  ssSetInputPortRequiredContiguous(S, 1, 1); // direct input signal access
  // Input Port 2
  ssSetInputPortWidth(S, 2, 1);
  ssSetInputPortDataType(S, 2, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 2, 1);
  ssSetInputPortRequiredContiguous(S, 2, 1); // direct input signal access
  // Input Port 3
  ssSetInputPortWidth(S, 3, 1);
  ssSetInputPortDataType(S, 3, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 3, 1);
  ssSetInputPortRequiredContiguous(S, 3, 1); // direct input signal access
  // Input Port 4
  ssSetInputPortWidth(S, 4, 1);
  ssSetInputPortDataType(S, 4, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 4, 1);
  ssSetInputPortRequiredContiguous(S, 4, 1); // direct input signal access
  // Input Port 5
  ssSetInputPortWidth(S, 5, 1);
  ssSetInputPortDataType(S, 5, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 5, 1);
  ssSetInputPortRequiredContiguous(S, 5, 1); // direct input signal access
  // Input Port 6
  ssSetInputPortWidth(S, 6, 1);
  ssSetInputPortDataType(S, 6, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 6, 1);
  ssSetInputPortRequiredContiguous(S, 6, 1); // direct input signal access
  // Input Port 7
  ssSetInputPortWidth(S, 7, 1);
  ssSetInputPortDataType(S, 7, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 7, 1);
  ssSetInputPortRequiredContiguous(S, 7, 1); // direct input signal access
  // Input Port 8
  ssSetInputPortWidth(S, 8, 1);
  ssSetInputPortDataType(S, 8, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 8, 1);
  ssSetInputPortRequiredContiguous(S, 8, 1); // direct input signal access
  // Input Port 9
  ssSetInputPortWidth(S, 9, 1);
  ssSetInputPortDataType(S, 9, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 9, 1);
  ssSetInputPortRequiredContiguous(S, 9, 1); // direct input signal access
  // Input Port 10
  ssSetInputPortWidth(S, 10, 1);
  ssSetInputPortDataType(S, 10, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 10, 1);
  ssSetInputPortRequiredContiguous(S, 10, 1); // direct input signal access
  // Input Port 11
  ssSetInputPortWidth(S, 11, 1);
  ssSetInputPortDataType(S, 11, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 11, 1);
  ssSetInputPortRequiredContiguous(S, 11, 1); // direct input signal access
  // Input Port 12
  ssSetInputPortWidth(S, 12, 1);
  ssSetInputPortDataType(S, 12, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 12, 1);
  ssSetInputPortRequiredContiguous(S, 12, 1); // direct input signal access
  // Input Port 13
  ssSetInputPortWidth(S, 13, 1);
  ssSetInputPortDataType(S, 13, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 13, 1);
  ssSetInputPortRequiredContiguous(S, 13, 1); // direct input signal access
  // Input Port 14
  ssSetInputPortWidth(S, 14, 1);
  ssSetInputPortDataType(S, 14, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 14, 1);
  ssSetInputPortRequiredContiguous(S, 14, 1); // direct input signal access
  // Input Port 15
  ssSetInputPortWidth(S, 15, 20);
  ssSetInputPortDataType(S, 15, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 15, 1);
  ssSetInputPortRequiredContiguous(S, 15, 1); // direct input signal access
  // Input Port 16
  ssSetInputPortWidth(S, 16, 20);
  ssSetInputPortDataType(S, 16, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 16, 1);
  ssSetInputPortRequiredContiguous(S, 16, 1); // direct input signal access
  // Input Port 17
  ssSetInputPortWidth(S, 17, 20);
  ssSetInputPortDataType(S, 17, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 17, 1);
  ssSetInputPortRequiredContiguous(S, 17, 1); // direct input signal access
  // Input Port 18
  ssSetInputPortWidth(S, 18, 20);
  ssSetInputPortDataType(S, 18, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 18, 1);
  ssSetInputPortRequiredContiguous(S, 18, 1); // direct input signal access
  // Input Port 19
  ssSetInputPortWidth(S, 19, 20);
  ssSetInputPortDataType(S, 19, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 19, 1);
  ssSetInputPortRequiredContiguous(S, 19, 1); // direct input signal access
  // Input Port 20
  ssSetInputPortWidth(S, 20, 20);
  ssSetInputPortDataType(S, 20, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 20, 1);
  ssSetInputPortRequiredContiguous(S, 20, 1); // direct input signal access
  // Input Port 21
  ssSetInputPortWidth(S, 21, 20);
  ssSetInputPortDataType(S, 21, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 21, 1);
  ssSetInputPortRequiredContiguous(S, 21, 1); // direct input signal access
  // Input Port 22
  ssSetInputPortWidth(S, 22, 1);
  ssSetInputPortDataType(S, 22, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 22, 1);
  ssSetInputPortRequiredContiguous(S, 22, 1); // direct input signal access
  // Input Port 23
  ssSetInputPortWidth(S, 23, 1);
  ssSetInputPortDataType(S, 23, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 23, 1);
  ssSetInputPortRequiredContiguous(S, 23, 1); // direct input signal access
  // Input Port 24
  ssSetInputPortWidth(S, 24, 1);
  ssSetInputPortDataType(S, 24, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 24, 1);
  ssSetInputPortRequiredContiguous(S, 24, 1); // direct input signal access
  // Input Port 25
  ssSetInputPortWidth(S, 25, 1);
  ssSetInputPortDataType(S, 25, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 25, 1);
  ssSetInputPortRequiredContiguous(S, 25, 1); // direct input signal access
  // Input Port 26
  ssSetInputPortWidth(S, 26, 1);
  ssSetInputPortDataType(S, 26, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 26, 1);
  ssSetInputPortRequiredContiguous(S, 26, 1); // direct input signal access
  // Input Port 27
  ssSetInputPortWidth(S, 27, 1);
  ssSetInputPortDataType(S, 27, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 27, 1);
  ssSetInputPortRequiredContiguous(S, 27, 1); // direct input signal access
  // Input Port 28
  ssSetInputPortWidth(S, 28, 100);
  ssSetInputPortDataType(S, 28, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 28, 1);
  ssSetInputPortRequiredContiguous(S, 28, 1); // direct input signal access
  // Input Port 29
  ssSetInputPortWidth(S, 29, 100);
  ssSetInputPortDataType(S, 29, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 29, 1);
  ssSetInputPortRequiredContiguous(S, 29, 1); // direct input signal access
  // Input Port 30
  ssSetInputPortWidth(S, 30, 1);
  ssSetInputPortDataType(S, 30, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 30, 1);
  ssSetInputPortRequiredContiguous(S, 30, 1); // direct input signal access
  // Input Port 31
  ssSetInputPortWidth(S, 31, 10);
  ssSetInputPortDataType(S, 31, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 31, 1);
  ssSetInputPortRequiredContiguous(S, 31, 1); // direct input signal access
  // Input Port 32
  ssSetInputPortWidth(S, 32, 10);
  ssSetInputPortDataType(S, 32, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 32, 1);
  ssSetInputPortRequiredContiguous(S, 32, 1); // direct input signal access
  // Input Port 33
  ssSetInputPortWidth(S, 33, 1);
  ssSetInputPortDataType(S, 33, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 33, 1);
  ssSetInputPortRequiredContiguous(S, 33, 1); // direct input signal access
  // Input Port 34
  ssSetInputPortWidth(S, 34, 1);
  ssSetInputPortDataType(S, 34, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 34, 1);
  ssSetInputPortRequiredContiguous(S, 34, 1); // direct input signal access
  // Input Port 35
  ssSetInputPortWidth(S, 35, 1);
  ssSetInputPortDataType(S, 35, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 35, 1);
  ssSetInputPortRequiredContiguous(S, 35, 1); // direct input signal access
  // Input Port 36
  ssSetInputPortWidth(S, 36, 1);
  ssSetInputPortDataType(S, 36, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 36, 1);
  ssSetInputPortRequiredContiguous(S, 36, 1); // direct input signal access
  // Input Port 37
  ssSetInputPortWidth(S, 37, 1);
  ssSetInputPortDataType(S, 37, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 37, 1);
  ssSetInputPortRequiredContiguous(S, 37, 1); // direct input signal access
  // Input Port 38
  ssSetInputPortWidth(S, 38, 1);
  ssSetInputPortDataType(S, 38, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 38, 1);
  ssSetInputPortRequiredContiguous(S, 38, 1); // direct input signal access
  // Input Port 39
  ssSetInputPortWidth(S, 39, 1);
  ssSetInputPortDataType(S, 39, SS_INT32);
  ssSetInputPortDirectFeedThrough(S, 39, 1);
  ssSetInputPortRequiredContiguous(S, 39, 1); // direct input signal access
  // Input Port 40
  ssSetInputPortWidth(S, 40, 1);
  ssSetInputPortDataType(S, 40, SS_DOUBLE);
  ssSetInputPortDirectFeedThrough(S, 40, 1);
  ssSetInputPortRequiredContiguous(S, 40, 1); // direct input signal access

  // Outputs ------------------------------------------------------------
  if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) {
    return;
  }
  // Output port 0
  ssSetOutputPortWidth(S, 0, 737);
  ssSetOutputPortDataType(S, 0, SS_UINT32);
  // Output port 1
  ssSetOutputPortWidth(S, 1, 1);
  ssSetOutputPortDataType(S, 1, SS_UINT32);

  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumPWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);

  // Take care when specifying exception free code - see sfuntmpl_doc.c
  ssSetOptions(S, (SS_OPTION_EXCEPTION_FREE_CODE));
}

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_DIMENSION_INFO
static void mdlSetInputPortDimensionInfo(SimStruct *S, int_T port,
                                         const DimsInfo_T *dimsInfo) {
  if (!ssSetInputPortDimensionInfo(S, port, dimsInfo)) {
    return;
  }
}
#endif

#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
#if defined(MDL_SET_OUTPUT_PORT_DIMENSION_INFO)
static void mdlSetOutputPortDimensionInfo(SimStruct *S, int_T port,
                                          const DimsInfo_T *dimsInfo) {
  if (!ssSetOutputPortDimensionInfo(S, port, dimsInfo)) {
    return;
  }
}
#endif
#define MDL_SET_INPUT_PORT_FRAME_DATA
static void mdlSetInputPortFrameData(SimStruct *S, int_T port,
                                     Frame_T frameData) {
  ssSetInputPortFrameData(S, port, frameData);
}

// Function: mdlInitializeSampleTimes =================================
static void mdlInitializeSampleTimes(SimStruct *S) {
  ssSetSampleTime(S, 0, SAMPLE_TIME_0);
  ssSetModelReferenceSampleTimeDefaultInheritance(S);
  ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S, int port, DTypeId dType) {
  ssSetInputPortDataType(S, port, dType);
}
#define MDL_SET_OUTPUT_PORT_DATA_TYPE
static void mdlSetOutputPortDataType(SimStruct *S, int port, DTypeId dType) {
  ssSetOutputPortDataType(S, port, dType);
}
#define MDL_SET_DEFAULT_PORT_DATA_TYPES
static void mdlSetDefaultPortDataTypes(SimStruct *S) {
  ssSetInputPortDataType(S, 0, SS_INT32);
  ssSetInputPortDataType(S, 1, SS_INT32);
  ssSetInputPortDataType(S, 2, SS_INT32);
  ssSetInputPortDataType(S, 3, SS_DOUBLE);
  ssSetInputPortDataType(S, 4, SS_INT32);
  ssSetInputPortDataType(S, 5, SS_DOUBLE);
  ssSetInputPortDataType(S, 6, SS_DOUBLE);
  ssSetInputPortDataType(S, 7, SS_DOUBLE);
  ssSetInputPortDataType(S, 8, SS_DOUBLE);
  ssSetInputPortDataType(S, 9, SS_DOUBLE);
  ssSetInputPortDataType(S, 10, SS_DOUBLE);
  ssSetInputPortDataType(S, 11, SS_DOUBLE);
  ssSetInputPortDataType(S, 12, SS_INT32);
  ssSetInputPortDataType(S, 13, SS_INT32);
  ssSetInputPortDataType(S, 14, SS_INT32);
  ssSetInputPortDataType(S, 15, SS_INT32);
  ssSetInputPortDataType(S, 16, SS_DOUBLE);
  ssSetInputPortDataType(S, 17, SS_DOUBLE);
  ssSetInputPortDataType(S, 18, SS_DOUBLE);
  ssSetInputPortDataType(S, 19, SS_DOUBLE);
  ssSetInputPortDataType(S, 20, SS_DOUBLE);
  ssSetInputPortDataType(S, 21, SS_DOUBLE);
  ssSetInputPortDataType(S, 22, SS_DOUBLE);
  ssSetInputPortDataType(S, 23, SS_DOUBLE);
  ssSetInputPortDataType(S, 24, SS_DOUBLE);
  ssSetInputPortDataType(S, 25, SS_DOUBLE);
  ssSetInputPortDataType(S, 26, SS_DOUBLE);
  ssSetInputPortDataType(S, 27, SS_INT32);
  ssSetInputPortDataType(S, 28, SS_DOUBLE);
  ssSetInputPortDataType(S, 29, SS_DOUBLE);
  ssSetInputPortDataType(S, 30, SS_INT32);
  ssSetInputPortDataType(S, 31, SS_DOUBLE);
  ssSetInputPortDataType(S, 32, SS_INT32);
  ssSetInputPortDataType(S, 33, SS_INT32);
  ssSetInputPortDataType(S, 34, SS_DOUBLE);
  ssSetInputPortDataType(S, 35, SS_INT32);
  ssSetInputPortDataType(S, 36, SS_DOUBLE);
  ssSetInputPortDataType(S, 37, SS_INT32);
  ssSetInputPortDataType(S, 38, SS_DOUBLE);
  ssSetInputPortDataType(S, 39, SS_INT32);
  ssSetInputPortDataType(S, 40, SS_DOUBLE);
  ssSetOutputPortDataType(S, 0, SS_UINT32);
  ssSetOutputPortDataType(S, 1, SS_UINT32);
}

// Function: mdlOutputs ===============================================
static void mdlOutputs(SimStruct *S, int_T tid) {
  const void *input_array;
  uint32_T *output_array = (uint32_T *)ssGetOutputPortSignal(S, 0);
  uint32_T *output_time = (uint32_T *)ssGetOutputPortSignal(S, 1);
  DTypeId input_data_type;
  size_t mem_pos = 0;
  int_T input_array_width;
  size_t input_array_bytes;
  int_T i, j;

  UNUSED_ARG(tid);
#if defined(_DS1401)
  *output_time = get_time_100();
#endif

  for (i = 0; i < NUM_INPUTS; i++) {
    input_array = ssGetInputPortSignal(S, i);
    input_array_width = ssGetInputPortWidth(S, i);
    input_data_type = ssGetInputPortDataType(S, i);
    switch (input_data_type) {
    case SS_INT32:
      input_array_bytes = (size_t)input_array_width * sizeof(int32_T);
      memcpy((char *)output_array + mem_pos, input_array, input_array_bytes);
      break;
    case SS_DOUBLE:
      input_array_bytes = (size_t)input_array_width * sizeof(real_T);
#if defined(_DS1401)
      // Write a double in two uint32_T changing the order
      // This is readable by unix and windows systems
      for (j = 0; j < input_array_width; j++) {
        memcpy((void *)output_array + mem_pos + j * sizeof(real_T),
               input_array + j * sizeof(real_T) + sizeof(uint32_T),
               sizeof(uint32_T));
        memcpy((void *)output_array + mem_pos + j * sizeof(real_T) +
                   sizeof(uint32_T),
               input_array + j * sizeof(real_T), sizeof(uint32_T));
      }
#else
      memcpy((char *)output_array + mem_pos, input_array, input_array_bytes);
#endif
      break;
    default:
      ssPrintf("Cannot serialize input data type %d\n", input_data_type);
      return;
    }
    mem_pos += input_array_bytes;
  }
}

// Function: mdlTerminate =============================================
static void mdlTerminate(SimStruct *S) {}

#ifdef MATLAB_MEX_FILE /* Is this file being compiled as a MEX-file? */
#include "simulink.c"  /* MEX-file interface mechanism */
#else
#include "cg_sfun.h" /* Code generation registration function */
#endif
