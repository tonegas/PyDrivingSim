include Agent

# Write source file
File.open("#{$out_dir_mathematica}/#{$base_name}.cc", "w") do |f|
  header = <<-EOS
  // File for interfaces
  // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
  // Origin file: #{$objs[:origin_file]}
  // Origin CRC32: #{$crc}

  #define LM_NNNN
  /* Level of the library */
  #include "lightmat.h"

  #include "#{$base_name}_data_structs.h"

  EOS
  body = <<-EOS
  unsigned long agentCRC() {
    return #{$crc};
  }

  #{$objs[:in_struct].name} *ptr_Agent_#{$objs[:in_struct].name};
  #{$objs[:out_struct].name} *ptr_Agent_#{$objs[:out_struct].name};

  EOS

  f.puts Agent::clang_format(header, $clang_format)
  f.puts
  f.puts Agent::clang_format(body, $clang_format)
  f.puts
  f.puts $objs[:in_struct].c_source_in
  f.puts $objs[:out_struct].c_source_out
end

puts "File #{$out_dir_mathematica}/#{$base_name}.cc generated"