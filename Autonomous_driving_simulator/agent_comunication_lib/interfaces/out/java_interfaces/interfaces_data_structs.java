// File for java interfaces
// WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
// Origin file: interfaces_v1.2.csv
// Origin CRC32: 4097400712

import java.util.Arrays;
import java.util.List;

import com.sun.jna.Pointer;
import com.sun.jna.Structure;




public
class DataStructures {
  // Scenario message class
public
  static class Input_data_str extends Structure {
  public
    static class ByReference extends Input_data_str implements
        Structure.ByReference {}
  public
    static class ByValue extends Input_data_str implements Structure.ByValue {}

    input_data_str data_struct;
    char data_buffer[sizeof(input_data_str)];
  }

  public static class Output_data_str extends Structure {
  public
    static class ByReference extends Output_data_str implements
        Structure.ByReference {}
  public
    static class ByValue extends Output_data_str implements Structure.ByValue {}

    output_data_str data_struct;
    char data_buffer[sizeof(output_data_str)];
  }
