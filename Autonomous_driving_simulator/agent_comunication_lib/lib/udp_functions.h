
/* ============================================================================

 UDP communication with limited packed size

 Author: Gastone Pietro Rosati Papini

 ============================================================================ */

#ifndef __UDP_LIMIT_FUNCTIONS_H
#define __UDP_LIMIT_FUNCTIONS_H

#if defined(_WIN32)
#pragma comment (lib, "Ws2_32.lib")
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <Winsock2.h>
#include <Ws2tcpip.h>

#elif defined(__MACH__) || defined(__linux__)
#include <arpa/inet.h>
#include <sys/socket.h>
#endif

#include "udp_defines.h"

// Create the socket + bind port if bind_port = true - return the socket_id
int open_socket(int bind_port, struct sockaddr_in *addr);

// Send message function
int send_message(int socket_id, const struct sockaddr_in *target_addr, volatile uint32_t server_run, uint32_t buffer_id, char *buffer, size_t buffer_size);

// Receive message function
int receive_message(int socket_id, struct sockaddr_in *target_addr, volatile uint32_t *server_run, uint32_t *buffer_id, char *buffer, size_t buffer_size, uint64_t start_time);

// Close socket
int close_socket(int socket_id);

// Get time function (milliseconds)
uint64_t get_time_ms();

// Sleep function (milliseconds)
void sleep_ms(unsigned int time_sleep_ms);

#endif
