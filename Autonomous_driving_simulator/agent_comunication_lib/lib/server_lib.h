/* ============================================================================

 UDP communication functions for the server agent

 Author: Gastone Pietro Rosati Papini

 ============================================================================ */

#ifndef __SERVER_LIB_H
#define __SERVER_LIB_H

#include "interfaces_data_structs.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef DLL_EXPORT
#define USE_DLL __declspec(dllexport)
#elif DLL_IMPORT
#define USE_DLL __declspec(dllimport)
#else
#define USE_DLL
#endif

// Fuction for testing library loading
USE_DLL	void test_lib();

/*  ------------------------------------ SERVER FUNCTIONS ------------------------------------  */
// Server Init Matlab ============================================================================
USE_DLL	void server_agent_init_num(unsigned int num_ip[4], int server_port);

// Server agent Init =============================================================================
USE_DLL	void server_agent_init(const char *server_ip, int server_port);

// Server agent Send =============================================================================
USE_DLL	int server_send_to_client(uint32_t server_run, uint32_t message_id, output_data_str* manoeuvre_msg);

// Server agent Receive ==========================================================================
USE_DLL	int server_receive_from_client(uint32_t *server_run, uint32_t *message_id, input_data_str* scenario_msg);

// Server get ip of the client====================================================================
USE_DLL char* server_receive_from();

// Server agent Close ============================================================================
USE_DLL	void server_agent_close();
/*  ------------------------------------ SERVER FUNCTIONS ------------------------------------  */

#ifdef __cplusplus
}
#endif

#endif
