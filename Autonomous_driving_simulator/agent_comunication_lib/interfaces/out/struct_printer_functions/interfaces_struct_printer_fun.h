 // File for interfaces
 // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
 // Originf file: interfaces_v1.2.csv
 // Origin CRC32: 4097400712

 #ifndef interfaces_struct_printer_fun_h
 #define interfaces_struct_printer_fun_h

 #include <stdio.h>
 #include "interfaces_data_structs.h"


 #ifdef __cplusplus
 extern "C" {
 #endif

 void StructPrinterHeaderIn( const input_data_str *data_input_load, FILE *fp_input );

 void StructPrinterDataIn( const input_data_str *data_input_load, FILE *fp_input );

 void StructPrinterHeaderOut( const output_data_str *data_input_load, FILE *fp_input );

 void StructPrinterDataOut( const output_data_str *data_input_load, FILE *fp_input );

 #ifdef __cplusplus
 }
 #endif

 #endif
