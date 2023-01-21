/* ===============================================================================

  Client test for Server with agent

  Authors: Gastone Pietro Rosati Papini and Riccardo Donà

 =============================================================================== */

#include <stdio.h>
#include <stdlib.h>

extern "C" {
    #include "screen_print_c.h"
}
#include "interfaces_data_structs.h"
#include "agent_lib.h"
#include "screen_print.h"

#define DEFAULT_SERVER_IP  "127.0.0.1"
#define SERVER_PORT             30000  // Server port


int main(int argc, const char * argv[])
{
	// Messages variables
	input_data_str scenario_msg = {}; //Inizialization to zeros
	output_data_str manoeuvre_msg = {}; //Inizialization to zeros

    if (argc == 3) {
        printCenter("Fake Env for test comunication with the Agent - Remote Mode");
        printInputSection("Packages Dimensions");
        printTableAlign("Size Scenario",(unsigned long)sizeof(input_data_str),1);
        printTableAlign("Size Manoeuvre",(unsigned long)sizeof(output_data_str),1);
        client_agent_init(argv[1], atoi(argv[2]));
        char* server_start;
        sprintf(server_start, "Comunication to Server START === (IP: %s, Port: %d)", argv[1], atoi(argv[2]));
        printInputSection(server_start);
    }else{
        printCenter("Fake Env for test comunication with the Agent - Local Mode");
        client_agent_init(NULL, 0);
    }


	// This is are test numbers
	scenario_msg.ID = 1;                        //Is the scenario
	scenario_msg.Status = 0;                    //Must be set to 0 for running 1 for closing
    scenario_msg.Version = 1204;                //Interface code
	scenario_msg.RequestedCruisingSpeed = 20.0; //TEST NUMBER
	scenario_msg.ALgtFild  = 0.8;               //TEST NUMBER
	scenario_msg.VLgtFild  = 15.0;              //TEST NUMBER
	scenario_msg.LaneWidth = 5.0;               //TEST NUMBER

    // Start agent
	for (int i= 0; i<50; i++){
		scenario_msg.CycleNumber = i;           //Incremental number
		// Send and receive operations
        printLogTitle(scenario_msg.CycleNumber, "message sent");
		client_agent_compute(&scenario_msg, &manoeuvre_msg);
		// If you get the same numbers the server void works
        printLogTitle(scenario_msg.CycleNumber, "received message");
        printLogVar(scenario_msg.CycleNumber, "Received message from IP", server_receive_from());
        printLogVar(scenario_msg.CycleNumber, "ID", manoeuvre_msg.ID);                      //CHECK TEST NUMBER
        printLogVar(scenario_msg.CycleNumber , "CycleNumber", manoeuvre_msg.CycleNumber);   //CHECK TEST NUMBER
        printLogVar(scenario_msg.CycleNumber , "Status", manoeuvre_msg.Status);             //CHECK TEST NUMBER
	}

	// Close socket
	client_agent_close();
	return 0;
}
