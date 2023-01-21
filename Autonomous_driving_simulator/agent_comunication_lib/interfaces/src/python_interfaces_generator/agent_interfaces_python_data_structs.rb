include Agent

File.open("#{$out_dir_python}/#{$base_name}_python_data_structs.py", "w") do |f|
	body = <<-EOS
# File for interfaces
# WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
# Originf file: #{$objs[:origin_file]}
# Origin CRC32: #{$crc}
import ctypes as ct

class input_data_str(ct.Structure):
    _pack_ = 1
    _fields_=[
#{$objs[:in_struct].python_ctype_struct('ct')}\t]
class output_data_str(ct.Structure):
    _pack_ = 1
    _fields_=[
#{$objs[:out_struct].python_ctype_struct('ct')}\t]
	EOS
	f.puts body
end

puts "File #{$out_dir_python}/#{$base_name}_python_data_structs.py generated"