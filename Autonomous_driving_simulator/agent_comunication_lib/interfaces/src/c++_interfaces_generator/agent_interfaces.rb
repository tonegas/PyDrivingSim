include Agent

# Write co-driver header file
File.open("#{$out_dir_cc}/#{$base_name}_test.h", "w") do |f|
  body = <<-EOS
  // File for interfaces
  // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
  // Origin file: #{$objs[:origin_file]}
  // Origin CRC32: #{$crc}

  #ifndef #{$base_name}_test_h
  #define #{$base_name}_test_h

  #include "interfaces_data_structs.h"

  #{$objs[:in_struct].test_variables}

  #{$objs[:out_struct].test_variables}

  #endif
  EOS
  f.puts Agent::clang_format(body, $clang_format)
end

puts "File #{$out_dir_cc}/#{$base_name}_test.h generated"
