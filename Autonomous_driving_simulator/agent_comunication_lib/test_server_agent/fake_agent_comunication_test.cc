
/* ===============================================================================

  Basic Agent based on matlab solution

  Authors: Gastone Pietro Rosati Papini

 =============================================================================== */

#include <stdio.h>
#include <math.h>
#include <string.h>

extern "C" {
    #include "screen_print_c.h"
}
#include "screen_print.h"
#include "server_lib.h"
//#include "logvars.h"

#define DEFAULT_SERVER_IP  "127.0.0.1"
#define SERVER_PORT             30000  // Server port

// Handler for CTRL-C
#include <signal.h>
static uint32_t server_run = 1;
void intHandler(int signal) {
	server_run = 0;
}

int main(int argc, const char * argv[])
{
    //LogManager log = LogManager();
    //log.enable(true);

	// Messages variables
	scenario_msg_t  scenario_msg;
	manoeuvre_msg_t manoeuvre_msg;
	size_t scenario_msg_size  = sizeof(scenario_msg.data_buffer);
	size_t manoeuvre_msg_size = sizeof(manoeuvre_msg.data_buffer);
	uint32_t message_id = 0;

#ifndef _MSC_VER
	// More portable way of supporting signals on UNIX
	struct sigaction act;
	act.sa_handler = intHandler;
	sigaction(SIGINT, &act, NULL);
#else
	signal(SIGINT, intHandler);
#endif

	auto start = std::chrono::system_clock::now();
    //agentInitialize(...); //Local Agent function missing
	server_agent_init(DEFAULT_SERVER_IP,SERVER_PORT);


	// Start server
	while(server_run == 1) {

		// Clean the buffer
		memset(scenario_msg.data_buffer, '\0', scenario_msg_size);
		if (server_receive_from_client(&server_run, &message_id, &scenario_msg.data_struct) == 0) {

            input_data_str *in = &scenario_msg.data_struct;

			printLogTitle(message_id, "received message");
            printLogVar(message_id, "ID", in->ID );
			printLogVar(message_id , "CycleNumber", in->CycleNumber);
			printLogVar(message_id , "ECUupTime", in->ECUupTime);
			printLogVar(message_id, "Current velocity [m/s]", in->VLgtFild);
            printLogVar(message_id, "RequestedCruisingSpeed [m/s]", in->RequestedCruisingSpeed);

            // Check values
            // agentLogAndCompute(scenario_msg, manoeuvre_msg); //Local Agent function missing
            manoeuvre_msg.data_struct.ID = scenario_msg.data_struct.ID;
            manoeuvre_msg.data_struct.CycleNumber = scenario_msg.data_struct.CycleNumber;
            manoeuvre_msg.data_struct.Version = 0;
            manoeuvre_msg.data_struct.Status = scenario_msg.data_struct.Status;

            if (server_send_to_client(server_run, message_id, &manoeuvre_msg.data_struct) == -1) {
                perror("error send_message()");
				exit(EXIT_FAILURE);
			}else{
                printLogTitle(message_id, "sent message");
			}
		}
	}

    //agentTerminate(); //Local Agent function missing
	server_agent_close();
	return 0;
}
