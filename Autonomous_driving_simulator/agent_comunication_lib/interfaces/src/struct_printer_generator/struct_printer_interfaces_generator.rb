include Agent

#Write struct printer functions file
File.open("#{$out_dir_struct_printer}/#{$base_name}_struct_printer_fun.h", "w") do |f|
 body = <<-EOS
 // File for interfaces
 // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
 // Originf file: #{$objs[:origin_file]}
 // Origin CRC32: #{$crc}

 #ifndef #{$base_name}_struct_printer_fun_h
 #define #{$base_name}_struct_printer_fun_h

 #include <stdio.h>
 #include "#{$base_name}_data_structs.h"


 #ifdef __cplusplus
 extern "C" {
 #endif

 void StructPrinterHeaderIn( const #{$objs[:in_struct].name} *data_input_load, FILE *fp_input );

 void StructPrinterDataIn( const #{$objs[:in_struct].name} *data_input_load, FILE *fp_input );

 void StructPrinterHeaderOut( const #{$objs[:out_struct].name} *data_input_load, FILE *fp_input );

 void StructPrinterDataOut( const #{$objs[:out_struct].name} *data_input_load, FILE *fp_input );

 #ifdef __cplusplus
 }
 #endif

 #endif
 EOS
 f.puts body
end

puts "File #{$out_dir_struct_printer}/#{$base_name}_struct_printer_fun.h generated"


File.open("#{$out_dir_struct_printer}/#{$base_name}_struct_printer_fun.cc", "w") do |f|
 body = <<-EOS
 // File for interfaces
 // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
 // Originf file: #{$objs[:origin_file]}
 // Origin CRC32: #{$crc}

 #include <stdio.h>
 #include "#{$base_name}_struct_printer_fun.h"

 #ifdef __cplusplus
 extern "C" {
 #endif

 void StructPrinterHeaderIn( const #{$objs[:in_struct].name} *data_input_load, FILE *fp_input ) {
   #{$objs[:in_struct].struct_fprintf(:header)}
 }

 void StructPrinterDataIn( const #{$objs[:in_struct].name} *data_input_load, FILE *fp_input ) {
   #{$objs[:in_struct].struct_fprintf(:data)}
 }

 void StructPrinterHeaderOut( const #{$objs[:out_struct].name} *data_input_load, FILE *fp_input ) {
   #{$objs[:out_struct].struct_fprintf(:header)}
 }

 void StructPrinterDataOut( const #{$objs[:out_struct].name} *data_input_load, FILE *fp_input ) {
   #{$objs[:out_struct].struct_fprintf(:data)}
 }

 #ifdef __cplusplus
 }
 #endif

 EOS
 f.puts body
end

puts "File #{$out_dir_struct_printer}/#{$base_name}_struct_printer_fun.cc generated"