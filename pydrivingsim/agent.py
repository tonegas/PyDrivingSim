# Authors : Gastone Pietro Rosati Papini
# Date    : 09/08/2022
# License : MIT

import ctypes as ct
from datetime import datetime
from math import *

import agent.agent_interfaces_connector as agent_lib
from agent.interfaces_python_data_structs import input_data_str, output_data_str

from pydrivingsim import World, Vehicle, TrafficLight, TrafficCone, Target, SuggestedSpeedSignal


c = agent_lib.AgentConnector()

# Define types
type_integer_4 = ct.c_int32 * 4
type_integer_10 = ct.c_int32 * 10
type_integer_20 = ct.c_int32 * 20
type_double_10 = ct.c_double * 10
type_double_20 = ct.c_double * 20
type_double_100 = ct.c_double * 100

class Agent():
    __metadata = {
        "dt": 0.05
    }
    def __init__(self, vehicle: Vehicle):
        c.test_lib()
        self.vehicle = vehicle

        # Simulation information
        assert self.__metadata["dt"] >= World().get_dt()
        self.sim_call_freq = self.__metadata["dt"] / World().get_dt()
        self.num_of_step = 0

        IP = [127, 0, 0, 1]  # Remote usage
        PORT = 30000  # Default port for agent_test
        log_enable = 0  # The log can be True only in local usage
        type_of_log = 0  # Different level of log

        # Function for agent_test initialization
        c.client_agent_init_num(type_integer_4(*IP), PORT, log_enable, type_of_log)

        self.scenario_msg = input_data_str()
        self.manoeuvre_msg = output_data_str()

        # Create the pointer for the function call
        self.scenario_msg_pointer = ct.pointer(self.scenario_msg)
        self.manoeuvre_msg_pointer = ct.pointer(self.manoeuvre_msg)

        self.cycle_number = 0
        self.requested_cruising_speed = 20
        self.action = (0,0)

        # Data to be filtered
        self.ALgtFild = 0
        self.YawRateFild = 0
        self.SteerWhlAg = 0

    def compute(self):
        self.num_of_step += 1
        self.__filtering(self.vehicle)
        if self.num_of_step >= self.sim_call_freq:
            self.__compute(self.vehicle)
            self.num_of_step = 0
            self.__clear_filter()


    def __filtering(self, v :Vehicle):
        s: input_data_str = self.scenario_msg
        self.ALgtFild += v.dX[3] - v.state[5] * v.state[4]
        self.YawRateFild += v.state[5]
        self.SteerWhlAg += v.state[10]

    def __clear_filter(self):
        s: input_data_str = self.scenario_msg
        self.ALgtFild = 0
        self.YawRateFild = 0
        self.SteerWhlAg = 0

    def __compute(self, v :Vehicle):
        s :input_data_str = self.scenario_msg
        m :output_data_str = self.manoeuvre_msg

        # Closing env if agent request to close
        if m.Status == 1:
            self.terminate()

        # Basic parameters
        self.cycle_number += 1
        s.CycleNumber = self.cycle_number
        s.ID = 0
        s.TimeStamp = ct.c_double(datetime.timestamp(datetime.now()))
        s.Status = 0
        s.ECUupTime = World().time

        # Vehicle parameters
        s.VehicleLen = v.vehicle.vehicle.L                          # double - lenght dimension [m]
        s.VehicleWidth = v.vehicle.vehicle.Wf                       # double - width dimension [m]
        s.LaneHeading = -v.state[2]
        #print(v.state[2])
        #print((v.state[0],v.state[1]))
        s.VLgtFild = v.state[3]
        s.ALgtFild = self.ALgtFild/self.num_of_step
        s.YawRateFild = self.YawRateFild/self.num_of_step
        s.SteerWhlAg = self.SteerWhlAg/self.num_of_step
        s.RequestedCruisingSpeed = self.requested_cruising_speed

        # Lateral Position
        road_width = 4
        road_pos = v.state[1] - road_width/2
        if abs(road_pos) <= (road_width):
            s.LaneWidth = road_width
            s.LatOffsLineR = (s.LaneWidth - road_width/2) - v.state[1]
            s.LatOffsLineL = - road_width/2 - v.state[1]

        # Objects parameters (traffic light and obstacles)
        trafficlight = 0
        trafficlightDist = 0
        speedlimitId = 0
        objId = 0
        target = 0
        for obj in World().obj_list:
            if type(obj) is TrafficLight:
                # Get the closest trafficlight in front
                if trafficlightDist == 0 or (obj.pos[0] - v.state[0] > -1.0 and obj.pos[0] - v.state[0] < trafficlightDist):
                    trafficlightDist = obj.pos[0] - v.state[0]
                    trafficlight = obj

            if type(obj) is TrafficCone:
                s.ObjID[objId] = 1
                delta_x = obj.pos[0] - v.state[0]
                delta_y = obj.pos[1] - v.state[1]
                s.ObjX[objId] = delta_x * cos(v.state[2]) + delta_y * sin(v.state[2])
                s.ObjY[objId] = - delta_x * sin(v.state[2]) + delta_y * cos(v.state[2])
                s.ObjVel[objId] = 0
                s.ObjLen[objId] = obj.size
                s.ObjWidth[objId] = obj.size
                objId = objId + 1

            if type(obj) is SuggestedSpeedSignal:
                s.AdasisSpeedLimitValues[speedlimitId] = obj.vel
                s.AdasisSpeedLimitDist[speedlimitId] = obj.pos[0] - v.state[0]
                speedlimitId = speedlimitId + 1

        s.NrObjs = objId
        s.AdasisSpeedLimitNr = speedlimitId

        s.NrTrfLights = 0
        if trafficlight:
            s.NrTrfLights = 1
            s.TrfLightDist = trafficlight.pos[0] - v.state[0]
            s.TrfLightCurrState = trafficlight.state + 1  # 1 = Green, 2 = Yellow, 3 = Red, 0 = Flashing
            s.TrfLightFirstTimeToChange = trafficlight.time_phases[
                                              trafficlight.state] - trafficlight.time_past_switch
            s.TrfLightFirstNextState = divmod(trafficlight.state + 1, 3)[1] + 1
            s.TrfLightSecondTimeToChange = s.TrfLightFirstTimeToChange + trafficlight.time_phases[
                divmod(trafficlight.state + 1, 3)[1]]
            s.TrfLightSecondNextState = divmod(trafficlight.state + 2, 3)[1] + 1
            s.TrfLightThirdTimeToChange = s.TrfLightSecondTimeToChange + trafficlight.time_phases[
                divmod(trafficlight.state + 2, 3)[1]]

        # print("CS:" + str(s.TrfLightDist))
        # print("CS:" + str(s.TrfLightCurrState))
        # print("NS:(" + str(s.TrfLightFirstTimeToChange) + "," + str(s.TrfLightFirstNextState) + ")")
        # print("NNS:(" + str(s.TrfLightSecondTimeToChange) + "," + str(s.TrfLightSecondNextState) + ")")
        # print("NNNS:(" + str(s.TrfLightThirdTimeToChange) +")")

        c.client_agent_compute(self.scenario_msg_pointer, self.manoeuvre_msg_pointer)

        # print("ID = " + str(m.ID))
        # print("Version = " + str(m.Version))
        # print("CycleNumber = " + str(m.CycleNumber))
        # print("ECUupTime = " + str(m.ECUupTime))
        # print("Status = " + str(m.Status))
        # print("CycleNumber = " + str(m.CycleNumber))
        # print("RequestedAcc = " + str(m.RequestedAcc))

        #self.action = (0.01, 0.01)
        self.action = (m.RequestedAcc,m.RequestedSteerWhlAg)

    def terminate(self):
        World().loop = 0

        self.cycle_number += 1
        self.scenario_msg.CycleNumber = self.cycle_number
        self.scenario_msg.TimeStamp = ct.c_double(datetime.timestamp(datetime.now()))
        self.scenario_msg.ECUupTime = World().time;
        self.scenario_msg.Status = 1

        c.client_agent_compute(self.scenario_msg_pointer, self.manoeuvre_msg_pointer)
        c.client_agent_close()

    def get_action(self):
        return self.action
