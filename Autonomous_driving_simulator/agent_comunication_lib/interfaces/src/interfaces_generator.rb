#!/usr/bin/env ruby

require 'yaml'
require "getoptlong"
require 'zlib'
require 'fileutils'

require_relative 'interfaces_functions'

include Agent

# Settings -------------------------------------------------------------------------------
# Definitions of the directories
dir_cc             = "c++_interfaces"
dir_struct_printer = "struct_printer_functions"
dir_mathematica    = "mathematica_interfaces"
dir_matlab         = "matlab_interfaces"
dir_python         = "python_interfaces"
dir_java           = "java_interfaces"
# ----------------------------------------------------------------------------------------

puts "------- interfaces_generator.rb -------"


if ARGV.size != 3 then
  raise ArgumentError, "usage: #{File.basename(__FILE__)} BASE_NAME IN_DIR OUT_DIR"
end

# Output directories ---------------------------------------------------------------------
$base_name              = ARGV[0]
$in_dir                 = ARGV[1]
$out_dir                = ARGV[2]
$out_dir_cc             = "#{$out_dir}/#{dir_cc}"
$out_dir_struct_printer = "#{$out_dir}/#{dir_struct_printer}"
$out_dir_mathematica    = "#{$out_dir}/#{dir_mathematica}"
$out_dir_matlab         = "#{$out_dir}/#{dir_matlab}"
$out_dir_python         = "#{$out_dir}/#{dir_python}"
$out_dir_java           = "#{$out_dir}/#{dir_java}"
# ----------------------------------------------------------------------------------------

# Structures for interfaces
$objs = {
  types_table: Agent::types_table,
  in_struct: CStruct.new(name:"input_data_str"),
  out_struct: CStruct.new(name:"output_data_str")
}

$clang_format = 'LLVM'
$objs[:in_struct].clang_format = $clang_format
$objs[:out_struct].clang_format = $clang_format

# Delete old files in output folder (if present)
FileUtils.rm_rf Dir.glob("#{$out_dir}/")

# Output directories
FileUtils.mkdir_p "#{$out_dir}"
FileUtils.mkdir_p "#{$out_dir_cc}"
FileUtils.mkdir_p "#{$out_dir_mathematica}"
FileUtils.mkdir_p "#{$out_dir_struct_printer}"
FileUtils.mkdir_p "#{$out_dir_matlab}"
FileUtils.mkdir_p "#{$out_dir_python}"
FileUtils.mkdir_p "#{$out_dir_java}"

$objs.merge! File.open("#{$in_dir}/#{$base_name}.yml") { |file| YAML.load(file) }
$crc = Zlib::crc32($objs.to_yaml)

# ========================================================================================
# ======================================== MATLAB ========================================
# ========================================================================================

require_relative 'matlab_interfaces_generator/agent_interfaces_matlab_data_structs'
require_relative 'matlab_interfaces_generator/agent_interfaces_sfun_scenario_serializer'
require_relative 'matlab_interfaces_generator/agent_interfaces_sfun_manoeuvre_deserializer'
require_relative 'matlab_interfaces_generator/agent_interfaces_sfun_packet_creator'
require_relative 'matlab_interfaces_generator/agent_interfaces_sfun_packet_reader'
#require_relative 'matlab_interfaces_generator/agent_interfaces_sfun_UDP_client'

# ========================================================================================
# ======================================== PYTHON ========================================
# ========================================================================================

require_relative 'python_interfaces_generator/agent_interfaces_python_data_structs'

# ========================================================================================
# ========================================= C++ ==========================================
# ========================================================================================

require_relative 'c++_interfaces_generator/agent_interfaces_data_structs'
require_relative 'c++_interfaces_generator/agent_interfaces'

# ========================================================================================
# ========================================= java =========================================
# ========================================================================================

require_relative 'java_interfaces_generator/agent_interfaces_java.rb'

# ========================================================================================
# ===================================== MATHEMATICA ======================================
# ========================================================================================

require_relative 'mathematica_interfaces_generator/agent_interfaces_mathematica'
require_relative 'mathematica_interfaces_generator/agent_interfaces_cpp_for_mathematica'

# ========================================================================================
# =================================== C STRUCT PRINTER ===================================
# ========================================================================================

require_relative 'struct_printer_generator/struct_printer_interfaces_generator'

puts "Done"
#
puts "---------------------------------------"
