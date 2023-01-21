include Agent

File.open("#{$out_dir_matlab}/#{$base_name}_scenario_serializer.c", "w") do |f|
	result = $objs[:in_struct].sfun_serializer
	body = <<-EOS
		// File for interfaces
		// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
		// Originf file: #{$objs[:origin_file]}
		// Origin CRC32: #{$crc}

		#define S_FUNCTION_LEVEL 2
		#define S_FUNCTION_NAME #{$base_name}_scenario_serializer

		#define NUM_INPUTS  #{result[:n_inputs]}
		#define NUM_OUTPUTS 2

		#define N_PARAMS        0
		#define SAMPLE_TIME_0   INHERITED_SAMPLE_TIME
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
		#{result[:inputs_set].join("\n")}

		// Outputs ------------------------------------------------------------
		if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) {
			return;
		}
		// Output port 0
		ssSetOutputPortWidth(S, 0, #{result[:output_size]});
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
		static void mdlSetInputPortDimensionInfo(SimStruct        *S,
												int_T            port,
												const DimsInfo_T *dimsInfo) {
		if(!ssSetInputPortDimensionInfo(S, port, dimsInfo)) {
			return;
		}
		}
		#endif

		#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
		#if defined(MDL_SET_OUTPUT_PORT_DIMENSION_INFO)
		static void mdlSetOutputPortDimensionInfo(SimStruct        *S,
												int_T            port,
												const DimsInfo_T *dimsInfo) {
		if (!ssSetOutputPortDimensionInfo(S, port, dimsInfo)) {
			return;
		}
		}
		#endif
		#define MDL_SET_INPUT_PORT_FRAME_DATA
		static void mdlSetInputPortFrameData(SimStruct  *S,
											int_T      port,
											Frame_T    frameData) {
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
		#{result[:inputs_data_type].join("\n")}
		ssSetOutputPortDataType(S, 0, SS_UINT32);
		ssSetOutputPortDataType(S, 1, SS_UINT32);
		}

		// Function: mdlOutputs ===============================================
		static void mdlOutputs(SimStruct *S, int_T tid) {
			const void *input_array;
			uint32_T   *output_array      = (uint32_T *) ssGetOutputPortSignal(S, 0);
			uint32_T   *output_time       = (uint32_T *) ssGetOutputPortSignal(S, 1);
			DTypeId     input_data_type;
			size_t      mem_pos           = 0;
			int_T       input_array_width;
			size_t      input_array_bytes;
			int_T       i, j;

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
					input_array_bytes = (size_t) input_array_width * sizeof(int32_T);
					memcpy((char *) output_array + mem_pos, input_array, input_array_bytes);
					break;
				case SS_DOUBLE:
					input_array_bytes = (size_t) input_array_width * sizeof(real_T);
		#if defined(_DS1401)
					// Write a double in two uint32_T changing the order
					// This is readable by unix and windows systems
					for (j = 0; j < input_array_width; j++) {
					memcpy((void *) output_array + mem_pos + j*sizeof(real_T),
							input_array + j*sizeof(real_T) + sizeof(uint32_T),
							sizeof(uint32_T));
					memcpy((void *) output_array + mem_pos + j*sizeof(real_T) + sizeof(uint32_T),
							input_array + j*sizeof(real_T),
							sizeof(uint32_T));
					}
		#else
					memcpy((char *) output_array + mem_pos, input_array, input_array_bytes);
		#endif
					break;
				default:
					ssPrintf("Cannot serialize input data type %d\\n", input_data_type);
					return;
			}
			mem_pos += input_array_bytes;
			}
		}

		// Function: mdlTerminate =============================================
		static void mdlTerminate(SimStruct *S) {
		}

		#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
		#include "simulink.c"      /* MEX-file interface mechanism */
		#else
		#include "cg_sfun.h"       /* Code generation registration function */
		#endif
	EOS
	f.puts Agent::clang_format(body, $clang_format)
end

puts "File #{$out_dir_matlab}/#{$base_name}_scenario_serializer.c generated"