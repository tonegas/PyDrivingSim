include Agent

File.open("#{$out_dir_matlab}/#{$base_name}_manoeuvre_deserializer.c", "w") do |f|
	result = $objs[:out_struct].sfun_deserializer
	body = <<-EOS
		// File for interfaces
		// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
		// Originf file: #{$objs[:origin_file]}
		// Origin CRC32: #{$crc}

		#define S_FUNCTION_LEVEL 2
		#define S_FUNCTION_NAME #{$base_name}_manoeuvre_deserializer

		#define NUM_INPUTS  1
		#define NUM_OUTPUTS #{result[:n_outputs]}

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
		// Input Port 0
		ssSetInputPortWidth(S, 0, #{result[:input_size]});
		ssSetInputPortDataType(S, 0, SS_UINT32);
		ssSetInputPortDirectFeedThrough(S, 0, 1);
		ssSetInputPortRequiredContiguous(S, 0, 1); // direct input signal access

		// Outputs ------------------------------------------------------------
		if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) {
			return;
		}
		#{result[:outputs_set].join("\n")}

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

		// Function: mdlInitializeSampleTimes ===================================
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
		ssSetInputPortDataType(S, 0, SS_UINT32);
		#{result[:outputs_data_type].join("\n")}
		}

		// Function: mdlOutputs =================================================
		static void mdlOutputs(SimStruct *S, int_T tid) {
			const uint32_T *input_array           = (uint32_T *) ssGetInputPortSignal(S, 0);
			void           *output_array;
			DTypeId         output_data_type;
			size_t          mem_pos               = 0;
			int_T           output_array_width;
			size_t          output_array_bytes;
			int_T           i, j;

			UNUSED_ARG(tid);

			for(i=0; i<NUM_OUTPUTS; i++) {
			output_array = ssGetOutputPortSignal(S, i);
			output_array_width = ssGetOutputPortWidth(S, i);
			output_data_type = ssGetOutputPortDataType(S, i);
			switch (output_data_type) {
				case SS_INT32:
					output_array_bytes = (size_t) output_array_width * sizeof(int32_T);
					memcpy(output_array,(char *) input_array + mem_pos, output_array_bytes);
					break;
				case SS_DOUBLE:
					output_array_bytes = (size_t) output_array_width * sizeof(real_T);
		#if defined(_DS1401)
					// Read a double from two uint32_T changing the order
					// This is readable by unix and windows systems
					for(j=0; j<output_array_width; j++) {
					memcpy(output_array + j*sizeof(real_T),
							(void *) input_array + mem_pos + j*sizeof(real_T) + sizeof(uint32_T),
							sizeof(uint32_T));
					memcpy(output_array + j*sizeof(real_T) + sizeof(uint32_T),
							(void *) input_array + mem_pos + j*sizeof(real_T),
							sizeof(uint32_T));
					}
		#else
					memcpy(output_array,(char *) input_array + mem_pos, output_array_bytes);
		#endif
					break;
				default:
					ssPrintf("Cannot deserialize output data type %d\\n", output_data_type);
					return;
			}
			mem_pos += output_array_bytes;
			}
		}

		// Function: mdlTerminate ===============================================
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

puts "File #{$out_dir_matlab}/#{$base_name}_manoeuvre_deserializer.c generated"