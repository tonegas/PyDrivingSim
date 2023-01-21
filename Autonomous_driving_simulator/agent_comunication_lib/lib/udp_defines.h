
/* ============================================================================

 UDP communication with limited packed size

 Author: Alessandro Mazzalai

============================================================================ */


#ifndef __UDP_DEFINES_H
#define __UDP_DEFINES_H

#if defined(_WIN32)
#include <stdint.h>
#include <string.h>
#elif defined(__MACH__) || defined (__linux__)
#include <stdlib.h>
#include <string.h>
#elif defined (_DS1401)
#include "ds1401_defines.h"
#endif

#include <math.h>



// Connection settings
#define PACKET_BYTES             1472  // Maximum packet bytes
#define PART_BYTES               (PACKET_BYTES-20)  // PACKET_BYTES - packet header

// Times
#define SLEEP_MS             1
#define AGENT_TIMEOUT_MS 50
#define RECV_SND_TIMEOUT_MS  5  // Warning: windows has an undocumented minimum limit of about 500 ms

// If the timeout is less than 400 ms it creates a non-blocking socket
#if defined(_WIN32) && RECV_SND_TIMEOUT_MS <= 400
#define WIN_NONBLOCK
#endif

// Integer types definition
typedef uint32_t UDP_UINT;  // to avoid padding in struct

// Packet struct (avoided padding using int32_t)
#if defined(MATLAB_MEX_FILE) || defined(_DS1401)
  typedef struct {
#elif defined(_WIN32)
#pragma pack(push, 1)
    typedef struct {
#else
      typedef struct __attribute__((packed)) {
#endif
  UDP_UINT server_run;                 // 1: run server, 0: stop server
  UDP_UINT part_pos;                   // message position
  UDP_UINT part_size;                  // message size
  UDP_UINT last_part_pos;              // last message position
  UDP_UINT datagram_id;                // message ID
  char     datagram_part[PART_BYTES];  // part of datagram message
} datagram_part_t;
#if defined(MATLAB_MEX_FILE) || defined(_DS1401)
      // Do nothing
#elif defined(_WIN32)
#pragma pack(pop)
#endif

// Packet union
typedef union {
  char            data_buffer[PACKET_BYTES];
  datagram_part_t data_struct;
  UDP_UINT        data_array[(size_t) PACKET_BYTES/4];
} packet_t;

#endif
