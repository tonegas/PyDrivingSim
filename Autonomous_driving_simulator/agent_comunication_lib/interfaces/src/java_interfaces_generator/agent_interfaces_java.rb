include Agent

# Write structs of interfaces header file
File.open("#{$out_dir_java}/#{$base_name}_data_structs.java", "w") do |f|
  header = <<-EOS
  // File for java interfaces
  // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
  // Origin file: #{$objs[:origin_file]}
  // Origin CRC32: #{$crc}

  import java.util.Arrays;
  import java.util.List;

  import com.sun.jna.Pointer;
  import com.sun.jna.Structure;

  EOS
  footer = <<-EOS

  public class DataStructures
  {
      // Scenario message class
      public static class Input_data_str extends Structure
      {
        public static class ByReference extends Input_data_str implements Structure.ByReference { }
        public static class ByValue extends Input_data_str implements Structure.ByValue { }

        #{$objs[:in_struct].name} data_struct;
        char   data_buffer[sizeof(#{$objs[:in_struct].name})];
      }

      public static class Output_data_str extends Structure
      {
        public static class ByReference extends Output_data_str implements Structure.ByReference { }
        public static class ByValue extends Output_data_str implements Structure.ByValue { }

         #{$objs[:out_struct].name} data_struct;
         char                      data_buffer[sizeof(#{$objs[:out_struct].name})];
      }

  EOS
  f.puts Agent::clang_format(header, $clang_format)
  f.puts
  #f.puts $objs[:in_struct]
  f.puts
  #f.puts $objs[:out_struct]
  f.puts
  f.puts Agent::clang_format(footer, $clang_format)
end

puts "File #{$out_dir_java}/#{$base_name}_java_dataStructure.java generated"

