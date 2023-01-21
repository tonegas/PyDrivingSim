// File for interfaces
// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
// Originf file: interfaces_v1.2.csv
// Origin CRC32: 4097400712

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME interfaces_packet_reader

#define NUM_INPUTS 4
/* Input Port  0 */
#define IN_PORT_0_NAME packet_array
#define INPUT_0_WIDTH 368
#define INPUT_DIMS_0_COL 1
#define INPUT_0_DTYPE uint32_T
#define INPUT_0_COMPLEX COMPLEX_NO
#define IN_0_FRAME_BASED FRAME_NO
#define IN_0_BUS_BASED 0
#define IN_0_BUS_NAME
#define IN_0_DIMS 1 - D
#define INPUT_0_FEEDTHROUGH 1
#define IN_0_ISSIGNED 0
#define IN_0_WORDLENGTH 8
#define IN_0_FIXPOINTSCALING 1
#define IN_0_FRACTIONLENGTH 9
#define IN_0_BIAS 0
#define IN_0_SLOPE 0.125
/* Input Port  1 */
#define IN_PORT_1_NAME recv_bytes
#define INPUT_1_WIDTH 1
#define INPUT_DIMS_1_COL 1
#define INPUT_1_DTYPE uint32_T
#define INPUT_1_COMPLEX COMPLEX_NO
#define IN_1_FRAME_BASED FRAME_NO
#define IN_1_BUS_BASED 0
#define IN_1_BUS_NAME
#define IN_1_DIMS 1 - D
#define INPUT_1_FEEDTHROUGH 1
#define IN_1_ISSIGNED 0
#define IN_1_WORDLENGTH 8
#define IN_1_FIXPOINTSCALING 1
#define IN_1_FRACTIONLENGTH 9
#define IN_1_BIAS 0
#define IN_1_SLOPE 0.125
/* Input Port  2 */
#define IN_PORT_2_NAME buffer_id
#define INPUT_2_WIDTH 1
#define INPUT_DIMS_2_COL 1
#define INPUT_2_DTYPE uint32_T
#define INPUT_2_COMPLEX COMPLEX_NO
#define IN_2_FRAME_BASED FRAME_NO
#define IN_2_BUS_BASED 0
#define IN_2_BUS_NAME
#define IN_2_DIMS 1 - D
#define INPUT_2_FEEDTHROUGH 1
#define IN_2_ISSIGNED 0
#define IN_2_WORDLENGTH 8
#define IN_2_FIXPOINTSCALING 1
#define IN_2_FRACTIONLENGTH 9
#define IN_2_BIAS 0
#define IN_2_SLOPE 0.125
/* Input Port  3 */
#define IN_PORT_3_NAME readed_packets_in
#define INPUT_3_WIDTH 1
#define INPUT_DIMS_3_COL 1
#define INPUT_3_DTYPE uint32_T
#define INPUT_3_COMPLEX COMPLEX_NO
#define IN_3_FRAME_BASED FRAME_NO
#define IN_3_BUS_BASED 0
#define IN_3_BUS_NAME
#define IN_3_DIMS 1 - D
#define INPUT_3_FEEDTHROUGH 1
#define IN_3_ISSIGNED 0
#define IN_3_WORDLENGTH 8
#define IN_3_FIXPOINTSCALING 1
#define IN_3_FRACTIONLENGTH 9
#define IN_3_BIAS 0
#define IN_3_SLOPE 0.125

#define NUM_OUTPUTS 4
/* Output Port  0 */
#define OUT_PORT_0_NAME manoeuvre_array_out
#define OUTPUT_0_WIDTH 152
#define OUTPUT_DIMS_0_COL 1
#define OUTPUT_0_DTYPE uint32_T
#define OUTPUT_0_COMPLEX COMPLEX_NO
#define OUT_0_FRAME_BASED FRAME_NO
#define OUT_0_BUS_BASED 0
#define OUT_0_BUS_NAME
#define OUT_0_DIMS 1 - D
#define OUT_0_ISSIGNED 1
#define OUT_0_WORDLENGTH 8
#define OUT_0_FIXPOINTSCALING 1
#define OUT_0_FRACTIONLENGTH 3
#define OUT_0_BIAS 0
#define OUT_0_SLOPE 0.125
/* Output Port  1 */
#define OUT_PORT_1_NAME status
#define OUTPUT_1_WIDTH 1
#define OUTPUT_DIMS_1_COL 1
#define OUTPUT_1_DTYPE int32_T
#define OUTPUT_1_COMPLEX COMPLEX_NO
#define OUT_1_FRAME_BASED FRAME_NO
#define OUT_1_BUS_BASED 0
#define OUT_1_BUS_NAME
#define OUT_1_DIMS 1 - D
#define OUT_1_ISSIGNED 1
#define OUT_1_WORDLENGTH 8
#define OUT_1_FIXPOINTSCALING 1
#define OUT_1_FRACTIONLENGTH 3
#define OUT_1_BIAS 0
#define OUT_1_SLOPE 0.125
/* Output Port  2 */
#define OUT_PORT_2_NAME stop_time
#define OUTPUT_2_WIDTH 1
#define OUTPUT_DIMS_2_COL 1
#define OUTPUT_2_DTYPE uint32_T
#define OUTPUT_2_COMPLEX COMPLEX_NO
#define OUT_2_FRAME_BASED FRAME_NO
#define OUT_2_BUS_BASED 0
#define OUT_2_BUS_NAME
#define OUT_2_DIMS 1 - D
#define OUT_2_ISSIGNED 1
#define OUT_2_WORDLENGTH 8
#define OUT_2_FIXPOINTSCALING 1
#define OUT_2_FRACTIONLENGTH 3
#define OUT_2_BIAS 0
#define OUT_2_SLOPE 0.125
/* Output Port  3 */
#define OUT_PORT_3_NAME readed_packets_out
#define OUTPUT_3_WIDTH 1
#define OUTPUT_DIMS_3_COL 1
#define OUTPUT_3_DTYPE uint32_T
#define OUTPUT_3_COMPLEX COMPLEX_NO
#define OUT_3_FRAME_BASED FRAME_NO
#define OUT_3_BUS_BASED 0
#define OUT_3_BUS_NAME
#define OUT_3_DIMS 1 - D
#define OUT_3_ISSIGNED 1
#define OUT_3_WORDLENGTH 8
#define OUT_3_FIXPOINTSCALING 1
#define OUT_3_FRACTIONLENGTH 3
#define OUT_3_BIAS 0
#define OUT_3_SLOPE 0.125

#define NPARAMS 0

#define SAMPLE_TIME_0 INHERITED_SAMPLE_TIME
#define NUM_DISC_STATES 0
#define DISC_STATES_IC [ 0, 0 ]
#define NUM_CONT_STATES 0
#define CONT_STATES_IC [0]

#define SFUNWIZ_GENERATE_TLC 0
#define PANELINDEX 8
#define USE_SIMSTRUCT 1
#define SHOW_COMPILE_STEPS 0
#define CREATE_DEBUG_MEXFILE 0
#define SAVE_CODE_ONLY 0
#define SFUNWIZ_REVISION 3.0

#include "simstruc.h"

// ===================== ADDITIONAL INCLUDE FROM WRAPPER =====================
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <assert.h>

#include "udp_defines.h"
#include "interfaces_data_structs.h"

#if defined(_DS1401)
#include "ds1401_functions.h"
#endif
#define u_width 368
#define y_width 1

// ===================== WRAPPER FUNCTION BODY =====================
static void swapBytes(void *dest, void *src, int size, int num) {
  uint8_T *dest1, *src1, i;

  assert(src != dest);
  dest1 = dest;
  src1 = src;

  if (size == 1) {
    memcpy(dest1, src1, num);
    return;
  }
  while (num--) {
    for (i = 0; i < size; i++)
      dest1[i] = src1[size - i - 1];
    dest1 += size;
    src1 += size;
  }
  return;
}

/*
 * Output functions
 *
 */
void agent_packet_reader_outputs(const uint32_T *packet_array,
                                 const uint32_T *recv_bytes,
                                 const uint32_T *buffer_id,
                                 const uint32_T *readed_packets_in,
                                 uint32_T *manoeuvre_array_out, int32_T *status,
                                 uint32_T *stop_time,
                                 uint32_T *readed_packets_out, SimStruct *S) {
  packet_t packet;
  UDP_UINT n_packets;
  UDP_UINT last_part_pos;
  UDP_UINT part_pos;
  UDP_UINT part_size;
  UDP_UINT datagram_id;

  size_t manoeuvre_array_size =
      (size_t)ssGetOutputPortWidth(S, 0) * sizeof(uint32_T);
  *status = -1;
  if (*recv_bytes > 0) {
    memcpy(&packet.data_buffer, (void *)packet_array, (size_t)PACKET_BYTES);

    swapBytes((void *)&last_part_pos, (void *)&packet.data_struct.last_part_pos,
              sizeof(uint32_T), 1);
    swapBytes((void *)&datagram_id, (void *)&packet.data_struct.datagram_id,
              sizeof(uint32_T), 1);
    swapBytes((void *)&part_pos, (void *)&packet.data_struct.part_pos,
              sizeof(uint32_T), 1);
    swapBytes((void *)&part_size, (void *)&packet.data_struct.part_size,
              sizeof(uint32_T), 1);

    n_packets = last_part_pos + 1;

    // Keep only packets with buffer_id equal to the sended message id
    if (datagram_id == *buffer_id) {
#if defined(_DS1401) || defined(__MACH__) || defined(__linux__)
      memcpy((void *)manoeuvre_array_out +
                 ((size_t)part_pos) * sizeof(packet.data_struct.datagram_part),
             &packet.data_struct.datagram_part, (size_t)part_size);
#elif defined(_WIN32)
      memcpy((char *)manoeuvre_array_out +
                 ((size_t)part_pos) * sizeof(packet.data_struct.datagram_part),
             &packet.data_struct.datagram_part, (size_t)part_size);
#endif
      *readed_packets_out = *readed_packets_in + 1;
      if (*readed_packets_out == n_packets) {
        *readed_packets_out = 0;
        *status = 0;
#if defined(_DS1401)
        *stop_time = get_time_100();
#endif
      }
    } else {
      *readed_packets_out = *readed_packets_in;
      *status = 1;
    }
  } else {
    *readed_packets_out = *readed_packets_in;
    *status = 1;
  }
}

/*====================*
 * S-function methods *
 *====================*/
/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S) {

  DECL_AND_INIT_DIMSINFO(inputDimsInfo);
  DECL_AND_INIT_DIMSINFO(outputDimsInfo);
  ssSetNumSFcnParams(S, NPARAMS);
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
    return; /* Parameter mismatch will be reported by Simulink */
  }

  ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

  ssSetNumContStates(S, NUM_CONT_STATES);
  ssSetNumDiscStates(S, NUM_DISC_STATES);

  if (!ssSetNumInputPorts(S, NUM_INPUTS))
    return;
  /* Input Port 0 */
  ssSetInputPortWidth(S, 0, INPUT_0_WIDTH);
  ssSetInputPortDataType(S, 0, SS_UINT32);
  ssSetInputPortComplexSignal(S, 0, INPUT_0_COMPLEX);
  ssSetInputPortDirectFeedThrough(S, 0, INPUT_0_FEEDTHROUGH);
  ssSetInputPortRequiredContiguous(S, 0, 1); /*direct input signal access*/

  /* Input Port 1 */
  ssSetInputPortWidth(S, 1, INPUT_1_WIDTH);
  ssSetInputPortDataType(S, 1, SS_UINT32);
  ssSetInputPortComplexSignal(S, 1, INPUT_1_COMPLEX);
  ssSetInputPortDirectFeedThrough(S, 1, INPUT_1_FEEDTHROUGH);
  ssSetInputPortRequiredContiguous(S, 1, 1); /*direct input signal access*/

  /* Input Port 2 */
  ssSetInputPortWidth(S, 2, INPUT_2_WIDTH);
  ssSetInputPortDataType(S, 2, SS_UINT32);
  ssSetInputPortComplexSignal(S, 2, INPUT_2_COMPLEX);
  ssSetInputPortDirectFeedThrough(S, 2, INPUT_2_FEEDTHROUGH);
  ssSetInputPortRequiredContiguous(S, 2, 1); /*direct input signal access*/

  /* Input Port 3 */
  ssSetInputPortWidth(S, 3, INPUT_3_WIDTH);
  ssSetInputPortDataType(S, 3, SS_UINT32);
  ssSetInputPortComplexSignal(S, 3, INPUT_3_COMPLEX);
  ssSetInputPortDirectFeedThrough(S, 3, INPUT_3_FEEDTHROUGH);
  ssSetInputPortRequiredContiguous(S, 3, 1); /*direct input signal access*/

  if (!ssSetNumOutputPorts(S, NUM_OUTPUTS))
    return;
  /* Output Port 0 */
  ssSetOutputPortWidth(S, 0, OUTPUT_0_WIDTH);
  ssSetOutputPortDataType(S, 0, SS_UINT32);
  ssSetOutputPortComplexSignal(S, 0, OUTPUT_0_COMPLEX);
  /* Output Port 1 */
  ssSetOutputPortWidth(S, 1, OUTPUT_1_WIDTH);
  ssSetOutputPortDataType(S, 1, SS_INT32);
  ssSetOutputPortComplexSignal(S, 1, OUTPUT_1_COMPLEX);
  /* Output Port 2 */
  ssSetOutputPortWidth(S, 2, OUTPUT_2_WIDTH);
  ssSetOutputPortDataType(S, 2, SS_UINT32);
  ssSetOutputPortComplexSignal(S, 2, OUTPUT_2_COMPLEX);
  /* Output Port 3 */
  ssSetOutputPortWidth(S, 3, OUTPUT_3_WIDTH);
  ssSetOutputPortDataType(S, 3, SS_UINT32);
  ssSetOutputPortComplexSignal(S, 3, OUTPUT_3_COMPLEX);
  ssSetNumPWork(S, 0);

  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);

  ssSetSimulinkVersionGeneratedIn(S, "9.0");

  /* Take care when specifying exception free code - see sfuntmpl_doc.c */
  ssSetOptions(
      S, (SS_OPTION_EXCEPTION_FREE_CODE | SS_OPTION_WORKS_WITH_CODE_REUSE));
}

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_DIMENSION_INFO
static void mdlSetInputPortDimensionInfo(SimStruct *S, int_T port,
                                         const DimsInfo_T *dimsInfo) {
  if (!ssSetInputPortDimensionInfo(S, port, dimsInfo))
    return;
}
#endif

#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
#if defined(MDL_SET_OUTPUT_PORT_DIMENSION_INFO)
static void mdlSetOutputPortDimensionInfo(SimStruct *S, int_T port,
                                          const DimsInfo_T *dimsInfo) {
  if (!ssSetOutputPortDimensionInfo(S, port, dimsInfo))
    return;
}
#endif
#define MDL_SET_INPUT_PORT_FRAME_DATA
static void mdlSetInputPortFrameData(SimStruct *S, int_T port,
                                     Frame_T frameData) {
  ssSetInputPortFrameData(S, port, frameData);
}
/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy  the sample time.
 */
static void mdlInitializeSampleTimes(SimStruct *S) {
  ssSetSampleTime(S, 0, SAMPLE_TIME_0);
  ssSetModelReferenceSampleTimeDefaultInheritance(S);
  ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S, int port, DTypeId dType) {
  ssSetInputPortDataType(S, 0, dType);
}

#define MDL_SET_OUTPUT_PORT_DATA_TYPE
static void mdlSetOutputPortDataType(SimStruct *S, int port, DTypeId dType) {
  ssSetOutputPortDataType(S, 0, dType);
}

#define MDL_SET_DEFAULT_PORT_DATA_TYPES
static void mdlSetDefaultPortDataTypes(SimStruct *S) {
  ssSetInputPortDataType(S, 0, SS_DOUBLE);
  ssSetOutputPortDataType(S, 0, SS_DOUBLE);
}

#define MDL_START /* Change to #undef to remove function */
#if defined(MDL_START)
/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S) {}
#endif /*  MDL_START */

/* Function: mdlOutputs =======================================================
 *
 */
static void mdlOutputs(SimStruct *S, int_T tid) {
  const uint32_T *packet_array = (uint32_T *)ssGetInputPortRealSignal(S, 0);
  const uint32_T *recv_bytes = (uint32_T *)ssGetInputPortRealSignal(S, 1);
  const uint32_T *buffer_id = (uint32_T *)ssGetInputPortRealSignal(S, 2);
  const uint32_T *readed_packets_in =
      (uint32_T *)ssGetInputPortRealSignal(S, 3);
  uint32_T *manoeuvre_array_out = (uint32_T *)ssGetOutputPortRealSignal(S, 0);
  int32_T *status = (int32_T *)ssGetOutputPortRealSignal(S, 1);
  uint32_T *stop_time = (uint32_T *)ssGetOutputPortRealSignal(S, 2);
  uint32_T *readed_packets_out = (uint32_T *)ssGetOutputPortRealSignal(S, 3);

  agent_packet_reader_outputs(packet_array, recv_bytes, buffer_id,
                              readed_packets_in, manoeuvre_array_out, status,
                              stop_time, readed_packets_out, S);
}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S) {}

#ifdef MATLAB_MEX_FILE /* Is this file being compiled as a MEX-file? */
#include "simulink.c"  /* MEX-file interface mechanism */
#else
#include "cg_sfun.h" /* Code generation registration function */
#endif
