#!/usr/bin/env ruby

require 'yaml'
require "getoptlong"
require 'zlib'
require 'fileutils'
require 'pathname'
require 'enumerator'

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

  JAVA_TYPES = {
      int8:   ['byte',  'j'],
      uint8:  ['byte',  'v'],
      int16:  ['short', 'j'],
      uint16: ['short', 'v'],
      int32:  ['int',   'i'],
      uint32: ['int',   'u'],
      int64:  ['long',  'I'],
      uint64: ['long',  'U'],
      char:   ['char',  'c'],
      str:    ['string','s'],
      float:  ['float', 'f'],
      double: ['double','f']
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

# ========================================================================================
# ========================================= C++ ==========================================
# ========================================================================================

    def to_s
      s = "#if defined(MATLAB_MEX_FILE) || defined(_DS1401) || defined(_WIN32)\n"
      s << "#pragma pack(push, 1)\n" <<
           "typedef struct {\n"
      s << "#else\n" <<
           "typedef struct __attribute__((packed)) {\n" <<
           "#endif\n"
      @fields.each {|f| s << "  #{f}\n"}
      s << "} #{@name};\n"
      s << "#if defined(MATLAB_MEX_FILE) || defined(_DS1401) || defined(_WIN32)\n" <<
           "#pragma pack(pop)\n" <<
           "#endif\n"
      if @clang_format then
        return Agent::clang_format(s, @clang_format)
      else
        return s
      end
    end

	def test_variables
      test_variable = []
      @fields.each do |field|
        if field.size == 1 then
			test_variable << "REQUIRE(v1.#{field.name} == v2.#{field.name});"
        else
          field.size.times do |i|
            test_variable << "REQUIRE(v1.#{field.name}[#{i}] == v2.#{field.name}[#{i}]);"
		  end
		end
      end
      result = <<-EOS

	  void compare_struct(const #{self.name} &v1,const #{self.name} &v2) {
	     #{test_variable.join("\n")}
      }

      EOS
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

# ========================================================================================
# ======================================== PYTHON ========================================
# ========================================================================================

    def python_ctype_struct(alias_name)
      struct = []
      @fields.each_with_index do |field,index|
        if index == fields.size - 1
          if field.size == 1
            struct << "(\"#{field.name}\", #{alias_name}.#{PYTHON_TYPES[field.type][:type]})"
          else
            struct << "(\"#{field.name}\", #{alias_name}.#{PYTHON_TYPES[field.type][:type]}*#{field.size})"
          end
        else
          if field.size == 1
            struct << "(\"#{field.name}\", #{alias_name}.#{PYTHON_TYPES[field.type][:type]}),"
          else
            struct << "(\"#{field.name}\", #{alias_name}.#{PYTHON_TYPES[field.type][:type]}*#{field.size}),"
          end
        end
      end
      result = <<-EOS
        #{struct.join("\n\t\t")}
      EOS
      return result
    end

# ========================================================================================
# ======================================== MATLAB ========================================
# ========================================================================================

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

	def sfun_struct_size
		return @fields.size
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
      result = {
		n_inputs: n_inputs,
		inputs_set: inputs_set,
		inputs_data_type: inputs_data_type,
		output_size: output_size
	  }
      return result
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
      result = {
		n_outputs: n_outputs,
		outputs_set: outputs_set,
		outputs_data_type: outputs_data_type,
		input_size: input_size
	  }
      return result
    end

    def sfun_udp_client_busIN_init
      data = []
      @fields.each_with_index do |field, i|
          data << "busINInfo[0][#{i}] = dtaGetDataTypeElementOffset(dta, bpath, input_data_strId, #{i});" <<
          	      "busINInfo[1][#{i}] = dtaGetDataTypeSize(dta, bpath, ssGetDataTypeId(S, \"#{MATLAB_TYPES[field.type][:type]}\"));"
      end
      result = <<-EOS

      #{data.join("\n")}

      EOS
      return Agent::clang_format(result, @clang_format)
    end

    def sfun_udp_client_busOUT_init
      data = []
      @fields.each_with_index do |field, i|
          data << "busOUTInfo[0][#{i}] = dtaGetDataTypeElementOffset(dta, bpath, input_data_strId, #{i});" <<
          	      "busOUTInfo[1][#{i}] = dtaGetDataTypeSize(dta, bpath, ssGetDataTypeId(S, \"#{MATLAB_TYPES[field.type][:type]}\"));"
      end
      result = <<-EOS

      #{data.join("\n")}

      EOS
      return Agent::clang_format(result, @clang_format)
    end

    def sfun_udp_client_copy_scenario
		data = []
		@fields.each_with_index do |field, i|
			data << "(void) memcpy(&scenario.data_struct.#{field.name}, scenario_bus + busINInfo[0][#{i}], busINInfo[1][#{i}]);";
		end
		result = <<-EOS

		#{data.join("\n")}

		EOS
		return Agent::clang_format(result, @clang_format)
    end

    def sfun_udp_client_copy_manoeuvre
		data = []
		@fields.each_with_index do |field, i|
			data << "(void) memcpy(&manoeuvre.data_struct.#{field.name}, manoeuvre_bus + busOUTInfo[0][#{i}], busOUTInfo[1][#{i}]);";
		end
		result = <<-EOS

		#{data.join("\n")}

		EOS
		return Agent::clang_format(result, @clang_format)
    end

# ========================================================================================
# ===================================== MATHEMATICA ======================================
# ========================================================================================

    def m_header_package_in
      function_names_get_in = []
	  function_names_set_in = []
      @fields.each do |field|
	    function_names_set_in << "set#{field.name.math_name}In;"
        function_names_get_in << "get#{field.name.math_name};"
      end
      result = <<-EOS
(* ::Subsection::Closed:: *)
(* Input functions *)

(* ::Subsubsection::Closed:: *)
(* Get Input functions *)

#{function_names_get_in.join("\n")}
(* ::Subsubsection::Closed:: *)
(* Set Input functions *)

#{function_names_set_in.join("\n")}
EOS
      return result
    end

    def m_header_package_out
      function_names_get_out = []
      function_names_set_out = []
      @fields.each do |field|
        function_names_set_out << "set#{field.name.math_name};"
        function_names_get_out << "get#{field.name.math_name}Out;"
      end
      result = <<-EOS
(* ::Subsection::Closed:: *)
(* Output functions *)

(* ::Subsubsection::Closed:: *)
(* Get Output functions *)

#{function_names_get_out.join("\n")}
(* ::Subsubsection::Closed:: *)
(* Set Output functions *)

#{function_names_set_out.join("\n")}
EOS
      return result
    end

    def m_source_in
      set_int_values_in = []
	  get_int_values_in = []
	  set_real_values_in = []
	  get_real_values_in = []
      int_count = 0
      real_count = 0
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
			set_real_values_in << "set#{field.name.math_name}In[Real field_] -> {} := InputRealFields[[#{real_count + 1}]] = field;"
            get_real_values_in << "get#{field.name.math_name}[] -> {Real} := InputRealFields[[#{real_count + 1}]];"
          else
			set_real_values_in << "set#{field.name.math_name}In[Real[#{field.size}] field_] -> {} := InputRealFields[[#{real_count + 1};;#{real_count + field.size}]] = field;"
            get_real_values_in << "get#{field.name.math_name}[] -> {Real[#{field.size}]} := InputRealFields[[#{real_count + 1};;#{real_count + field.size}]];"
          end
          real_count += field.size
        else
          if field.size == 1 then
		    set_int_values_in << "set#{field.name.math_name}In[Integer field_] -> {} := InputIntegerFields[[#{int_count + 1}]] = field;"
            get_int_values_in << "get#{field.name.math_name}[] -> {Integer} := InputIntegerFields[[#{int_count + 1}]];"
          else
		    set_int_values_in << "set#{field.name.math_name}In[Integer[#{field.size}] field_] -> {} := InputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]] = field;"
            get_int_values_in << "get#{field.name.math_name}[] -> {Integer[#{field.size}]} := InputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]];"
          end
          int_count += field.size
        end
      end
      result = <<-EOS
(* ::Subsection:: *)
(* Global Variable Input Fields *)

Declare[Integer[#{int_count}] InputIntegerFields = 0];
Declare[Real[#{real_count}] InputRealFields = 0];
(* ::Subsection::Closed:: *)
(* Definition of InputDataExternal function *)
InputDataExternal[Integer id_] -> {Integer[#{int_count}], Real[#{real_count}]} := ExternalProcedure[];
(* ::Subsection::Closed:: *)
(* Integer input fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions integer fields *)

#{set_int_values_in.join("\n")}
(* ::Subsubsection::Closed:: *)
(* Get functions integer fields *)

#{get_int_values_in.join("\n")}
(* ::Subsection::Closed:: *)
(* Real input fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions real fields *)

#{set_real_values_in.join("\n")}
(* ::Subsubsection::Closed:: *)
(* Get functions real fields *)

#{get_real_values_in.join("\n")}
EOS
      return result
    end

    def m_source_out
	  set_int_values_out = []
	  get_int_values_out = []
	  set_real_values_out = []
	  get_real_values_out = []
      int_count = 0
      real_count = 0
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
            set_real_values_out << "set#{field.name.math_name}[Real field_] -> {} := OutputRealFields[[#{real_count + 1}]] = field;"
            get_real_values_out << "get#{field.name.math_name}Out[] -> {Real} := OutputRealFields[[#{real_count + 1}]];"
          else
            set_real_values_out << "set#{field.name.math_name}[Real[#{field.size}] field_] -> {} := OutputRealFields[[#{real_count + 1};;#{real_count + field.size}]] = field;"
            get_real_values_out << "get#{field.name.math_name}Out[] -> {Real[#{field.size}]} := OutputRealFields[[#{real_count + 1};;#{real_count + field.size}]];"
          end
          real_count += field.size
        else
          if field.size == 1 then
            set_int_values_out << "set#{field.name.math_name}[Integer field_] -> {} := OutputIntegerFields[[#{int_count + 1}]] = field;"
            get_int_values_out << "get#{field.name.math_name}Out[] -> {Integer} := OutputIntegerFields[[#{int_count + 1}]];"
          else
            set_int_values_out << "set#{field.name.math_name}[Integer[#{field.size}] field_] -> {} := OutputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]] = field;"
            get_int_values_out << "get#{field.name.math_name}Out[] -> {Integer[#{field.size}]} := OutputIntegerFields[[#{int_count + 1};;#{int_count + field.size}]];"
          end
          int_count += field.size
        end
      end
      result = <<-EOS
(* ::Subsection:: *)
(* Global Variable Output Fields *)

Declare[Integer[#{int_count}] OutputIntegerFields = 0];
Declare[Real[#{real_count}] OutputRealFields = 0];
(* ::Subsection::Closed:: *)
(* Definition of OutputDataExternal function *)
OutputDataExternal[Integer id_, Integer[#{int_count}] intVector_, Real[#{real_count}] realVector_] -> {} := ExternalProcedure[];
(* ::Subsection::Closed:: *)
(* Integer output fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions integer fields *)

#{set_int_values_out.join("\n")}
(* ::Subsubsection::Closed:: *)
(* Get functions integer fields *)

#{get_int_values_out.join("\n")}
(* ::Subsection::Closed:: *)
(* Real output fields *)

(* ::Subsubsection::Closed:: *)
(* Set functions real fields *)

#{set_real_values_out.join("\n")}
(* ::Subsubsection::Closed:: *)
(* Get functions real fields *)

#{get_real_values_out.join("\n")}
EOS
      return result
    end


    def m_offline_fun_in
      pos = []
	  real_pos = []
      int_pos = []
      count = 0
	  count_int = 0
	  count_real = 0
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
		    pos << "ScenarioReal[[#{count_real + 1}]]"
            real_pos << "#{count + 1}"
			count_real += 1
          else
            field.size.times do |i|
			  pos << "ScenarioReal[[#{count_real + 1}]]"
              real_pos << "#{count + 1 + i}"
			  count_real += 1
            end
          end
        else
          if field.size == 1 then
		    pos << "ScenarioInteger[[#{count_int + 1}]]"
            int_pos << "#{count + 1}"
			count_int += 1
          else
            field.size.times do |i|
			  pos << "ScenarioInteger[[#{count_int + 1}]]"
              int_pos << "#{count + 1 + i}"
			  count_int += 1
            end
          end
        end
        count += field.size
      end
      result = <<-EOS
(* ::Subsection:: *)
(* Offline Mathematica ScenarioLogToMathCode function *)
ScenarioLogToMathCode[ScenarioSample_] := Module[{ScenarioInteger, ScenarioReal},
ScenarioInteger := ScenarioSample[[{#{int_pos.join(',')}}]];
ScenarioReal := N@ScenarioSample[[{#{real_pos.join(',')}}]];
{ScenarioInteger, ScenarioReal}
]
(* ::Subsection:: *)
(* Offline Mathematica ScenarioMathCodeToLog function *)
ScenarioMathCodeToLog[ScenarioInteger_, ScenarioReal_] := Module[{},
{#{pos.join(',')}}
]
EOS
      return result
    end

    def m_offline_fun_out
      pos = []
	  real_pos = []
      int_pos = []
      count = 0
	  count_int = 0
	  count_real = 0
      @fields.each do |field|
        case field.type
        when :float, :double
          if field.size == 1 then
		    pos << "ManoeuvreReal[[#{count_real + 1}]]"
            real_pos << "#{count + 1}"
			count_real += 1
          else
            field.size.times do |i|
			  pos << "ManoeuvreReal[[#{count_real + 1}]]"
              real_pos << "#{count + 1 + i}"
			  count_real += 1
            end
          end
        else
          if field.size == 1 then
		    pos << "ManoeuvreInteger[[#{count_int + 1}]]"
            int_pos << "#{count + 1}"
			count_int += 1
          else
            field.size.times do |i|
			  pos << "ManoeuvreInteger[[#{count_int + 1}]]"
              int_pos << "#{count + 1 + i}"
			  count_int += 1
            end
          end
        end
        count += field.size
      end
      result = <<-EOS
(* ::Subsection:: *)
(* Offline Mathematica ManoeuvreLogToMathCode function *)
ManoeuvreLogToMathCode[ManoeuvreSample_] := Module[{ManoeuvreInteger, ManoeuvreReal},
ManoeuvreInteger := ManoeuvreSample[[{#{int_pos.join(',')}}]];
ManoeuvreReal := N@ManoeuvreSample[[{#{real_pos.join(',')}}]];
{ManoeuvreInteger, ManoeuvreReal}
]
(* ::Subsection:: *)
(* Offline Mathematica ManoeuvreMathCodeToLog function *)
ManoeuvreMathCodeToLog[ManoeuvreInteger_, ManoeuvreReal_] := Module[{},
{#{pos.join(',')}}
]
EOS
      return result
    end
# ========================================================================================
# =================================== C STRUCT PRINTER ===================================
# ========================================================================================


	def struct_fprintf(what=:header)
      output_vars_to_string = []
	  printf = []
	  sliced_field = @fields.each_slice(30).to_a
      sliced_field.each_with_index do |slice, index|
        header_vars = []
        output_format = []
        output_vars = []
	    slice.each do |field|
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

		if index == sliced_field.size - 1
			begin
			case what
			  when :header
				 printf << "fprintf(fp_input, \"#{header_vars.join("\\t")}\\n\");"
			  when :data
				 printf << "fprintf(fp_input, \"#{output_format.join("\\t")}\\n\", #{output_vars.join(", ")});"
			  else
				 raise ArgumentError
			  end
			end
		else
			begin
			case what
			  when :header
				 printf << "fprintf(fp_input, \"#{header_vars.join("\\t")}\\t\");"
			  when :data
				 printf << "fprintf(fp_input, \"#{output_format.join("\\t")}\\t\", #{output_vars.join(", ")});"
			  else
				 raise ArgumentError
			  end
			end
		end
      end
	  result = <<-EOS

	  #{printf.join("\n")}

      EOS
      return Agent::clang_format(result, @clang_format)
    end

  end #class CStruct

end #module Agent
