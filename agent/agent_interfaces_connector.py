
import ctypes as ct
from sys import platform

import agent.interfaces_python_data_structs as interface

if platform == "linux" or platform == "linux2":
    lib_file = "agent/libagent_lib.so"
elif platform == "darwin":
    lib_file = "agent/libagent_lib.dylib"
elif platform == "win32":
    lib_file = "agent/agent_lib.dll"

class AgentConnector():
    def __init__(self):
        self.agentlib = ct.CDLL(lib_file)
        # /*  ------------------------------------ CLIENT FUNCTIONS ------------------------------------  */
        # Fuction for testing library loading
        # void test_lib_agent();
        self.test_lib = self.agentlib.test_lib
        self.test_lib.restype = None

        # Client agent_test init for matlab
        # void client_agent_init_num(unsigned int num_ip[4] = NULL, int server_port = 0, int log_on = false, int log_type = 0);
        self.client_agent_init_num = self.agentlib.client_agent_init_num
        self.client_agent_init_num.restype = None

        # Client agent_test init
        # void client_agent_init(const char *server_ip = NULL, int server_port = 0, int log_on = false, int log_type = 0);
        self.client_agent_init = self.agentlib.client_agent_init
        self.client_agent_init.restype = None

        # Client send
        # int client_send_to_server(volatile uint32_t server_run, uint32_t message_id, input_data_str* scenario_msg);
        self.client_send_to_server  = self.agentlib.client_send_to_server
        self.client_send_to_server.restype = ct.c_int32

        # Client receive
        # int client_receive_form_server(uint32_t *server_run, uint32_t *message_id, output_data_str* manoeuvre_msg, uint64_t start_time);
        self.client_receive_form_server = self.agentlib.client_receive_form_server
        self.client_receive_form_server.restype = ct.c_int32

        # Client for agent_test compute: send and receive in one function
        # void client_agent_compute(input_data_str* scenario_msg, output_data_str* manoeuvre_msg);
        self.client_agent_compute = self.agentlib.client_agent_compute
        self.client_agent_compute.argtype = [ct.POINTER(interface.input_data_str),ct.POINTER(interface.output_data_str)]
        self.client_agent_compute.restype = None

        # Close agent_test
        # void client_agent_close();
        self.client_agent_close = self.agentlib.client_agent_close
        self.client_agent_close.restype = None
        # /*  ------------------------------------ CLIENT FUNCTIONS ------------------------------------  */

        #/*  ------------------------------------ SERVER FUNCTIONS ------------------------------------  */
        # void server_agent_init(const char *server_ip, int server_port);
        self.server_agent_init = self.agentlib.server_agent_init
        self.server_agent_init.restype = None

        # int server_send_to_client(uint32_t server_run, uint32_t message_id, output_data_str* manoeuvre_msg);
        self.server_send_to_client = self.agentlib.server_send_to_client
        self.server_send_to_client.restype = ct.c_int32

        # int server_receive_from_client(uint32_t *server_run, uint32_t *message_id, input_data_str* scenario_msg);
        self.server_receive_from_client = self.agentlib.server_receive_from_client
        self.server_receive_from_client.restype = ct.c_int32

        # char* server_receive_from();
        self.server_receive_from = self.agentlib.server_receive_from
        self.server_receive_from.restype = ct.POINTER(ct.c_char)

        # void server_agent_close();
        self.server_agent_close = self.agentlib.server_agent_close
        self.server_agent_close.restype = None
        #/*  ------------------------------------ SERVER FUNCTIONS ------------------------------------  */
