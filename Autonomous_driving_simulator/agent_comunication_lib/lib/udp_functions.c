
/* ============================================================================

 UDP communication with limited packed size

 Author: Gastone Pietro Rosati Papini

 ============================================================================ */

#ifdef _WIN32

#include <Winsock2.h>
#include <Ws2tcpip.h>

#elif defined(__MACH__) || defined(__linux__)
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/time.h>
#endif

#include <stdio.h>
#include <math.h>
#include <signal.h>

#include "udp_functions.h"


// Open socket ================================================================
int open_socket(int bind_port, struct sockaddr_in *addr) {
    //id of the socket initialized
    int socket_id = 0;

    unsigned int opt_buflen;
    struct timeval timeout;

#if defined(WIN_NONBLOCK)
    unsigned long nonblock;
#elif defined(_WIN32)
    DWORD timeout_win;
#endif


    // Windows initialise winsock ----------------------------------------------
#if defined(_WIN32)
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        fprintf(stderr, "WSAStartup() failed. Error Code: %d\n", WSAGetLastError());
        return -1;
    }
#endif

    // Create UDP socket ---------------------------------------------------------
#if defined(_WIN32)
    if ((socket_id = (int) socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == INVALID_SOCKET) {
        fprintf(stderr, "socket() failed. Error Code: %d\n", WSAGetLastError());
        return -1;
    }
    int rcvbufsize = 40000;
    setsockopt(socket_id, SOL_SOCKET, SO_RCVBUF, (char *) &rcvbufsize, sizeof(rcvbufsize));
#elif defined(__MACH__) || defined(__linux__)
    if ((socket_id = (int)socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
        perror("error socket()");
        return -1;
    }
#endif

    // Set send buffer size limit ------------------------------------------------
    opt_buflen = PACKET_BYTES;
#if defined(_WIN32)
    if (setsockopt(socket_id, SOL_SOCKET, SO_SNDBUF, (char *) &opt_buflen, sizeof(opt_buflen)) == SOCKET_ERROR) {
        fprintf(stderr, "setsockopt() failed. Error Code: %d\n", WSAGetLastError());
        return -1;
    }
#elif defined(__MACH__) || defined(__linux__)
    if (setsockopt(socket_id, SOL_SOCKET, SO_SNDBUF, (char *)&opt_buflen, sizeof(opt_buflen)) == -1) {
        perror("error setsockopt()");
        return -1;
    }
#endif


    // Set send and receive time-outs ---------------------------------------------
    // Windows: it is used a non-blocking socket if defined time-out <= 400 ms
    timeout.tv_sec = 0;
    timeout.tv_usec = RECV_SND_TIMEOUT_MS * 1000;
#if defined(WIN_NONBLOCK)
    nonblock = 1;
    if (ioctlsocket(socket_id, FIONBIO, &nonblock) == SOCKET_ERROR) {
        fprintf(stderr, "ioctlsocket() failed. Error Code: %d\n", WSAGetLastError());
        return -1;
    }
#elif defined(_WIN32)
    timeout_win = timeout.tv_sec * 1000 + timeout.tv_usec / 1000;  // timeout in ms
    if (setsockopt(socket_id, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout_win, sizeof(DWORD)) == SOCKET_ERROR) {
        fprintf(stderr, "setsockopt() failed. Error Code: %d\n", WSAGetLastError());
        return -1;
    }
    if (setsockopt(socket_id, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout_win, sizeof(DWORD)) == SOCKET_ERROR) {
        fprintf(stderr, "setsockopt() failed. Error Code: %d\n", WSAGetLastError());
        return -1;
    }
#elif defined(__MACH__) || defined(__linux__)
    if (setsockopt(socket_id, SOL_SOCKET, SO_SNDTIMEO, (char *)&timeout, sizeof(timeout)) == -1) {
        perror("error setsockopt()");
        return -1;
    }
    if (setsockopt(socket_id, SOL_SOCKET, SO_RCVTIMEO, (char *)&timeout, sizeof(timeout)) == -1) {
        perror("error setsockopt()");
        return -1;
    }
#endif

    // If it is a server, bind socket to port
    if (bind_port == 1) {
#if defined(_WIN32)
        if (bind(socket_id, (struct sockaddr *) addr, sizeof(*addr)) == -1) {
            fprintf(stderr, "bind() failed. Error Code: %d\n", WSAGetLastError());
            return -1;
        }
#elif defined(__MACH__) || defined(__linux__)
        if (bind(socket_id, (const struct sockaddr*) addr, sizeof(*addr)) == -1) {
            perror("error bind()");
            return -1;
        }
#endif
    }
    return socket_id;
}

// Close socket ================================================================
int close_socket(int socket_id) {
#if defined(_WIN32)
    if (closesocket(socket_id) == SOCKET_ERROR) {
        fprintf(stderr, "setsockopt() failed. Error Code: %d\n", WSAGetLastError());
        WSACleanup();
        return -1;
    }
    WSACleanup();
#elif defined(__MACH__) || defined(__linux__)
    if (close(socket_id) == -1) {
        perror("error close()");
        return -1;
    }
#endif

    return 0;
}

// Send message function =======================================================
int send_message(int socket_id, const struct sockaddr_in *addr, volatile uint32_t server_run, uint32_t message_id,
                 char *message, size_t message_size) {
    packet_t packet;
    UDP_UINT n_packets;
    UDP_UINT remaining_bytes;
    UDP_UINT part_bytes;
    UDP_UINT i;

#if defined(WIN_NONBLOCK)
    uint64_t socket_start_time;
    uint64_t socket_elapsed_time;
#endif

    n_packets = (UDP_UINT) ceilf((float) message_size / sizeof(packet.data_struct.datagram_part));
    remaining_bytes = message_size % sizeof(packet.data_struct.datagram_part);
    part_bytes = sizeof(packet.data_struct.datagram_part);
#ifdef DEBUG
    printf("n_packets:%d remaining_bytes:%d part_bytes: %d\n",n_packets,remaining_bytes,part_bytes);
#endif

    // Send packets
    i = 0;
    while (i < n_packets) {
        memset(packet.data_buffer, '\0', sizeof(packet.data_buffer));

        packet.data_struct.server_run = htonl(server_run);
        packet.data_struct.part_pos = htonl(i);
        packet.data_struct.last_part_pos = htonl(n_packets - 1);
        packet.data_struct.datagram_id = htonl(message_id);

        if (ntohl(packet.data_struct.part_pos) != ntohl(packet.data_struct.last_part_pos))
            packet.data_struct.part_size = htonl(part_bytes);
        else
            packet.data_struct.part_size = htonl(remaining_bytes);

        memcpy(&packet.data_struct.datagram_part,
               message + ntohl(packet.data_struct.part_pos) * sizeof(packet.data_struct.datagram_part),
               ntohl(packet.data_struct.part_size));
#if defined(WIN_NONBLOCK)
        socket_start_time = get_time_ms();
        while (1) {
            if (sendto(socket_id, packet.data_buffer, (size_t) PACKET_BYTES, 0, (struct sockaddr *) addr,
                       sizeof(*addr)) == SOCKET_ERROR) {
                socket_elapsed_time = get_time_ms() - socket_start_time;
                if (WSAGetLastError() != WSAEWOULDBLOCK || socket_elapsed_time >= RECV_SND_TIMEOUT_MS) {
                    fprintf(stderr, "sendto() failed. Error Code: %d\n", WSAGetLastError());
                    return -1;
                }
            } else
                break;
        }
#elif defined(_WIN32)
        if (sendto(socket_id, packet.data_buffer, (size_t) PACKET_BYTES, 0, (struct sockaddr *) addr, sizeof(*addr)) == SOCKET_ERROR) {
            fprintf(stderr, "sendto() failed. Error Code: %d\n", WSAGetLastError());
            return -1;
        }
#elif defined(__MACH__) || defined(__linux__)
        if (sendto(socket_id, packet.data_buffer, (size_t) PACKET_BYTES, 0, (struct sockaddr *) addr, sizeof(*addr)) == -1) {
            perror("error sendto()");
            return -1;
        }
#endif
        i++;
    }

#ifdef DEBUG
    printf("Sent message of %d packets to %s:%d\n",
        n_packets,
        inet_ntoa(addr->sin_addr),
        ntohs (addr->sin_port)
    );
#endif
    return 0;
}


// Handler for CTRL-C ==========================================================
static volatile UDP_UINT receiver_run = 1;
void intHandlerUDP(int signal) {
    receiver_run = 0;
}


// Receive message function ====================================================
int receive_message(int socket_id, struct sockaddr_in *addr, volatile uint32_t *server_run, uint32_t *message_id,
                    char *message, size_t message_size, uint64_t start_time) {

    socklen_t addr_len;

    packet_t packet;
    UDP_UINT n_packets = (UDP_UINT) ceilf((float) message_size / sizeof(packet.data_struct.datagram_part));
    UDP_UINT readed_packets = 0;
    int recv_bytes = 0;
    uint32_t datagram_id = 0;
    unsigned int buffer_bytes = 0;
    uint64_t agent_timeout_ms = AGENT_TIMEOUT_MS;

#if defined(WIN_NONBLOCK)
    uint64_t socket_start_time;
    uint64_t socket_elapsed_time;
#endif

    uint64_t elapsed_time;

    addr_len = sizeof(*addr);


#ifndef WIN32
    // More portable way of supporting signals on UNIX
    struct sigaction act;
    act.sa_handler = intHandlerUDP;
    sigaction(SIGINT, &act, NULL);
#else
    signal(SIGINT, intHandlerUDP);
#endif


    if (start_time == 0)
        elapsed_time = 0;
    else
        elapsed_time = get_time_ms() - start_time;


    // Receive packets
    while (receiver_run == 1 && readed_packets < n_packets && elapsed_time <= agent_timeout_ms) {

        memset(packet.data_buffer, '\0', sizeof(packet.data_buffer));

#if defined(WIN_NONBLOCK)
        socket_start_time = get_time_ms();
        while (1) {
            recv_bytes = recvfrom(socket_id, packet.data_buffer, (size_t) PACKET_BYTES, 0, (struct sockaddr *) addr,
                                  &addr_len);
            socket_elapsed_time = get_time_ms() - socket_start_time;

            if (recv_bytes == SOCKET_ERROR) {
                if (WSAGetLastError() != WSAEWOULDBLOCK || socket_elapsed_time >= RECV_SND_TIMEOUT_MS)
                    break;
            } else
                break;
        }
        if (recv_bytes != SOCKET_ERROR)
#elif defined(_WIN32)
        recv_bytes = recvfrom(socket_id, packet.data_buffer, (size_t) PACKET_BYTES, 0, (struct sockaddr *) addr, &addr_len);

        if (recv_bytes != SOCKET_ERROR)
#elif defined(__MACH__) || defined(__linux__)
        recv_bytes = recvfrom(socket_id, packet.data_buffer, (size_t) PACKET_BYTES, 0, (struct sockaddr *) addr, &addr_len);

        if (recv_bytes > 0)
#endif
        {
            n_packets = ntohl(packet.data_struct.last_part_pos) + 1;
            *server_run = ntohl(packet.data_struct.server_run);

            if (*server_run == 0) return 1;

            if (datagram_id == 0 || ntohl(packet.data_struct.datagram_id) == datagram_id) {
                if (datagram_id == 0)
                    datagram_id = ntohl(packet.data_struct.datagram_id);
                memcpy(message + ntohl(packet.data_struct.part_pos) * sizeof(packet.data_struct.datagram_part),
                       &packet.data_struct.datagram_part, ntohl(packet.data_struct.part_size));
                buffer_bytes += recv_bytes;
                readed_packets++;
            } else {
                if (ntohl(packet.data_struct.datagram_id) > datagram_id) {
                    fprintf(stderr, "[%10f][%5d] %s",0.0,datagram_id,"!!!!!!!!!!!!!!!!!!!!!!!!!packet lost!!!!!!!!!!!!!!!!!!!!");
                    buffer_bytes = 0;
                    readed_packets = 0;
                    datagram_id = ntohl(packet.data_struct.datagram_id);
                    memset(message, '0', message_size);
                    memcpy(message + ntohl(packet.data_struct.part_pos) * sizeof(packet.data_struct.datagram_part),
                           &packet.data_struct.datagram_part, ntohl(packet.data_struct.part_size));
                    buffer_bytes += recv_bytes;
                    readed_packets++;
                } else {
                    fprintf(stderr, "[%10f][%5d] %s",0.0,datagram_id,"!!!!!!!!!!!!!!!!!!!!!!old Packet received!!!!!!!!!!!!!!!!");
                }
            }

#ifdef DEBUG
            printf("Packet received!\n");
            printf("server_run = %d\n", *server_run);
            printf("part_pos = %d\n", ntohl(packet.data_struct.part_pos));
            printf("part_size = %d\n", ntohl(packet.data_struct.part_size));
            printf("n_packets = %d\n", n_packets);
            printf("datagram_id = %d\n", ntohl(packet.data_struct.datagram_id));
            printf("size of data received = %lu\n", sizeof(packet.data_struct.datagram_part));
#endif

        }

        // Calculate elapsed time
        if (start_time == 0) {
            elapsed_time = 0;
            sleep_ms(SLEEP_MS);
        } else
            elapsed_time = get_time_ms() - start_time;
    }

    if (readed_packets == n_packets) {
        *message_id = datagram_id;
#ifdef DEBUG
        printf("Received message of %d packets from %s:%d\n",
               n_packets,
               inet_ntoa(addr->sin_addr),
               ntohs(addr->sin_port));
#endif
        return 0;
    } else if (elapsed_time >= agent_timeout_ms) {
        fprintf(stderr, "Receive Warning: Time-out reached! Timeout is:%llu Time needed: %llu\n",
               (unsigned long long) agent_timeout_ms, (unsigned long long) elapsed_time);
    } else if (receiver_run == 0) {
        *server_run = 0;
    }
    return -1;
}

// Get time function (milliseconds) ============================================
uint64_t get_time_ms() {

    uint64_t time_ms;

#if defined(_WIN32)
    LARGE_INTEGER time_query;
    LARGE_INTEGER frequency;

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&time_query);
    time_query.QuadPart *= 1000000;
    time_ms = (time_query.QuadPart / frequency.QuadPart) / 1000;
#elif defined(__MACH__) || defined (__linux__)
    struct timeval time_get;

    gettimeofday(&time_get, NULL);
    time_ms = (uint64_t) (time_get.tv_sec*1000 + time_get.tv_usec/1000);
#endif
    return time_ms;
}

// Sleep function (milliseconds) ===============================================
void sleep_ms(unsigned int time_sleep_ms) {
#if defined(_WIN32)
    Sleep(time_sleep_ms);
#elif defined(__MACH__) || defined (__linux__)
    usleep(time_sleep_ms*1000);
#endif
}
