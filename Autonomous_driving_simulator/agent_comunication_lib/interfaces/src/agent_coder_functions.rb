#!/usr/bin/env ruby

require 'yaml'
require "getoptlong"
require 'zlib'
require 'fileutils'
require 'pathname'

class String
  def math_name
    s = self
    s.gsub!(/_(\w)/) {$1.upcase}
    s.gsub!(/^([a-z])/) {$1.upcase}
    return s
  end
end

def thereis(cmd)
	exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
	ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
	exts.each { |ext|
		exe = File.join(path, "#{cmd}#{ext}")
		return true if File.executable?(exe) && !File.directory?(exe)
	}
	end
	return false
end
CLANG_FORMAT = "clang-format"

module Agent
  C_TYPES = {
    int8:   ['int16_t',  'j'], # DUPLICATED
    uint8:  ['uint16_t', 'v'], # DUPLICATED
    int16:  ['int16_t',  'j'],
    uint16: ['uint16_t', 'v'],
    int32:  ['int32_t',  'i'],
    uint32: ['uint32_t', 'u'],
    int64:  ['int64_t',  'I'],
    uint64: ['uint64_t', 'U'],
    char:   ['char',     'c'],
    str:    ['char*',    's'],
    float:  ['double',   'f'], # DUPLICATED
    double: ['double',   'f']
  }
  PYTHON_TYPES = {
      :int8   => {type: 'c_int8',  bytes: 2},
      :uint8  => {type: 'c_uint8', bytes: 2},
      :int16  => {type: 'c_int16',  bytes: 2},
      :uint16 => {type: 'c_uint16', bytes: 2},
      :int32  => {type: 'c_int32',  bytes: 4},
      :uint32 => {type: 'c_uint32', bytes: 4},
      :int64  => {type: 'c_int64',  bytes: 8},
      :uint64 => {type: 'c_uint64', bytes: 8},
      :float  => {type: 'c_float', bytes: 8},
      :double => {type: 'c_double', bytes: 8}
  }
  MATLAB_TYPES = {
    :int8   => {type: 'int16',  bytes: 2},
    :uint8  => {type: 'uint16', bytes: 2},
    :int16  => {type: 'int16',  bytes: 2},
    :uint16 => {type: 'uint16', bytes: 2},
    :int32  => {type: 'int32',  bytes: 4},
    :uint32 => {type: 'uint32', bytes: 4},
    :int64  => {type: 'int64',  bytes: 8},
    :uint64 => {type: 'uint64', bytes: 8},
    :float  => {type: 'double', bytes: 8},
    :double => {type: 'double', bytes: 8}
  }
  MATLAB_SFUN_TYPES = {
    int8:   ['SS_INT8'  ],
    uint8:  ['SS_UINT8' ],
    int16:  ['SS_INT16' ],
    uint16: ['SS_UINT16'],
    int32:  ['SS_INT32' ],
    uint32: ['SS_UINT32'],
    #int64:  [], # CAN'T BE MAPPED
    #uint64: [], # CAN'T BE MAPPED
    char:   ['SS_INT8'  ],
    #str:    [], # CAN'T BE MAPPED
    float:  ['SS_SINGLE'],
    double: ['SS_DOUBLE']
  }
  FPRINTF_TYPES = {
    int8:   ['d'], # DUPLICATED
    uint8:  ['u'], # DUPLICATED
    int16:  ['d'],
    uint16: ['u'],
    int32:  ['d'],
    uint32: ['u'],
    int64:  ['d'],
    uint64: ['u'],
    char:   ['c'],
    str:    ['s'],
    float:  ['f'], # DUPLICATED
    double: ['f']
  }

  def self.types_table
    str = ""
    C_TYPES.each {|k,v| str += ":#{k} => #{v[0]}\n"}
    str
  end

  def clang_format(s, fmt='LLVM')
    result = ""
    if thereis(CLANG_FORMAT) == false then
      warn "clang-format not available!"
      return s
    end
    fmt = 'LLVM' unless %w(LLVM Chromium Google WebKit Mozilla).include? fmt
    IO.popen("#{CLANG_FORMAT} --style=#{fmt}", mode="r+") do |io|
      io.write s
      io.close_write
      result = io.read
    end
    return result
  end
  
  class CStructField
    attr_reader :name, :type, :size, :comment
    def initialize(hsh={})
      raise RuntimeError, "Need a name!" unless hsh[:name]
      @name    = hsh[:name]
      @type    = (hsh[:type] || :float)
      @size    = (hsh[:size] || 1)
      @comment = (hsh[:comment] || nil)
    end
    
    def c_type(what=:c)
      begin
        case what
        when :c
          return C_TYPES[@type][0]
        else
          raise ArgumentError
        end
      rescue => e
        warn "unavailable type #{@type}"
        raise RuntimeError
      end
    end
    
    def matlab_type(what=:matlab)
      begin
        case what
        when :matlab
          return MATLAB_TYPE[@type][0]
        else
          raise ArgumentError
        end
      rescue => e
        warn "unavailable type #{@type}"
        raise RuntimeError
      end
    end
    
    def matlab_sfun_type(what=:sfun)
      begin
        case what
        when :sfun
          return MATLAB_SFUN_TYPES[@type][0]
        else
          raise ArgumentError
        end
      rescue => e
        warn "unavailable type #{@type}"
        raise RuntimeError
      end
    end
    
    def fprintf_type(what=:fprintf)
      begin
        case what
        when :fprintf
          return FPRINTF_TYPES[@type][0]
        else
          raise ArgumentError
        end
      rescue => e
        warn "unavailable type #{@type}"
        raise RuntimeError
      end
    end
    
    def to_s
      comment = " /* #{@comment} */" if @comment
      "#{c_type} #{name}#{@size > 1 ? "[#{@size}]" : ''};#{comment}"
    end
  end #class CStructField

  
  
  #   ____ ____  _                   _          _
  #  / ___/ ___|| |_ _ __ _   _  ___| |_    ___| | __ _ ___ ___
  # | |   \___ \| __| '__| | | |/ __| __|  / __| |/ _` / __/ __|
  # | |___ ___) | |_| |  | |_| | (__| |_  | (__| | (_| \__ \__ \
  #  \____|____/ \__|_|   \__,_|\___|\__|  \___|_|\__,_|___/___/

  class CStruct
    attr_accessor :clang_format
    attr_reader :name, :fields
    def initialize(hsh={})
      @name = hsh[:name]
      @clang_format = (hsh[:clang_format] || nil)
      @fields = []
    end
    
    def <<(field)
      raise ArgumentError, "Need a CStructField" unless field.kind_of? CStructField
      @fields << field
    end
    
    def fields=(ary)
      raise ArgumentError, "Need an array!" unless ary.kind_of? Array
      @fields = field
      sanity_check
    end
    
    def to_s
      s = "#if defined(MATLAB_MEX_FILE) || defined(_DS1401)\n"
      s << "typedef struct {\n"
      s << "#elif defined(_WIN32)\n" <<
           "#pragma pack(push, 1)\n" <<
           "typedef struct {\n"
      s << "#else\n" <<
           "typedef struct __attribute__((packed)) {\n" <<
           "#endif\n"
      @fields.each {|f| s << "  #{f}\n"}
      s << "} #{@name};\n"
      s << "#if defined(MATLAB_MEX_FILE) || defined(_DS1401)\n" <<
           "// Do nothing\n"
      s << "#elif defined(_WIN32)\n" <<
           "#pragma pack(pop)\n" <<
           "#endif\n"
      if @clang_format then
        return Agent::clang_format(s, @clang_format)
      else
        return s
      end
    end
    
    def c_source_in
      real_values = []
      int_values = []
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
            real_values << "realVector(#{real_values.size + 1}) = ds.#{field.name};"
          else
            field.size.times do |i|
              real_values << "realVector(#{real_values.size + 1}) = ds.#{field.name}[#{i}];"
            end
          end
        else
          if field.size == 1 then
            int_values << "intVector(#{int_values.size + 1}) = ds.#{field.name};"
          else
            field.size.times do |i|
              int_values << "intVector(#{int_values.size + 1}) = ds.#{field.name}[#{i}];"
            end
          end
        end
      end
      result = <<-EOS
      void
      InputDataExternal(const int & id, intN & intVector, doubleN & realVector ) {
      const #{self.name} & ds = *ptr_Agent_#{self.name};

      // Integer fields
      #{int_values.join("\n")}

      // Real fields
      #{real_values.join("\n")}
      
      }
      EOS
      return Agent::clang_format(result, @clang_format)
    end
    
    def c_source_out
      int_values = []
      real_values = []
      @fields.each do |field|
        case field.type
        when :float, :double
          #real_values << "#{field.size == 1 ?
          #               "ds.#{field.name} = realVector(#{real_values.size + 1});" :
          #               field.size.times { |i| "ds.#{field.name}[#{i}] = realVector(#{real_values.size + 1});"}}"
          if field.size == 1 then
            real_values << "ds.#{field.name} = realVector(#{real_values.size + 1});"
          else
            field.size.times do |i|
              real_values << "ds.#{field.name}[#{i}] = realVector(#{real_values.size + 1});"
            end
          end
        else
          if field.size == 1 then
            int_values << "ds.#{field.name} = intVector(#{int_values.size + 1});"
          else
            field.size.times do |i|
              int_values << "ds.#{field.name}[#{i}] = intVector(#{int_values.size + 1});"
            end
          end
        end
      end
      result = <<-EOS

      void
      OutputDataExternal(const int & id, const intN & intVector, const doubleN & realVector) {
      #{self.name} & ds = *ptr_Agent_#{self.name};

      // Integer fields
      #{int_values.join("\n")}

      // Real fields
      #{real_values.join("\n")}
      
      }
      EOS
      return Agent::clang_format(result, @clang_format)
    end

    # Python files ------------------------------------------------------
    def python_ctype_struct(struct_name)
      struct = []
      @fields.each do |field|
        struct << "#{struct_name}.#{field.name} = #{PYTHON_TYPES[field.type][:type]}(zeros(#{field.size},1));"
      end
      result = <<-EOS
      #{struct.join("\n")}
      EOS
      return result
    end
    
    # Matlab files ------------------------------------------------------
    def matlab_struct(struct_name)
      struct = []
      @fields.each do |field|
        struct << "#{struct_name}.#{field.name} = #{MATLAB_TYPES[field.type][:type]}(zeros(#{field.size},1));"
      end
      result = <<-EOS
      #{struct.join("\n")}
      EOS
      return result 
    end
    
    def sfun_serializer
      n_inputs = @fields.size
      output_size = 0
      inputs_set = []
      inputs_data_type = []
      @fields.each_with_index do |field, i|
        inputs_set << "// Input Port #{i}" <<
                      "ssSetInputPortWidth(S, #{i}, #{field.size});" <<
                      "ssSetInputPortDataType(S, #{i}, #{field.matlab_sfun_type(:sfun)});" <<
                      "ssSetInputPortDirectFeedThrough(S, #{i}, 1);" <<
                      "ssSetInputPortRequiredContiguous(S, #{i}, 1); // direct input signal access"
        inputs_data_type << "ssSetInputPortDataType(S, #{i}, #{field.matlab_sfun_type(:sfun)});"
        begin
          case field.type
          when :double
            output_size += field.size*2
          when :int32
            output_size += field.size
          else
            raise ArgumentError
          end
        rescue => e
          warn "not valid type for serializer s-function: #{field.type}"
          raise RuntimeError
        end
      end
      result = <<-EOS
      
      #define NUM_INPUTS  #{n_inputs}
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
        #{inputs_set.join("\n")}
        
        // Outputs ------------------------------------------------------------
        if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) {
          return;
        }
        // Output port 0
        ssSetOutputPortWidth(S, 0, #{output_size});
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
        #{inputs_data_type.join("\n")}
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
      return Agent::clang_format(result, @clang_format)
    end
    
    def sfun_deserializer
      n_outputs = @fields.size
      input_size = 0
      outputs_set = []
      outputs_data_type = []
      @fields.each_with_index do |field, i|
        outputs_set << "// Output Port #{i}" <<
                       "ssSetOutputPortWidth(S, #{i}, #{field.size});" <<
                       "ssSetOutputPortDataType(S, #{i}, #{field.matlab_sfun_type(:sfun)});"
        outputs_data_type << "ssSetOutputPortDataType(S, #{i}, #{field.matlab_sfun_type(:sfun)});"
        begin
          case field.type
          when :double
            input_size += field.size*2
          when :int32
            input_size += field.size
          else
            raise ArgumentError
          end
        rescue => e
          warn "not valid type for deserializer s-function: #{field.type}"
          raise RuntimeError
        end
      end
      result = <<-EOS
      
      #define NUM_INPUTS  1
      #define NUM_OUTPUTS #{n_outputs}
      
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
        ssSetInputPortWidth(S, 0, #{input_size});
        ssSetInputPortDataType(S, 0, SS_UINT32);
        ssSetInputPortDirectFeedThrough(S, 0, 1);
        ssSetInputPortRequiredContiguous(S, 0, 1); // direct input signal access
        
        // Outputs ------------------------------------------------------------
        if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) {
          return;
        }
        #{outputs_set.join("\n")}
        
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
        #{outputs_data_type.join("\n")}
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
      return Agent::clang_format(result, @clang_format)
    end
	
	# -------------------------- updated for packet file generation -------------------------
	# ==========-------------------------- creator -------------------------=================
    def sfun_packet_creator
		result = <<-EOS
		#define NUM_INPUTS            4
		/* Input Port  0 */
		#define IN_PORT_0_NAME        scenario_array
		#define INPUT_0_WIDTH         8290
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
		#define PANELINDEX            8
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

		#include "UDP_limit_defines.h"

		#include "interfaces_data_structs.h"

		#define u_width 8290
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

			n_packets       = (UDP_UINT) ceilf((float) (scenario_array_size/PART_BYTES));
			//n_packets 	= 23;  // removed hardcoded packet size
			remaining_bytes = (size_t) scenario_array_size % PART_BYTES;
			//remaining_bytes = 1216;
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

			#if defined(_DS401) || defined(__MACH__) || defined(__linux__)
			memcpy(&packet.data_struct.datagram_part, (void *) scenario_array+((size_t) *part_pos)*sizeof(packet.data_struct.datagram_part), part_size);
			#elif defined(_WIN32)
			memcpy(&packet.data_struct.datagram_part, (uint8_T *) scenario_array+((size_t) *part_pos)*sizeof(packet.data_struct.datagram_part), part_size);
			#endif

			#if defined(_DS401) || defined(__MACH__) || defined(__linux__)
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

			ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

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

		#define MDL_START  /* Change to #undef to remove function */
		#if defined(MDL_START)
		/* Function: mdlStart =======================================================
		 * Abstract:
		 *    This function is called once at start of model execution. If you
		 *    have states that should be initialized once, this is the place
		 *    to do it.
		 */
		static void mdlStart(SimStruct *S)
		{
		}
		#endif /*  MDL_START */

		/* Function: mdlOutputs =======================================================
		 *
		 */
		static void mdlOutputs(SimStruct *S, int_T tid)
		{
			const uint32_T *scenario_array = (uint32_T *) ssGetInputPortRealSignal(S, 0);
			const uint32_T *part_pos = (uint32_T *) ssGetInputPortRealSignal(S, 1);
			const uint32_T *server_run = (uint32_T *) ssGetInputPortRealSignal(S, 2);
			const uint32_T *datagram_id = (uint32_T *) ssGetInputPortRealSignal(S, 3);
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
		return Agent::clang_format(result, @clang_format)	
	end
	
	# -------------------------- updated for packet file generation -------------------------
	# ==========-------------------------- reader  -------------------------=================
    def sfun_packet_reader
		result = <<-EOS
		#define NUM_INPUTS            5
		/* Input Port  0 */
		#define IN_PORT_0_NAME        packet_array
		#define INPUT_0_WIDTH         368
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
		#define IN_PORT_1_NAME        recv_bytes
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
		#define IN_PORT_2_NAME        buffer_id
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
		#define IN_PORT_3_NAME        manoeuvre_array_in
		#define INPUT_3_WIDTH         444
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
		/* Input Port  4 */
		#define IN_PORT_4_NAME        readed_packets_in
		#define INPUT_4_WIDTH         1
		#define INPUT_DIMS_4_COL      1
		#define INPUT_4_DTYPE         uint32_T
		#define INPUT_4_COMPLEX       COMPLEX_NO
		#define IN_4_FRAME_BASED      FRAME_NO
		#define IN_4_BUS_BASED        0
		#define IN_4_BUS_NAME         
		#define IN_4_DIMS             1-D
		#define INPUT_4_FEEDTHROUGH   1
		#define IN_4_ISSIGNED         0
		#define IN_4_WORDLENGTH       8
		#define IN_4_FIXPOINTSCALING  1
		#define IN_4_FRACTIONLENGTH   9
		#define IN_4_BIAS             0
		#define IN_4_SLOPE            0.125

		#define NUM_OUTPUTS           4
		/* Output Port  0 */
		#define OUT_PORT_0_NAME       manoeuvre_array_out
		#define OUTPUT_0_WIDTH        444
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
		#define OUT_PORT_1_NAME       status
		#define OUTPUT_1_WIDTH        1
		#define OUTPUT_DIMS_1_COL     1
		#define OUTPUT_1_DTYPE        int32_T
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
		/* Output Port  2 */
		#define OUT_PORT_2_NAME       stop_time
		#define OUTPUT_2_WIDTH        1
		#define OUTPUT_DIMS_2_COL     1
		#define OUTPUT_2_DTYPE        uint32_T
		#define OUTPUT_2_COMPLEX      COMPLEX_NO
		#define OUT_2_FRAME_BASED     FRAME_NO
		#define OUT_2_BUS_BASED       0
		#define OUT_2_BUS_NAME        
		#define OUT_2_DIMS            1-D
		#define OUT_2_ISSIGNED        1
		#define OUT_2_WORDLENGTH      8
		#define OUT_2_FIXPOINTSCALING 1
		#define OUT_2_FRACTIONLENGTH  3
		#define OUT_2_BIAS            0
		#define OUT_2_SLOPE           0.125
		/* Output Port  3 */
		#define OUT_PORT_3_NAME       readed_packets_out
		#define OUTPUT_3_WIDTH        1
		#define OUTPUT_DIMS_3_COL     1
		#define OUTPUT_3_DTYPE        uint32_T
		#define OUTPUT_3_COMPLEX      COMPLEX_NO
		#define OUT_3_FRAME_BASED     FRAME_NO
		#define OUT_3_BUS_BASED       0
		#define OUT_3_BUS_NAME        
		#define OUT_3_DIMS            1-D
		#define OUT_3_ISSIGNED        1
		#define OUT_3_WORDLENGTH      8
		#define OUT_3_FIXPOINTSCALING 1
		#define OUT_3_FRACTIONLENGTH  3
		#define OUT_3_BIAS            0
		#define OUT_3_SLOPE           0.125

		#define NPARAMS               0

		#define SAMPLE_TIME_0         INHERITED_SAMPLE_TIME
		#define NUM_DISC_STATES       0
		#define DISC_STATES_IC        [0,0]
		#define NUM_CONT_STATES       0
		#define CONT_STATES_IC        [0]

		#define SFUNWIZ_GENERATE_TLC  0
		#define PANELINDEX            8
		#define USE_SIMSTRUCT         1
		#define SHOW_COMPILE_STEPS    0
		#define CREATE_DEBUG_MEXFILE  0
		#define SAVE_CODE_ONLY        0
		#define SFUNWIZ_REVISION      3.0

		#include "simstruc.h"

		// ===================== ADDITIONAL INCLUDE FROM WRAPPER =====================
		#include <stdio.h>
		#include <string.h>
		#include <math.h>
		#include <assert.h>

		#include "UDP_limit_defines.h"
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

		/*
		 * Output functions
		 *
		 */
		void agent_packet_reader_Outputs_wrapper(const uint32_T *packet_array,
					const uint32_T *recv_bytes,
					const uint32_T *buffer_id,
					const uint32_T *manoeuvre_array_in,
					const uint32_T *readed_packets_in,
					uint32_T *manoeuvre_array_out,
					int32_T *status,
					uint32_T *stop_time,
					uint32_T *readed_packets_out,
					SimStruct *S)
		{
		packet_t packet;
		UDP_UINT n_packets;
		UDP_UINT last_part_pos;
		UDP_UINT part_pos;
		UDP_UINT part_size;
		UDP_UINT datagram_id;

		//size_t manoeuvre_array_size = (size_t) 444/*ssGetOutputPortWidth(S, 0)*/ * sizeof(uint32_T);
		size_t manoeuvre_array_size = (size_t) ssGetOutputPortWidth(S, 0) * sizeof(uint32_T);
		*status = -1;
		if (*recv_bytes > 0) {
		  memcpy(&packet.data_buffer, (char *) packet_array, (size_t) PACKET_BYTES);
		  
		  swapBytes((void *) &last_part_pos, (void *) &packet.data_struct.last_part_pos, sizeof(uint32_T), 1);
		  swapBytes((void *) &datagram_id,   (void *) &packet.data_struct.datagram_id,   sizeof(uint32_T), 1);
		  swapBytes((void *) &part_pos,      (void *) &packet.data_struct.part_pos,      sizeof(uint32_T), 1);
		  swapBytes((void *) &part_size,     (void *) &packet.data_struct.part_size,     sizeof(uint32_T), 1);
		  
		  
		  n_packets = last_part_pos + 1;
		  
		  // Keep only packets with buffer_id equal to the sended message id
		  if (datagram_id == *buffer_id) {
		#if defined(_DS1401) || defined(__MACH__) || defined(__linux__)
			memcpy((void *) manoeuvre_array_in+((size_t) part_pos)*sizeof(packet.data_struct.datagram_part), &packet.data_struct.datagram_part, (size_t) part_size);
		#elif defined(_WIN32)
			memcpy((char *) manoeuvre_array_in+((size_t) part_pos)*sizeof(packet.data_struct.datagram_part), &packet.data_struct.datagram_part, (size_t) part_size);
		#endif
			*readed_packets_out = *readed_packets_in + 1;
			if (*readed_packets_out == n_packets) {
			  *readed_packets_out = 0;
			  *status = 0;
		#if defined(_DS1401)
			  *stop_time = get_time_100();
		#endif
			}
		  }
		  else {
			*readed_packets_out = *readed_packets_in;
			*status = 1;
		  }
		}
		else {
		  *readed_packets_out = *readed_packets_in;
		  *status = 1;
		}
		#if defined(_DS1401) || defined(__MACH__) || defined(__linux__)
			memcpy((void *) manoeuvre_array_out, (void *) manoeuvre_array_in, manoeuvre_array_size);
		#elif defined(_WIN32)
			memcpy((char *) manoeuvre_array_out, (char *) manoeuvre_array_in, manoeuvre_array_size);
		#endif
		}



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

			ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

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

			/* Input Port 4 */
			ssSetInputPortWidth(S, 4, INPUT_4_WIDTH);
			ssSetInputPortDataType(S, 4, SS_UINT32);
			ssSetInputPortComplexSignal(S, 4, INPUT_4_COMPLEX);
			ssSetInputPortDirectFeedThrough(S, 4, INPUT_4_FEEDTHROUGH);
			ssSetInputPortRequiredContiguous(S, 4, 1); /*direct input signal access*/


			if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) return;
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

		#define MDL_START  /* Change to #undef to remove function */
		#if defined(MDL_START)
		/* Function: mdlStart =======================================================
		 * Abstract:
		 *    This function is called once at start of model execution. If you
		 *    have states that should be initialized once, this is the place
		 *    to do it.
		 */
		static void mdlStart(SimStruct *S)
		{
		}
		#endif /*  MDL_START */

		/* Function: mdlOutputs =======================================================
		 *
		 */
		static void mdlOutputs(SimStruct *S, int_T tid)
		{
			const uint32_T *packet_array = (uint32_T *) ssGetInputPortRealSignal(S, 0);
			const uint32_T *recv_bytes = (uint32_T *) ssGetInputPortRealSignal(S, 1);
			const uint32_T *buffer_id = (uint32_T *) ssGetInputPortRealSignal(S, 2);
			const uint32_T *manoeuvre_array_in = (uint32_T *) ssGetInputPortRealSignal(S, 3);
			const uint32_T *readed_packets_in = (uint32_T *) ssGetInputPortRealSignal(S, 4);
			uint32_T *manoeuvre_array_out = (uint32_T *) ssGetOutputPortRealSignal(S, 0);
			int32_T *status = (int32_T *) ssGetOutputPortRealSignal(S, 1);
			uint32_T *stop_time = (uint32_T *) ssGetOutputPortRealSignal(S, 2);
			uint32_T *readed_packets_out = (uint32_T *) ssGetOutputPortRealSignal(S, 3);

			agent_packet_reader_Outputs_wrapper(packet_array, recv_bytes, buffer_id, manoeuvre_array_in, readed_packets_in, manoeuvre_array_out, status, stop_time, readed_packets_out, S);
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
		return Agent::clang_format(result, @clang_format)	
	end

	
    
    # Mathematica files -------------------------------------------------------
    def m_header_package_in
      function_names = []
      @fields.each do |field|
        function_names << "get#{field.name.math_name};"
      end
      result = <<-EOS
      (* Settings for offline mode *)
      If[Global`offlineMode,
  	    DataSampleIntegerLoad;
  	    DataSampleRealLoad;
      ]
      #{function_names.join("\n")}
      EOS
      return result
    end
    
    def m_header_package_out
      function_names = []
      function_names_out = []
      @fields.each do |field|
        function_names << "set#{field.name.math_name};"
        function_names_out << "get#{field.name.math_name}Out;"
      end
      result = <<-EOS
      (* Settings for offline mode *)
      If[Global`offlineMode,
        DataSampleIntegerOut[];
        DataSampleRealOut[];
      ]
      #{function_names.join("\n")}
      (* Settings for offline mode *)
      If[Global`offlineMode,
        #{function_names_out.join("\n")}
      ]
      EOS
      return result
    end
    
    def m_source_in
      int_values = []
      int_count = 0
      real_values = []
      real_count = 0
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
            real_values << "get#{field.name.math_name}[] -> {Real} := InputRealFields[[#{real_count + 1}]];"
          else
            real_values << "get#{field.name.math_name}[] -> {Real[#{field.size}]} := InputRealFields[[#{real_count + 1};;#{real_count + field.size}]];"
          end
          real_count += field.size
        else
          if field.size == 1 then
            int_values << "get#{field.name.math_name}[] -> {Integer} := InputIntegerFields[[#{int_count + 1}]];"
          else
            int_values << "get#{field.name.math_name}[] -> {Integer[#{field.size}]} := InputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]];"
          end
          int_count += field.size
        end
      end
      result = <<-EOS
      (* ::Input:: *)
      Declare[Integer[#{int_count}] InputIntegerFields = 0];
      Declare[Real[#{real_count}] InputRealFields = 0];
      
      (* Settings for offline mode *)
      If[Global`offlineMode,
        DataSampleIntegerLoad[Integer[#{int_count}] DataSampleInteger_] -> {} := Module[{}, InputIntegerFields = DataSampleInteger];
        DataSampleRealLoad[Real[#{real_count}] DataSampleReal_] -> {} := Module[{}, InputRealFields = DataSampleReal];
        InputDataExternal[Integer id_] -> {Integer[#{int_count}], Real[#{real_count}]} := {InputIntegerFields,InputRealFields};
      ,
        InputDataExternal[Integer id_] -> {Integer[#{int_count}], Real[#{real_count}]} := ExternalProcedure[];
      ]
      
      (* ::Input:: *)
      (* Integer fields getter mappings *)
      #{int_values.join("\n")}
      
      (* ::Input:: *)
      (* Real fields getter mappings *)
      #{real_values.join("\n")}
      EOS
      return result
    end

    def m_source_out
      int_values = []
      int_count = 0
      real_values = []
      real_count = 0
      out_values = []
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
            real_values << "set#{field.name.math_name}[Real field_] -> {} := OutputRealFields[[#{real_count + 1}]] = field;"
            out_values  << "get#{field.name.math_name}Out[] -> {Real} := OutputRealFields[[#{real_count + 1}]];"
          else
            real_values << "set#{field.name.math_name}[Real[#{field.size}] field_] -> {} := OutputRealFields[[#{real_count + 1};;#{real_count + field.size}]] = field;"
            out_values  << "get#{field.name.math_name}Out[] -> {Real[#{field.size}]} := OutputRealFields[[#{real_count + 1};;#{real_count + field.size}]];"
          end
          real_count += field.size
        else
          if field.size == 1 then
            int_values << "set#{field.name.math_name}[Integer field_] -> {} := OutputIntegerFields[[#{int_count + 1}]] = field;"
            out_values << "get#{field.name.math_name}Out[] -> {Integer} := OutputIntegerFields[[#{int_count + 1}]];"
          else
            int_values << "set#{field.name.math_name}[Integer[#{field.size}] field_] -> {} := OutputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]] = field;"
            out_values << "get#{field.name.math_name}Out[] -> {Integer[#{field.size}]} := OutputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]];"
          end
          int_count += field.size
        end
      end
      result = <<-EOS
      (* ::Output:: *)
      Declare[Integer[#{int_count}] OutputIntegerFields = 0];
      Declare[Real[#{real_count}] OutputRealFields = 0];
      
      (* Settings for offline mode *)
      If[Global`offlineMode,
        DataSampleIntegerOut[] -> {Integer[#{int_count}]} := OutputIntegerFields;
        DataSampleRealOut[] -> {Real[#{real_count}]} := OutputRealFields;
        OutputDataExternal[Integer id_, Integer[#{int_count}] intVector_, Real[#{real_count}] realVector_] -> {} := Module[{}, OutputIntegerFields = intVector;
                                                                                                                               OutputRealFields = realVector];
      ,
        OutputDataExternal[Integer id_, Integer[#{int_count}] intVector_, Real[#{real_count}] realVector_] -> {} := ExternalProcedure[];
      ]
      
      (* ::Output:: *)
      (* Integer fields setter mappings *)
      #{int_values.join("\n")}
      
      (* ::Output:: *)
      (* Real fields setter mappings *)
      #{real_values.join("\n")}
      
      (* Settings for offline mode *)
      If[Global`offlineMode,
        #{out_values.join("\n")}
      ]
      EOS
      return result
    end
    
    
    def m_offline_fun_in
      real_pos = []
      int_pos = []
      count = 0
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
            real_pos << "#{count + 1}"
          else
            field.size.times do |i|
              real_pos << "#{count + 1 + i}"
            end
          end
        else
          if field.size == 1 then
            int_pos << "#{count + 1}"
          else
            field.size.times do |i|
              int_pos << "#{count + 1 + i}"
            end
          end
        end
        count += field.size
      end
      result = <<-EOS
      (* ::Offline Mathematica selector function:: *)
      DataSampleSelector[DataSample_] := Module[{DataSampleInteger, DataSampleReal},
      DataSampleInteger := DataSample[[{#{int_pos.join(',')}}]];
      DataSampleReal := N@DataSample[[{#{real_pos.join(',')}}]];
      {DataSampleInteger, DataSampleReal}
      ]
      EOS
      return result
    end
    
    
    
    # Struct printer functions ------------------------------------------------
    def struct_fprintf(what=:header)
      header_vars = []
      output_format = []
      output_vars = []
      output_vars_to_string = []
      @fields.each do |field|
        if field.size == 1 then
          header_vars << "#{field.name}"
          output_format << "\%#{field.fprintf_type(:fprintf)}"
          output_vars << "data_input_load->#{field.name}"
        else
          field.size.times do |i|
            header_vars << "#{field.name}%03d" % [i+1]
            output_format << "\%#{field.fprintf_type(:fprintf)}"
            output_vars << "data_input_load->#{field.name}[#{i}]"
          end
        end
      end
      
      begin
        case what
        when :header
          result = <<-EOS
          fprintf(fp_input, "#{header_vars.join("\\t")}\\n");
          EOS
        when :data
          result = <<-EOS
          fprintf(fp_input, "#{output_format.join("\\t")}\\n", #{output_vars.join(", ")});
          EOS
        else
          raise ArgumentError
        end
      end
      
      return Agent::clang_format(result, @clang_format)
    end
    
    
       
  end #class CStruct
  
  
end #module Agent
