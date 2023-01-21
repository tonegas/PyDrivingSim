include Agent

# Write structs of interfaces header file
File.open("#{$out_dir_cc}/#{$base_name}_data_structs.h", "w") do |f|
  header = <<-EOS
  // File for interfaces
  // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
  // Origin file: #{$objs[:origin_file]}
  // Origin CRC32: #{$crc}

  #ifndef #{$base_name}_data_structs_h
  #define #{$base_name}_data_structs_h

  #if defined(_DS1401)
  #include "ds1401_defines.h"
  #else
  #include <stdint.h>
  #endif

  #ifdef __cplusplus
  extern "C" {
  #endif

  // interfaces version for printing
  #define AGENTINTERFACESVER #{$objs[:origin_file].split('_v')[1].strip.split('.')[0].strip}#{$objs[:origin_file].split('_v')[1].strip.split('.')[1].strip}

  EOS
  footer = <<-EOS

	// Scenario message union
  typedef union {
    #{$objs[:in_struct].name} data_struct;
    char                     data_buffer[sizeof(#{$objs[:in_struct].name})];
  } scenario_msg_t;

  // Manoeuvre message union
  typedef union {
    #{$objs[:out_struct].name} data_struct;
    char                      data_buffer[sizeof(#{$objs[:out_struct].name})];
  } manoeuvre_msg_t;

  #ifdef __cplusplus
  } // extern "C"
  #endif

  #endif
  EOS
  f.puts Agent::clang_format(header, $clang_format)
  f.puts
  f.puts $objs[:in_struct]
  f.puts
  f.puts $objs[:out_struct]
  f.puts
  f.puts Agent::clang_format(footer, $clang_format)
end

puts "File #{$out_dir_cc}/#{$base_name}_data_structs.h generated"
