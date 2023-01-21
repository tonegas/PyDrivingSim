include Agent

# Write Mathematica header file
File.open("#{$out_dir_mathematica}/#{$base_name}_header.m", "w") do |f|
  body = <<-EOS
(* ::Package:: *)

(* ::Section:: *)
(* List of Functions for Mathematica *)

(* ::Text:: *)
(* WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT *)
(* Originf file: #{$objs[:origin_file]} *)
(* Origin CRC32: #{$crc} *)

(* ::Section:: *)
(* Interface header for package *)
InputIntegerFields; InputRealFields; OutputIntegerFields; OutputRealFields;
InputDataExternal; OutputDataExternal;
(* ::Section:: *)
(* Header Interfaces *)
#{$objs[:in_struct].m_header_package_in}
#{$objs[:out_struct].m_header_package_out}
EOS
  f.puts body
end

puts "File #{$out_dir_mathematica}/#{$base_name}_header.m generated"


# Write Mathematica file
File.open("#{$out_dir_mathematica}/#{$base_name}.m", "w") do |f|
  body = <<-EOS
(* ::Package:: *)

(* ::Section:: *)
(* Interfaces File for Mathematica *)

(* ::Text:: *)
(* WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT *)
(* Originf file: #{$objs[:origin_file]} *)
(* Origin CRC32: #{$crc} *)

(* ::Subsection:: *)
(* Crc code *)
CRC32 := #{$crc};
(* ::Section:: *)
(* Interfaces In *)
#{$objs[:in_struct].m_source_in}

(* ::Section:: *)
(* Interfaces Out *)
#{$objs[:out_struct].m_source_out}
EOS
  f.puts body
end

puts "File #{$out_dir_mathematica}/#{$base_name}.m generated"


# Write Mathematica offline function file
File.open("#{$out_dir_mathematica}/#{$base_name}_offline_fun.m", "w") do |f|
  body = <<-EOS
(* ::Package:: *)

(* ::Section:: *)
(* Interfaces File for Mathematica *)

(* ::Text:: *)
(* WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT *)
(* Originf file: #{$objs[:origin_file]} *)
(* Origin CRC32: #{$crc} *)
(* ::Section:: *)
(* Interfaces In *)
#{$objs[:in_struct].m_offline_fun_in}
(* ::Section:: *)
(* Interfaces Out *)
#{$objs[:out_struct].m_offline_fun_out}
EOS
  f.puts body
end

puts "File #{$out_dir_mathematica}/#{$base_name}_offline_fun.m generated"