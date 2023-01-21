include Agent

File.open("#{$out_dir_matlab}/#{$base_name}_packet_creator.c", "w") do |f|
  result = $objs[:in_struct].sfun_serializer
  body = <<-EOS
	// File for interfaces
	// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
	// Originf file: #{$objs[:origin_file]}
	// Origin CRC32: #{$crc}

	#define S_FUNCTION_LEVEL 2
	#define S_FUNCTION_NAME #{$base_name}_packet_creator

	#define NUM_INPUTS            4
	/* Input Port  0 */
	#define IN_PORT_0_NAME        scenario_array
	#define INPUT_0_WIDTH         #{result[:output_size]}
	#define INPUT_DIMS_0_COL      1
	#define INPUT_0_DTYPE         uint32_T
	#define INPUT_0_COMPLEX       COMPLEX_NO
	#define IN_0_FRAME_BASED      FRAME_NO
	#define IN_0_BUS_BASED        0
	#define IN_0_BUS_NAME
	#define IN_0_DIMS             1-D
	#define INPUT_0_FEEDTHROUGH   1
	#define IN_0_ISSIGNED         0
	#define IN_0_WORDLENGTH       8
	#define IN_0_FIXPOINTSCALING  1
	#define IN_0_FRACTIONLENGTH   9
	#define IN_0_BIAS             0
	#define IN_0_SLOPE            0.125
	/* Input Port  1 */
	#define IN_PORT_1_NAME        part_pos
	#define INPUT_1_WIDTH         1
	#define INPUT_DIMS_1_COL      1
	#define INPUT_1_DTYPE         uint32_T
	#define INPUT_1_COMPLEX       COMPLEX_NO
	#define IN_1_FRAME_BASED      FRAME_NO
	#define IN_1_BUS_BASED        0
	#define IN_1_BUS_NAME
	#define IN_1_DIMS             1-D
	#define INPUT_1_FEEDTHROUGH   1
	#define IN_1_ISSIGNED         0
	#define IN_1_WORDLENGTH       8
	#define IN_1_FIXPOINTSCALING  1
	#define IN_1_FRACTIONLENGTH   9
	#define IN_1_BIAS             0
	#define IN_1_SLOPE            0.125
	/* Input Port  2 */
	#define IN_PORT_2_NAME        server_run
	#define INPUT_2_WIDTH         1
	#define INPUT_DIMS_2_COL      1
	#define INPUT_2_DTYPE         uint32_T
	#define INPUT_2_COMPLEX       COMPLEX_NO
	#define IN_2_FRAME_BASED      FRAME_NO
	#define IN_2_BUS_BASED        0
	#define IN_2_BUS_NAME
	#define IN_2_DIMS             1-D
	#define INPUT_2_FEEDTHROUGH   1
	#define IN_2_ISSIGNED         0
	#define IN_2_WORDLENGTH       8
	#define IN_2_FIXPOINTSCALING  1
	#define IN_2_FRACTIONLENGTH   9
	#define IN_2_BIAS             0
	#define IN_2_SLOPE            0.125
	/* Input Port  3 */
	#define IN_PORT_3_NAME        datagram_id
	#define INPUT_3_WIDTH         1
	#define INPUT_DIMS_3_COL      1
	#define INPUT_3_DTYPE         uint32_T
	#define INPUT_3_COMPLEX       COMPLEX_NO
	#define IN_3_FRAME_BASED      FRAME_NO
	#define IN_3_BUS_BASED        0
	#define IN_3_BUS_NAME
	#define IN_3_DIMS             1-D
	#define INPUT_3_FEEDTHROUGH   1
	#define IN_3_ISSIGNED         0
	#define IN_3_WORDLENGTH       8
	#define IN_3_FIXPOINTSCALING  1
	#define IN_3_FRACTIONLENGTH   9
	#define IN_3_BIAS             0
	#define IN_3_SLOPE            0.125

	#define NUM_OUTPUTS           2
	/* Output Port  0 */
	#define OUT_PORT_0_NAME       packet_array
	#define OUTPUT_0_WIDTH        368
	#define OUTPUT_DIMS_0_COL     1
	#define OUTPUT_0_DTYPE        uint32_T
	#define OUTPUT_0_COMPLEX      COMPLEX_NO
	#define OUT_0_FRAME_BASED     FRAME_NO
	#define OUT_0_BUS_BASED       0
	#define OUT_0_BUS_NAME
	#define OUT_0_DIMS            1-D
	#define OUT_0_ISSIGNED        1
	#define OUT_0_WORDLENGTH      8
	#define OUT_0_FIXPOINTSCALING 1
	#define OUT_0_FRACTIONLENGTH  3
	#define OUT_0_BIAS            0
	#define OUT_0_SLOPE           0.125
	/* Output Port  1 */
	#define OUT_PORT_1_NAME       while_run
	#define OUTPUT_1_WIDTH        1
	#define OUTPUT_DIMS_1_COL     1
	#define OUTPUT_1_DTYPE        uint32_T
	#define OUTPUT_1_COMPLEX      COMPLEX_NO
	#define OUT_1_FRAME_BASED     FRAME_NO
	#define OUT_1_BUS_BASED       0
	#define OUT_1_BUS_NAME
	#define OUT_1_DIMS            1-D
	#define OUT_1_ISSIGNED        1
	#define OUT_1_WORDLENGTH      8
	#define OUT_1_FIXPOINTSCALING 1
	#define OUT_1_FRACTIONLENGTH  3
	#define OUT_1_BIAS            0
	#define OUT_1_SLOPE           0.125

	#define NPARAMS               0

	#define SAMPLE_TIME_0         INHERITED_SAMPLE_TIME
	#define NUM_DISC_STATES       0
	#define DISC_STATES_IC        [0,0]
	#define NUM_CONT_STATES       0
	#define CONT_STATES_IC        [0]

	#define SFUNWIZ_GENERATE_TLC  0
	#define PANELINDEX            6
	#define USE_SIMSTRUCT         1
	#define SHOW_COMPILE_STEPS    0
	#define CREATE_DEBUG_MEXFILE  0
	#define SAVE_CODE_ONLY        0
	#define SFUNWIZ_REVISION      3.0

	#include "simstruc.h"

	#include <stdio.h>
	#include <string.h>
	#include <math.h>
	#include <assert.h>

	#if defined(__linux__) || defined(__MACH__)
		#include <unistd.h> // necessary for usleep function in MAC OS X / Linux
	#endif

	#include "udp_defines.h"

	#include "interfaces_data_structs.h"

	#define u_width #{result[:output_size]}
	#define y_width 1
	#define TIME_SLEEP_MS 10


	// ===================== Previous WRAPPER FUNCTION BODY =====================

	static void swapBytes(void *dest, void *src, int size, int num) {
		uint8_T *dest1, *src1, i;

		assert(src != dest);
		dest1 = dest;
		src1  = src;

		if (size == 1) {
			memcpy(dest1, src1, num);
			return;
		}
		while (num--) {
			for (i = 0; i < size; i++)
				dest1[i] = src1[size-i-1];
			dest1 += size;
			src1  += size;
		}
		return;
	}

	static void agent_packet_creator_output(const uint32_T *scenario_array,
				const uint32_T *part_pos,
				const uint32_T *server_run,
				const uint32_T *datagram_id,
				uint32_T *packet_array,
				uint32_T *while_run,
				SimStruct *S)
		{
		packet_t packet;
		UDP_UINT n_packets;
		UDP_UINT last_part_pos;
		size_t remaining_bytes;
		size_t part_bytes;
		size_t part_size;

		size_t scenario_array_size = (size_t) ssGetInputPortWidth(S,0)*sizeof(uint32_T);


		n_packets = (UDP_UINT) ceilf((float) (scenario_array_size/PART_BYTES))+1;
		remaining_bytes = (size_t) scenario_array_size % PART_BYTES;

		part_bytes = (size_t) PART_BYTES;
		last_part_pos = n_packets-1;


		swapBytes((void *) &packet.data_struct.server_run,    (void *) server_run,     sizeof(uint32_T), 1);
		swapBytes((void *) &packet.data_struct.part_pos,      (void *) part_pos,       sizeof(uint32_T), 1);
		swapBytes((void *) &packet.data_struct.last_part_pos, (void *) &last_part_pos, sizeof(uint32_T), 1);
		swapBytes((void *) &packet.data_struct.datagram_id,   (void *) datagram_id,    sizeof(uint32_T), 1);

		if (*part_pos < last_part_pos) {
			part_size = part_bytes;
			swapBytes((void *) &packet.data_struct.part_size, (void *) &part_bytes, sizeof(uint32_T), 1);
			*while_run = 0;
		}
		else {
			part_size = remaining_bytes;
			swapBytes((void *) &packet.data_struct.part_size, (void *) &remaining_bytes, sizeof(uint32_T), 1);
			*while_run = 1;
		}

		#if defined(_DS1401) || defined(__MACH__) || defined(__linux__)
		memcpy(&packet.data_struct.datagram_part, (void *) scenario_array+((size_t) *part_pos)*sizeof(packet.data_struct.datagram_part), part_size);
		#elif defined(_WIN32)
		memcpy(&packet.data_struct.datagram_part, (uint8_T *) scenario_array+((size_t) *part_pos)*sizeof(packet.data_struct.datagram_part), part_size);
		#endif

		#if defined(_DS1401) || defined(__MACH__) || defined(__linux__)
		memcpy((void *) packet_array, (void *) packet.data_array, (size_t) PACKET_BYTES);
		#elif defined(_WIN32)
		memcpy((void *) packet_array, (void *) packet.data_array, (size_t) PACKET_BYTES);
		#endif
		}

	// ===========================================================================


	/*====================*
		* S-function methods *
		*====================*/
	/* Function: mdlInitializeSizes ===============================================
		* Abstract:
		*   Setup sizes of the various vectors.
		*/

	static void mdlInitializeSizes(SimStruct *S)
	{

		DECL_AND_INIT_DIMSINFO(inputDimsInfo);
		DECL_AND_INIT_DIMSINFO(outputDimsInfo);
		ssSetNumSFcnParams(S, NPARAMS);
		if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
			return; /* Parameter mismatch will be reported by Simulink */
		}

		ssSetNumContStates(S, NUM_CONT_STATES);
		ssSetNumDiscStates(S, NUM_DISC_STATES);


		if (!ssSetNumInputPorts(S, NUM_INPUTS)) return;
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


		if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) return;
		/* Output Port 0 */
		ssSetOutputPortWidth(S, 0, OUTPUT_0_WIDTH);
		ssSetOutputPortDataType(S, 0, SS_UINT32);
		ssSetOutputPortComplexSignal(S, 0, OUTPUT_0_COMPLEX);
		/* Output Port 1 */
		ssSetOutputPortWidth(S, 1, OUTPUT_1_WIDTH);
		ssSetOutputPortDataType(S, 1, SS_UINT32);
		ssSetOutputPortComplexSignal(S, 1, OUTPUT_1_COMPLEX);
		ssSetNumPWork(S, 0);

		ssSetNumSampleTimes(S, 1);
		ssSetNumRWork(S, 0);
		ssSetNumIWork(S, 0);
		ssSetNumPWork(S, 0);
		ssSetNumModes(S, 0);
		ssSetNumNonsampledZCs(S, 0);

		ssSetSimulinkVersionGeneratedIn(S, "9.0");

		/* Take care when specifying exception free code - see sfuntmpl_doc.c */
		ssSetOptions(S, (SS_OPTION_EXCEPTION_FREE_CODE |
							SS_OPTION_WORKS_WITH_CODE_REUSE));
	}

	#if defined(MATLAB_MEX_FILE)
	#define MDL_SET_INPUT_PORT_DIMENSION_INFO
	static void mdlSetInputPortDimensionInfo(SimStruct        *S,
												int_T            port,
												const DimsInfo_T *dimsInfo)
	{
		if(!ssSetInputPortDimensionInfo(S, port, dimsInfo)) return;
	}
	#endif

	#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
	#if defined(MDL_SET_OUTPUT_PORT_DIMENSION_INFO)
	static void mdlSetOutputPortDimensionInfo(SimStruct        *S,
												int_T            port,
												const DimsInfo_T *dimsInfo)
	{
		if (!ssSetOutputPortDimensionInfo(S, port, dimsInfo)) return;
	}
	#endif
	#define MDL_SET_INPUT_PORT_FRAME_DATA
	static void mdlSetInputPortFrameData(SimStruct  *S,
											int_T      port,
											Frame_T    frameData)
	{
		ssSetInputPortFrameData(S, port, frameData);
	}
	/* Function: mdlInitializeSampleTimes =========================================
		* Abstract:
		*    Specifiy  the sample time.
		*/
	static void mdlInitializeSampleTimes(SimStruct *S)
	{
		ssSetSampleTime(S, 0, SAMPLE_TIME_0);
		ssSetModelReferenceSampleTimeDefaultInheritance(S);
		ssSetOffsetTime(S, 0, 0.0);
	}

	#define MDL_SET_INPUT_PORT_DATA_TYPE
	static void mdlSetInputPortDataType(SimStruct *S, int port, DTypeId dType)
	{
		ssSetInputPortDataType(S, 0, dType);
	}

	#define MDL_SET_OUTPUT_PORT_DATA_TYPE
	static void mdlSetOutputPortDataType(SimStruct *S, int port, DTypeId dType)
	{
		ssSetOutputPortDataType(S, 0, dType);
	}

	#define MDL_SET_DEFAULT_PORT_DATA_TYPES
	static void mdlSetDefaultPortDataTypes(SimStruct *S)
	{
		ssSetInputPortDataType(S, 0, SS_DOUBLE);
		ssSetOutputPortDataType(S, 0, SS_DOUBLE);
	}

	/* Function: mdlOutputs =======================================================
		*
		*/
	static void mdlOutputs(SimStruct *S, int_T tid)
	{
		const uint32_T *scenario_array = (const uint32_T *) ssGetInputPortSignal(S, 0);
		const uint32_T *part_pos = (const uint32_T *) ssGetInputPortSignal(S, 1);
		const uint32_T *server_run = (const uint32_T *) ssGetInputPortSignal(S, 2);
		const uint32_T *datagram_id = (const uint32_T *) ssGetInputPortSignal(S, 3);
		uint32_T *packet_array = (uint32_T *) ssGetOutputPortRealSignal(S, 0);
		uint32_T *while_run = (uint32_T *) ssGetOutputPortRealSignal(S, 1);

		/*  function call */
		#if defined(_WIN32)
		Sleep(TIME_SLEEP_MS);
		#elif defined(__MACH__) || (__linux__)
		usleep(1000*TIME_SLEEP_MS); // 1000 factor used to convert from millisecond to microsecond
		#endif
		agent_packet_creator_output(scenario_array, part_pos, server_run, datagram_id, packet_array, while_run, S);

	}


	/* Function: mdlTerminate =====================================================
		* Abstract:
		*    In this function, you should perform any actions that are necessary
		*    at the termination of a simulation.  For example, if memory was
		*    allocated in mdlStart, this is the place to free it.
		*/
	static void mdlTerminate(SimStruct *S)
	{

	}


	#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
	#include "simulink.c"      /* MEX-file interface mechanism */
	#else
	#include "cg_sfun.h"       /* Code generation registration function */
	#endif
  EOS
  f.puts Agent::clang_format(body, $clang_format)
end

puts "File #{$out_dir_matlab}/#{$base_name}_packet_creator.c generated"
