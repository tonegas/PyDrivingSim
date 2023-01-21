include Agent

File.open("#{$out_dir_matlab}/#{$base_name}_UDP_client.c", "w") do |f|
	body = <<-EOS
		// File for interfaces
		// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
		// Originf file: #{$objs[:origin_file]}
		// Origin CRC32: #{$crc}

		#define S_FUNCTION_LEVEL 2
		#define S_FUNCTION_NAME #{$base_name}_UDP_client

		#define NUM_INPUTS          1
		/* Input Port  0 */
		#define IN_PORT_0_NAME      scenario_struct
		#define INPUT_0_WIDTH       1
		#define INPUT_DIMS_0_COL    1
		#define INPUT_0_DTYPE       real_T
		#define INPUT_0_COMPLEX     COMPLEX_NO
		#define IN_0_FRAME_BASED    FRAME_NO
		#define IN_0_BUS_BASED      1
		#define IN_0_BUS_NAME       input_data_str
		#define IN_0_DIMS           1-D
		#define INPUT_0_FEEDTHROUGH 1
		#define IN_0_ISSIGNED        0
		#define IN_0_WORDLENGTH      8
		#define IN_0_FIXPOINTSCALING 1
		#define IN_0_FRACTIONLENGTH  9
		#define IN_0_BIAS            0
		#define IN_0_SLOPE           0.125

		#define NUM_OUTPUTS          1
		/* Output Port  0 */
		#define OUT_PORT_0_NAME      manoeuvre_struct
		#define OUTPUT_0_WIDTH       1
		#define OUTPUT_DIMS_0_COL    1
		#define OUTPUT_0_DTYPE       real_T
		#define OUTPUT_0_COMPLEX     COMPLEX_NO
		#define OUT_0_FRAME_BASED    FRAME_NO
		#define OUT_0_BUS_BASED      1
		#define OUT_0_BUS_NAME       output_data_str
		#define OUT_0_DIMS           1-D
		#define OUT_0_ISSIGNED        1
		#define OUT_0_WORDLENGTH      8
		#define OUT_0_FIXPOINTSCALING 1
		#define OUT_0_FRACTIONLENGTH  3
		#define OUT_0_BIAS            0
		#define OUT_0_SLOPE           0.125

		#define NPARAMS              2
		/* Parameter  1 */
		#define PARAMETER_0_NAME      server_ip
		#define PARAMETER_0_DTYPE     uint8_T
		#define PARAMETER_0_COMPLEX   COMPLEX_NO
		/* Parameter  2 */
		#define PARAMETER_1_NAME      server_port
		#define PARAMETER_1_DTYPE     uint16_T
		#define PARAMETER_1_COMPLEX   COMPLEX_NO

		#define SAMPLE_TIME_0        INHERITED_SAMPLE_TIME
		#define NUM_DISC_STATES      2
		#define DISC_STATES_IC       [0,0]
		#define NUM_CONT_STATES      0
		#define CONT_STATES_IC       [0]

		#include "simstruc.h"

		#include "UDP_limit_defines.h"
		#include "interfaces_data_structs.h"

		/* Code Generation Environment flag (simulation or standalone target). */
		
		static int_T isSimulationTarget;
		/*  Utility function prototypes. */
		
		static int_T GetRTWEnvironmentMode(SimStruct *S);
		/* Macro used to check if Simulation mode is set to accelerator */
		#define isDWorkPresent (((!ssRTWGenIsCodeGen(S) || isSimulationTarget) && !ssIsExternalSim(S))  || ssIsRapidAcceleratorActive(S))
		#define PARAM_DEF0(S) ssGetSFcnParam(S, 0)
		#define PARAM_DEF1(S) ssGetSFcnParam(S, 1)

		#define IS_PARAM_UINT8(pVal) (mxIsNumeric(pVal) && !mxIsLogical(pVal) &&\
		!mxIsEmpty(pVal) && !mxIsSparse(pVal) && !mxIsComplex(pVal) && mxIsUint8(pVal))

		#define IS_PARAM_UINT16(pVal) (mxIsNumeric(pVal) && !mxIsLogical(pVal) &&\
		!mxIsEmpty(pVal) && !mxIsSparse(pVal) && !mxIsComplex(pVal) && mxIsUint16(pVal))

		/*====================*
		 * S-function methods *
		 *====================*/

		#define MDL_CHECK_PARAMETERS
		#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)
		/* Function: mdlCheckParameters =============================================
		 * Abstract:
		 *	Validate our parameters to verify they are okay.
		 */
		static void mdlCheckParameters(SimStruct *S){
			int paramIndex  = 0;
			bool validParam = false;
			/* All parameters must match the S-function Builder Dialog */
			{
				const mxArray *pVal0 = ssGetSFcnParam(S,0);
				if (!IS_PARAM_UINT8(pVal0)) {
					validParam = true;
					paramIndex = 0;
					goto EXIT_POINT;
				}
			}
			{
				const mxArray *pVal1 = ssGetSFcnParam(S,1);
				if (!IS_PARAM_UINT16(pVal1)) {
					validParam = true;
					paramIndex = 1;
					goto EXIT_POINT;
				}
			}
			EXIT_POINT:
				if (validParam) {
					char parameterErrorMsg[1024];
					sprintf(parameterErrorMsg, "The data type and or complexity of parameter  %d does not match the "
						  "information specified in the S-function Builder dialog. "
						  "For non-double parameters you will need to cast them using int8, int16, "
						  "int32, uint8, uint16, uint32 or boolean.", paramIndex + 1);
					ssSetErrorStatus(S,parameterErrorMsg);
				}
				return;
		}
		#endif /* MDL_CHECK_PARAMETERS */

		/* Function: mdlInitializeSizes ===============================================
		 * Abstract:
		 *   Setup sizes of the various vectors.
		 */
		static void mdlInitializeSizes(SimStruct *S){

			ssSetNumSFcnParams(S, NPARAMS);  /* Number of expected parameters */
			#if defined(MATLAB_MEX_FILE)
			if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
				mdlCheckParameters(S);
				if (ssGetErrorStatus(S) != NULL) {
					return;
				}
			} else {
				return; /* Parameter mismatch will be reported by Simulink */
			}
			#endif

			ssSetNumContStates(S, NUM_CONT_STATES);
			ssSetNumDiscStates(S, NUM_DISC_STATES);

			if (!ssSetNumInputPorts(S, NUM_INPUTS)) return;

			/* Register input_data_str datatype for Input port 0 */

			#if defined(MATLAB_MEX_FILE)
			if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
				DTypeId dataTypeIdReg;
				ssRegisterTypeFromNamedObject(S, "input_data_str", &dataTypeIdReg);
				if(dataTypeIdReg == INVALID_DTYPE_ID) return;
				ssSetInputPortDataType(S,0, dataTypeIdReg);
			}
			#endif

			ssSetInputPortWidth(S, 0, INPUT_0_WIDTH);
			ssSetInputPortComplexSignal(S, 0, INPUT_0_COMPLEX);
			ssSetInputPortDirectFeedThrough(S, 0, INPUT_0_FEEDTHROUGH);
			ssSetInputPortRequiredContiguous(S, 0, 1); /*direct input signal access*/
			ssSetBusInputAsStruct(S, 0,IN_0_BUS_BASED);
			ssSetInputPortBusMode(S, 0, SL_BUS_MODE);

			if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) return;

			/* Register output_data_str datatype for Output port 0 */

			#if defined(MATLAB_MEX_FILE)
			if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
				DTypeId dataTypeIdReg;
				ssRegisterTypeFromNamedObject(S, "output_data_str", &dataTypeIdReg);
				if(dataTypeIdReg == INVALID_DTYPE_ID) return;
				ssSetOutputPortDataType(S,0, dataTypeIdReg);
			}
			#endif

			ssSetBusOutputObjectName(S, 0, (void *) "output_data_str");
			ssSetOutputPortWidth(S, 0, OUTPUT_0_WIDTH);
			ssSetOutputPortComplexSignal(S, 0, OUTPUT_0_COMPLEX);
			ssSetBusOutputAsStruct(S, 0,OUT_0_BUS_BASED);
			ssSetOutputPortBusMode(S, 0, SL_BUS_MODE);

			if (ssRTWGenIsCodeGen(S)) {
				isSimulationTarget = GetRTWEnvironmentMode(S);
				if (isSimulationTarget==-1) {
					ssSetErrorStatus(S, " Unable to determine a valid code generation environment mode");
					return;
				}
				isSimulationTarget |= ssRTWGenIsModelReferenceSimTarget(S);
			}

			/* Set the number of dworks */
			if (!isDWorkPresent) {
				if (!ssSetNumDWork(S, 0)) return;
			} else {
				if (!ssSetNumDWork(S, 2)) return;
			}

			if (isDWorkPresent) {
				/*
				* Configure the dwork 0 (u0."BUS")
				*/
				#if defined(MATLAB_MEX_FILE)
				if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
					DTypeId dataTypeIdReg;
					ssRegisterTypeFromNamedObject(S, "input_data_str", &dataTypeIdReg);
					if (dataTypeIdReg == INVALID_DTYPE_ID) return;
					ssSetDWorkDataType(S, 0, dataTypeIdReg);
				}
				#endif

				ssSetDWorkUsageType(S, 0, SS_DWORK_USED_AS_DWORK);
				ssSetDWorkName(S, 0, "u0BUS");
				ssSetDWorkWidth(S, 0, DYNAMICALLY_SIZED);
				ssSetDWorkComplexSignal(S, 0, COMPLEX_NO);

				/*
				* Configure the dwork 1 (y0BUS)
				*/

				#if defined(MATLAB_MEX_FILE)
				if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
					DTypeId dataTypeIdReg;
					ssRegisterTypeFromNamedObject(S, "output_data_str", &dataTypeIdReg);
					if (dataTypeIdReg == INVALID_DTYPE_ID) return;
					ssSetDWorkDataType(S, 1, dataTypeIdReg);
				}
				#endif

				ssSetDWorkUsageType(S, 1, SS_DWORK_USED_AS_DWORK);
				ssSetDWorkName(S, 1, "y0BUS");
				ssSetDWorkWidth(S, 1, DYNAMICALLY_SIZED);
				ssSetDWorkComplexSignal(S, 1, COMPLEX_NO);
			}

			ssSetNumSampleTimes(S, 1);
			ssSetNumRWork(S, 0);
			ssSetNumIWork(S, 0);
			ssSetNumPWork(S, 0);
			ssSetNumModes(S, 0);
			ssSetNumNonsampledZCs(S, 0);
			ssSetSimulinkVersionGeneratedIn(S, "8.6");

			/* Take care when specifying exception free code - see sfuntmpl_doc.c */
			ssSetOptions(S, (SS_OPTION_EXCEPTION_FREE_CODE | 
							 SS_OPTION_WORKS_WITH_CODE_REUSE |
							 SS_OPTION_CALL_TERMINATE_ON_EXIT));
		}

		# define MDL_SET_INPUT_PORT_FRAME_DATA
		static void mdlSetInputPortFrameData(SimStruct  *S, int_T port, Frame_T    frameData) {
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

		#define MDL_INITIALIZE_CONDITIONS
		/* Function: mdlInitializeConditions ========================================
		 * Abstract:
		 *    Initialize the states
		 */
		static void mdlInitializeConditions(SimStruct *S) {
			real_T *xD   = ssGetRealDiscStates(S);
			xD[0] =  0;
			xD[1] =  0;
		}
		
		#define MDL_START  /* Change to #undef to remove function */

		/* Bus info data struct for simulink */
		int_T busINInfo[2][#{$objs[:in_struct].sfun_struct_size}];
		int_T busOUTInfo[2][#{$objs[:out_struct].sfun_struct_size}];

		#if defined(MDL_START)
		/* Function: mdlStart =======================================================
		* Abstract:
		*    This function is called once at start of model execution. If you
		*    have states that should be initialized once, this is the place
		*    to do it.
		*/
		static void mdlStart(SimStruct *S) {
			/* Bus Information */
			slDataTypeAccess *dta = ssGetDataTypeAccess(S);
			const char *bpath = ssGetPath(S);
			DTypeId input_data_strId = ssGetDataTypeId(S, "input_data_str");
			DTypeId output_data_strId = ssGetDataTypeId(S, "output_data_str");
		
			/* Calculate offsets of all primitive elements of the busIN */
			#{$objs[:in_struct].sfun_udp_client_busIN_init}

			/* Calculate offsets of all primitive elements of the busOUT */
			#{$objs[:out_struct].sfun_udp_client_busOUT_init}
		}
		#endif /*  MDL_START */

		#define MDL_SET_INPUT_PORT_DATA_TYPE
		static void mdlSetInputPortDataType(SimStruct *S, int port, DTypeId dType) {
			ssSetInputPortDataType( S, 0, dType);
		}

		#define MDL_SET_OUTPUT_PORT_DATA_TYPE
		static void mdlSetOutputPortDataType(SimStruct *S, int port, DTypeId dType) {
			ssSetOutputPortDataType(S, 0, dType);
		}

		#define MDL_SET_DEFAULT_PORT_DATA_TYPES
		static void mdlSetDefaultPortDataTypes(SimStruct *S) {
			ssSetInputPortDataType( S, 0, SS_DOUBLE);
			ssSetOutputPortDataType(S, 0, SS_DOUBLE);
		}

		#define MDL_SET_WORK_WIDTHS
		#if defined(MDL_SET_WORK_WIDTHS) && defined(MATLAB_MEX_FILE)
		static void mdlSetWorkWidths(SimStruct *S) {
			/* Set the width of DWork(s) used for marshalling the IOs */
			if (isDWorkPresent) {

				/* Update dwork 0 */
				ssSetDWorkWidth(S, 0, ssGetInputPortWidth(S, 0));

				 /* Update dwork 1 */
				 ssSetDWorkWidth(S, 1, ssGetOutputPortWidth(S, 0));
			}
		}
		#endif

		/* Function: mdlOutputs =======================================================
		 *
         */
		static void mdlOutputs(SimStruct *S, int_T tid) {
			const char *scenario_bus = (char *) ssGetInputPortSignal(S,0);
			char *manoeuvre_bus = (char *) ssGetOutputPortSignal(S,0);
			const real_T   *xD = ssGetDiscStates(S);
			const int_T   p_width0  = mxGetNumberOfElements(PARAM_DEF0(S));
			const int_T   p_width1  = mxGetNumberOfElements(PARAM_DEF1(S));
			const uint8_T  *server_ip  = (const uint8_T *)mxGetData(PARAM_DEF0(S));
			const uint16_T  *server_port  = (const uint16_T *)mxGetData(PARAM_DEF1(S));

			/* Temporary bus copy declarations */
			scenario_msg_t scenario;
			manoeuvre_msg_t manoeuvre;

			/*Copy input bus into temporary structure*/
			#{$objs[:in_struct].sfun_udp_client_copy_scenario}

			//adaptive_UDP_limit_client_Outputs_wrapper(&scenario_bus, &manoeuvre_bus, xD, server_ip, p_width0, server_port, p_width1, S);

			/*Copy temporary structure into output bus*/
			#{$objs[:out_struct].sfun_udp_client_copy_manoeuvre}
		}

		#define MDL_UPDATE  /* Change to #undef to remove function */
		/* Function: mdlUpdate ======================================================
	 	 * Abstract:
		 *    This function is called once for every major integration time step.
		 *    Discrete states are typically updated here, but this function is useful
		 *    for performing any tasks that should only take place once per
		 *    integration step.
		 */
		static void mdlUpdate(SimStruct *S, int_T tid) { }

		/* Function: mdlTerminate =====================================================
		 * Abstract:
		 *    In this function, you should perform any actions that are necessary
		 *    at the termination of a simulation.  For example, if memory was
		 *    allocated in mdlStart, this is the place to free it.
		 */
		static void mdlTerminate(SimStruct *S) {
			scenario_msg_t  scenario_msg;
			size_t scenario_msg_size;
			UDP_UINT message_id;
			UDP_UINT server_run;

			ssPrintf("Requesting stop server and closing socket..\\n");
    
			// Added stop server request
			scenario_msg_size  = sizeof(scenario_msg.data_buffer);
			message_id  = 0;
			server_run  = 1;
			memset(scenario_msg.data_buffer, 0, scenario_msg_size);
			/*
			if (send_message(server_run, message_id, scenario_msg.data_buffer, scenario_msg_size) == -1) {
				ssPrintf("Warning! Could not send the message with ID %d\\n", message_id);
				ssPrintf("Output message: manoeuvre not calculated\\n");
			}
			
			// Added close socket
			if(close_socket() == -1) {
				ssPrintf("Error closing socket\\n");
			}
			*/
			ssPrintf("Done\\n");
		}
		
		static int_T GetRTWEnvironmentMode(SimStruct *S) {
			int_T status = -1;
			mxArray *plhs[1];
			mxArray *prhs[1];
			int_T err;

			/*
			 * Get the name of the Simulink block diagram
			 */
			prhs[0] = mxCreateString(ssGetModelName(ssGetRootSS(S)));
			plhs[0] = NULL;

			/*
			 * Call "isSimulationTarget = rtwenvironmentmode(modelName)" in MATLAB
			 */
			mexSetTrapFlag(1);
			err = mexCallMATLAB(1, plhs, 1, prhs, "rtwenvironmentmode");
			mexSetTrapFlag(0);
			mxDestroyArray(prhs[0]);

			/*
			 * Set the error status if an error occurred
			 */
			if (err) {
				if (plhs[0]) {
					mxDestroyArray(plhs[0]);
					plhs[0] = NULL;
				}
				ssSetErrorStatus(S, "Unknown error during call to 'rtwenvironmentmode'.");
				return -1;
			}

			/*
			 * Get the value returned by rtwenvironmentmode(modelName)
			 */
			if (plhs[0]) {
				status = (int_T) (mxGetScalar(plhs[0]) != 0);
				mxDestroyArray(plhs[0]);
				plhs[0] = NULL;
			}
			return (status);
		}

		#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
		#include "simulink.c"      /* MEX-file interface mechanism */

		#else
		#include "cg_sfun.h"       /* Code generation registration function */
		#endif	
	EOS
	f.puts Agent::clang_format(body, $clang_format)
end

puts "File #{$out_dir_matlab}/#{$base_name}_UDP_client.c generated"