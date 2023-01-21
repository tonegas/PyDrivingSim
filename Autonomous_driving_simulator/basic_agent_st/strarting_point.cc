#include <stdio.h>
#include <math.h>
#include <vector>
#include <algorithm>
#include <string.h>
#include <vector>


extern "C" {
#include "screen_print_c.h"
}
#include "screen_print.h"
#include "server_lib.h"
#include "logvars.h"
#include "Clothoids.hh"
#include "primitives.h"

#define DEFAULT_SERVER_IP  "127.0.0.1"  // IP Address
#define SERVER_PORT        30000        // Server port
#define DT                 0.05         // Time step

// Handler for CTRL-C
#include <signal.h>
static uint32_t server_run = 1;
void intHandler(int signal) {
    server_run = 0;
}

// STATIC FUNCTION DECLARATION

static void copy_m(double m1[6], double m2[6]);
static int check_0(double m[6]);
static double jEval(double t, double m[6]);
static double v_requested(double t, double m[6]);
static void vehicle_position(double x0, double x_act, double offL, double offR, double* X, double* Y);

//   __  __    _    ___ _   _ 
//  |  \/  |  / \  |_ _| \ | |
//  | |\/| | / _ \  | ||  \| |
//  | |  | |/ ___ \ | || |\  |
//  |_|  |_/_/   \_\___|_| \_|
                           

int main(int argc, const char * argv[]) {
    logger.enable(true);

    // Messages variables
    scenario_msg_t scenario_msg;
    manoeuvre_msg_t manoeuvre_msg;
    size_t scenario_msg_size = sizeof(scenario_msg.data_buffer);
    size_t manoeuvre_msg_size = sizeof(manoeuvre_msg.data_buffer);
    uint32_t message_id = 0;
    std::string filename = "Long_param";
    std::string filename_path = "Path";
    std::string filename_traj = "Trajectory";
    static bool traj = false;
    G2lib::ClothoidList trajectory;

#ifndef _MSC_VER
    // More portable way of supporting signals on UNIX
    struct sigaction act;
    act.sa_handler = intHandler;
    sigaction(SIGINT, &act, NULL);
#else
    signal(SIGINT, intHandler);
#endif

    server_agent_init(DEFAULT_SERVER_IP, SERVER_PORT);

    // Start server of the Agent
    printLine();
    printTable("Waiting for scenario message...", 0);
    printLine();
    while (server_run == 1) {

        // Clean the buffer
        memset(scenario_msg.data_buffer, '\0', scenario_msg_size);

        // Receive scenario message from the environment
        if (server_receive_from_client(&server_run, &message_id, &scenario_msg.data_struct) == 0) {
            // Init time
            static auto start = std::chrono::system_clock::now();
            auto time = std::chrono::system_clock::now()-start;
            double num_seconds = std::chrono::duration_cast<std::chrono::milliseconds>(time).count()/1000.0;
            printLogTitle(message_id, "received message");

            // Data struct
            input_data_str *in = &scenario_msg.data_struct;
            output_data_str *out = &manoeuvre_msg.data_struct;
            manoeuvre_msg.data_struct.CycleNumber = in->CycleNumber;
            manoeuvre_msg.data_struct.Status = in->Status;

/* -------------------------------------------------------------------------------------------------------------- */

            //   _____ ____      _       _ _____ ____ _____ ___  ______   __
            //  |_   _|  _ \    / \     | | ____/ ___|_   _/ _ \|  _ \ \ / /
            //    | | | |_) |  / _ \ _  | |  _|| |     | || | | | |_) \ V / 
            //    | | |  _ <  / ___ \ |_| | |__| |___  | || |_| |  _ < | |  
            //    |_| |_| \_\/_/   \_\___/|_____\____| |_| \___/|_| \_\|_|  
                
            // Get the initial car position
            static double pos_X0 = 0.;     
            static double pos_Y0 = in->LatOffsLineL;
            static double yaw0 = in->LaneHeading;


            // Calculate the trajectory only at the beginning of the algorithm
            if(!traj){
               
                /* LINE */
                
                // G2lib::ClothoidCurve line;
                // G2lib::real_type x_1, y_1, theta_1;
                // std::vector<G2lib::real_type> vec_x_1, vec_y_1, vec_theta_1;
                // line.build_G1(0., 2., 0., 180., 2., 0.);
                // for(int i = 0; i <= (line.length() / DT); i++){
                //     G2lib::real_type s = i * 0.05;
                //     line.eval(s, x_1, y_1);
                //     theta_1 = line.theta(s);
                    
                //     vec_x_1.push_back(x_1);
                //     vec_y_1.push_back(y_1);
                //     vec_theta_1.push_back(theta_1);
                    
                //     logger.log_var(filename_path, "X0", vec_x_1[i]);
                //     logger.log_var(filename_path, "Y0", vec_y_1[i]);
                //     logger.log_var(filename_path, "THETA0", vec_theta_1[i]);
                //     logger.write_line(filename_path);
                // }

                //trajectory.push_back(line);

                /* TRAJECTORY MADE BY LINE SEGMENT */

                std::vector<G2lib::real_type> vec_x_0{0.0,3.50000000000000,4.49998800000000,5.49290000000000,6.49285500000000,7.47746900000000,8.47746800000000,9.47746500000000,10.4764290000000,10.6396480000000,11.6395080000000,12.6394880000000,13.6394860000000,14.5206210000000,15.5204770000000,16.5204050000000,17.0638500000000,18.0637810000000,19.0632020000000,20.0631600000000,21.0328470000000,22.0326990000000,23.0324710000000,24.0317990000000,25.0314070000000,26.0303650000000,27.0295060000000,28.0293360000000,29.0285060000000,29.2837350000000,30.2834310000000,31.2832180000000,32.2814460000000,33.2814160000000,34.2813700000000,35.2811700000000,36.2810110000000,37.2808400000000,38.2807040000000,39.2807040000000,40.2803830000000,41.2749290000000,42.2723340000000,43.2712210000000,44.2708930000000,45.2706100000000,45.7268850000000,46.7264070000000,47.7263830000000,48.7263710000000,49.7239290000000,50.7238820000000,51.7230590000000,52.7230200000000,53.7028340000000,54.7028230000000,55.7027440000000,56.7023900000000,57.7021840000000,58.7021570000000,59.7019050000000,60.7019050000000,61.7016600000000,62.7010680000000,63.6951360000000,64.6890670000000,65.6883240000000,66.6876100000000,67.6873280000000,68.6853180000000,69.6850970000000,70.6849510000000,71.6831420000000,72.6831290000000,73.6775310000000,74.6767880000000,75.6761570000000,76.6749130000000,77.6719630000000,78.6719340000000,79.6714640000000,80.6710600000000,81.6708460000000,82.6707240000000,83.6707230000000,84.6706430000000,85.6706370000000,86.6612010000000,87.6609840000000,88.6609460000000,89.6482460000000,90.6478960000000,91.6471910000000,92.6471910000000,93.6469940000000,94.6449000000000,94.8012130000000,95.6217130000000,96.6216730000000,97.6171830000000,98.6164370000000,99.6156810000000,100.615674000000,101.613433000000,102.612750000000,103.612284000000,104.611846000000,105.609540000000,106.609433000000,107.605144000000,108.604985000000,109.604981000000,110.604932000000,111.604792000000,112.604679000000,113.603357000000,114.601286000000,115.601183000000,116.600241000000,117.600239000000,118.009578000000,119.007595000000,120.006732000000,121.006661000000,122.005401000000,123.004838000000,124.002580000000,125.002303000000,126.002302000000,127.000775000000,128.000453000000,128.999180000000,129.999135000000,130.997926000000,131.925020000000,132.924809000000,133.924268000000,134.923677000000,135.923515000000,136.922873000000,137.922818000000,138.922627000000,139.922421000000,140.922399000000,141.921292000000,142.918388000000,143.918354000000,144.917905000000,145.917644000000,146.914524000000,147.913969000000,148.913914000000,149.880210000000,150.873065000000,151.871740000000,152.869309000000,153.859191000000,154.532150000000,155.467670000000,156.460931000000,157.458458000000,158.452398000000,159.374537000000,160.374461000000,161.051641000000,161.402930000000,162.394052000000,162.928471000000,163.876389000000,164.876232000000,165.871104000000,166.871051000000,167.868589000000,168.844533000000,169.709425000000,170.708416000000,171.675559000000,172.656738000000,173.634737000000,174.562620000000,175.482881000000,176.421263000000,177.421089000000,177.554351000000,178.553641000000,179.124684000000,179.859213000000};
                std::vector<G2lib::real_type> vec_y_0{0.0,0.0937500000000000,0.0887630000000000,0.207608000000000,0.217148000000000,0.391893000000000,0.390752000000000,0.388061000000000,0.433561000000000,1.42015100000000,1.43685600000000,1.44313000000000,1.44553300000000,1.91839700000000,1.93538900000000,1.92344100000000,2.76288600000000,2.75113500000000,2.71711700000000,2.70796300000000,2.95231300000000,2.96950500000000,2.94814000000000,2.91149800000000,2.88346700000000,2.92909000000000,2.88763100000000,2.86924500000000,2.82849700000000,1.86161700000000,1.88628000000000,1.86565100000000,1.92515600000000,1.91742400000000,1.92696800000000,1.94697300000000,1.92909900000000,1.94755500000000,1.96404700000000,1.96334400000000,1.93800700000000,2.04230500000000,1.97031600000000,1.92314000000000,1.94873700000000,1.97254900000000,2.86238800000000,2.83144900000000,2.82462900000000,2.81970000000000,2.74985300000000,2.75956000000000,2.71900300000000,2.72780300000000,2.52789000000000,2.53257300000000,2.54516300000000,2.51855700000000,2.49827000000000,2.49091000000000,2.46847000000000,2.46879400000000,2.49093800000000,2.45655900000000,2.34779900000000,2.23778700000000,2.19925200000000,2.16146300000000,2.13774600000000,2.07436400000000,2.05337400000000,2.07047400000000,2.01035100000000,2.01554800000000,1.90989200000000,1.87134200000000,1.90687200000000,1.95673300000000,1.87998300000000,1.87226700000000,1.84161400000000,1.87002300000000,1.84935700000000,1.86498400000000,1.86326100000000,1.85065200000000,1.85431800000000,1.71727100000000,1.69645600000000,1.70526900000000,1.86413300000000,1.83766900000000,1.80012600000000,1.80012300000000,1.78026700000000,1.71558900000000,0.727881000000000,0.156234000000000,0.165133000000000,0.259793000000000,0.298397000000000,0.337293000000000,0.340897000000000,0.407814000000000,0.444762000000000,0.475280000000000,0.504874000000000,0.572745000000000,0.558095000000000,0.650612000000000,0.632788000000000,0.629944000000000,0.620037000000000,0.636777000000000,0.651830000000000,0.703230000000000,0.767551000000000,0.753231000000000,0.796626000000000,0.794507000000000,1.70689000000000,1.76982900000000,1.81137700000000,1.79951100000000,1.84970600000000,1.81615200000000,1.74899100000000,1.77252900000000,1.77102400000000,1.82626800000000,1.80090200000000,1.85134700000000,1.86076500000000,1.81159900000000,1.43677100000000,1.45734100000000,1.49022100000000,1.52459900000000,1.50659300000000,1.54241100000000,1.55286200000000,1.57242900000000,1.59270400000000,1.59946100000000,1.55243900000000,1.47628000000000,1.46805300000000,1.49801500000000,1.47518100000000,1.55411800000000,1.58742200000000,1.59790100000000,1.85533500000000,1.97466700000000,2.02611400000000,2.09580700000000,1.95391700000000,1.21423700000000,0.860965000000000,0.976867000000000,1.04715600000000,1.15707600000000,1.54393500000000,1.53166100000000,0.795843000000000,1.73211000000000,1.86506400000000,1.01984400000000,1.33835800000000,1.32060400000000,1.21947200000000,1.20911000000000,1.27922800000000,1.49725200000000,1.99921000000000,2.04412200000000,1.78988900000000,1.98298900000000,2.19159700000000,1.81872500000000,2.21003100000000,2.55563100000000,2.57428000000000,1.58319900000000,1.62087200000000,0.799951000000000,0.121374000000000};
                
                // for(int i = 0; i < vec_x_0.size() - 1; i++){
                //     G2lib::LineSegment part_traj;
                //     part_traj.build_2P(vec_x_0[i], vec_y_0[i], vec_x_0[i + 1], vec_y_0[i + 1]);
                //     trajectory.push_back(part_traj);
                //     printLogVar(message_id, "X coordinate", vec_x_0[i]);
                //     printLogVar(message_id, "Y coordinate", vec_y_0[i]);
                // }

                for(int i = 0; i < vec_x_0.size() - 1; i++){
                    G2lib::ClothoidCurve part_traj;
                    part_traj.build_G1(vec_x_0[i], vec_y_0[i], 0., vec_x_0[i + 1], vec_y_0[i + 1], 0.);
                    trajectory.push_back(part_traj);
                }

                G2lib::real_type x_1, y_1;
                std::vector<G2lib::real_type> vec_x_1, vec_y_1; 
                for(int i = 0; i <= (trajectory.length() / DT); i++){
                    G2lib::real_type s = i * 0.05;
                    trajectory.eval(s, x_1, y_1);
                    
                    vec_x_1.push_back(x_1);
                    vec_y_1.push_back(y_1);
                    
                    logger.log_var(filename_path, "X path", vec_x_1[i]);
                    logger.log_var(filename_path, "Y path", vec_y_1[i]);
                    logger.write_line(filename_path);
                }

                traj = true;
            }
            
/* -------------------------------------------------------------------------------------------------------------- */

            //    ____    _    ____            ____   ___  ____ ___ _____ ___ ___  _   _ 
            //   / ___|  / \  |  _ \          |  _ \ / _ \/ ___|_ _|_   _|_ _/ _ \| \ | |
            //  | |     / _ \ | |_) |  _____  | |_) | | | \___ \| |  | |  | | | | |  \| |
            //  | |___ / ___ \|  _ <  |_____| |  __/| |_| |___) | |  | |  | | |_| | |\  |
            //   \____/_/   \_\_| \_\         |_|    \___/|____/___| |_| |___\___/|_| \_|
                                                                          
            
            static double pos0 = in->TrfLightDist;       // initial distance of the traffic-light      
            double LatPosL = in->LatOffsLineL;           // Relative lateral position from left line
            double LatPosR = in->LatOffsLineR;           // Relative lateral position from right line
            double yaw = in->LaneHeading;                // Attitude of the vehicle w.r.t straight road                
            double vehicle_X, vehicle_Y;                 // (X,Y) coordinate of the vehicle in the env

            // compute vehicle position
            vehicle_position(pos0, in->TrfLightDist, LatPosL, LatPosR, &vehicle_X, &vehicle_Y);
            /**
             * Position of the vehicle
             * X = distance from the start position of the car
             * Y = distance from the left line
             * YAW = Yaw angle from the horizontal axel
            */
                                                                  
/* -------------------------------------------------------------------------------------------------------------- */
            
            //   _        _  _____ _____ ____      _    _        ____ ___  _   _ _____ ____   ___  _     
            //  | |      / \|_   _| ____|  _ \    / \  | |      / ___/ _ \| \ | |_   _|  _ \ / _ \| |    
            //  | |     / _ \ | | |  _| | |_) |  / _ \ | |     | |  | | | |  \| | | | | |_) | | | | |    
            //  | |___ / ___ \| | | |___|  _ <  / ___ \| |___  | |__| |_| | |\  | | | |  _ <| |_| | |___ 
            //  |_____/_/   \_\_| |_____|_| \_\/_/   \_\_____|  \____\___/|_| \_| |_| |_| \_\\___/|_____|
                                                                                                      
            double K_US = 0;                                    // understeering gradient
            double req_steer_angle = 0;                               // Requested steering wheel angle
            double lookahead_lat = 15;                          // [m]
            double steer = in->SteerWhlAg;                      // Actual steering wheel angle
            
            // car position
            G2lib::real_type P0x = vehicle_X;                   // x coordinate of car
            G2lib::real_type P0y = vehicle_Y;                   // y coordinate of car
            G2lib::real_type P0theta = yaw;                     // yaw angle of the car

            logger.log_var(filename_traj, "X vehicle", P0x);
            logger.log_var(filename_traj, "Y vehicle", P0y);
            
            // Take a point from the reference trajectory
            G2lib::real_type P1x;                               // x coordinate of point trajectory
            G2lib::real_type P1y;                               // y coordinate of point trajectory
            G2lib::real_type P1theta;                           // Default
            G2lib::real_type variable_s, temp_1, temp_2;        

            // evaluate the closest point on the trajectory considering the actual position of the vehicle
            trajectory.closestPoint_ISO(P0x,P0y,P1x,P1y,variable_s,temp_1,temp_2);
           
            // calculate the lookahead point on the trajectory
            trajectory.eval(variable_s + lookahead_lat, P1x, P1y);
            P1theta = trajectory.theta(variable_s + lookahead_lat);

            G2lib::ClothoidCurve C1;                            // Clothoid
            // std::vector<G2lib::real_type> vec_x, vec_y;         // 
            // std::vector<G2lib::real_type> vec_theta, vec_kappa; // 
            // G2lib::real_type x, y, theta, kappa;

            // Build the clothoid
            C1.build_G1(P0x, P0y, P0theta, P1x, P1y, P1theta);
            double curvature = C1.kappaBegin();

            // Update output: requested steering angle
            req_steer_angle = curvature * (in->VehicleLen + K_US * pow(in->VLgtFild,2));

/* -------------------------------------------------------------------------------------------------------------- */

            //   _     ___  _   _  ____ ___ _____ _   _ ____ ___ _   _    _    _        ____ ___  _   _ _____ ____   ___  _     
            //  | |   / _ \| \ | |/ ___|_ _|_   _| | | |  _ \_ _| \ | |  / \  | |      / ___/ _ \| \ | |_   _|  _ \ / _ \| |    
            //  | |  | | | |  \| | |  _ | |  | | | | | | | | | ||  \| | / _ \ | |     | |  | | | |  \| | | | | |_) | | | | |    
            //  | |__| |_| | |\  | |_| || |  | | | |_| | |_| | || |\  |/ ___ \| |___  | |__| |_| | |\  | | | |  _ <| |_| | |___ 
            //  |_____\___/|_| \_|\____|___| |_|  \___/|____/___|_| \_/_/   \_\_____|  \____\___/|_| \_| |_| |_| \_\\___/|_____|
                                                                                                                             
            double v0 = in->VLgtFild;                  // actual longitudinal velocity
            double a0 = in->ALgtFild;                  // actual longitudinal acceleration
            double lookahead = std::max(50.0,v0*5.0);  // lookahead distance
            double v_min = 3.0;                        // vel min to pass the traffic light
            double v_max = 15.0;                       // vel max to pass the traffic light
            double x_s = 5.0;                          // safety space before traffic light
            double x_in = 10.0;                        // length of the intersection
            double v_r = in->RequestedCruisingSpeed;   // req cruising speed of the vehicle
            double T_s = x_s / v_min;                  // time to travel the safety space
            double T_in = x_in / v_min;                // time to safety space
            double x_tr = 0;                           // distance to the traffic light
            double x_stop = 0;                         // distance to the stop the vehicle
            double T_green = 0;                        // 
            double T_red = 0;                          // 
            double m_star[6], m1[6], m2[6];            // primitives
            double T1 = 0, T2 = 0, smax = 0, v1 = 0;   // usefull variable

            // Check if there is almost one Traffic light in the scenario
            if(in->NrTrfLights != 0){
                x_tr = in->TrfLightDist;
                x_stop = in->TrfLightDist - (x_s / 2.0);
            }

            if(in->NrTrfLights == 0 || x_tr >= lookahead){
                pass_primitive(a0,v0,lookahead,&v_r,&v_r,0.0,0.0,m1,m2,&T1,&T2);
                copy_m(m_star, m1);
            } else {
                switch (in->TrfLightCurrState) {
                    case 1:
                        T_green = 0.0;
                        T_red = in->TrfLightFirstTimeToChange - T_in;
                        break;
                    case 2:
                        T_green = in->TrfLightSecondTimeToChange + T_s;
                        T_red = in->TrfLightThirdTimeToChange - T_in;
                        break;
                    case 3:
                        T_green = in->TrfLightFirstTimeToChange + T_s;
                        T_red = in->TrfLightSecondTimeToChange - T_in;
                        break;
                    default:
                        break;
                }

                if(in->TrfLightCurrState == 1 && in->TrfLightDist <= x_s){
                    pass_primitive(a0,v0,lookahead,&v_r,&v_r,0.0,0.0,m1,m2,&T1,&T2);
                    copy_m(m_star, m1);
                } else {
                    pass_primitive(a0,v0,x_tr,&v_min,&v_max,T_green,T_red,m1,m2,&T1,&T2);
                    if(check_0(m1) == 0 && check_0(m2) == 0){
                        stop_primitive(v0,a0,x_stop,m_star,&T1,&smax);
                    } else {
                        if((m1[3] < 0 && m2[3] > 0) || (m1[3] > 0 && m2[3] < 0)){
                            pass_primitivej0(v0,a0,x_tr,v_min,v_max,m_star,&T1,&v1);
                        } else {
                            if(abs(m1[3]) < abs(m2[3])){
                                copy_m(m_star, m1);
                            } else {
                                copy_m(m_star, m2);
                            }
                        }
                    }
                }
            }

            // Integrated jerk - trapezoidal - with internal a0
            static double a0_bar = 0.0;
            double minAcc = -3;
            double maxAcc = 3;

            double j_req = (DT * (jEval(0.0,m_star) + jEval(DT,m_star)) * 0.5);
            double req_acc = a0_bar + j_req;

            a0_bar = req_acc;
            double v_req = v_requested(DT,m_star);

/* -------------------------------------------------------------------------------------------------------------- */

            //   _     _____        __    _     _______     _______ _           ____ ___  _   _ _____ ____   ___  _     
            //  | |   / _ \ \      / /   | |   | ____\ \   / / ____| |         / ___/ _ \| \ | |_   _|  _ \ / _ \| |    
            //  | |  | | | \ \ /\ / /____| |   |  _|  \ \ / /|  _| | |   _____| |  | | | |  \| | | | | |_) | | | | |    
            //  | |__| |_| |\ V  V /_____| |___| |___  \ V / | |___| |__|_____| |__| |_| | |\  | | | |  _ <| |_| | |___ 
            //  |_____\___/  \_/\_/      |_____|_____|  \_/  |_____|_____|     \____\___/|_| \_| |_| |_| \_\\___/|_____|
                                                                                                                     
            
            // PID longitudinal control
            static double integral_long = 0.0;
            double P_gain_long = 0.15;
            double I_gain_long = 1.0;
            double req_pedal;
            double error_long = req_acc - a0;
            integral_long = integral_long + (error_long * DT);
            req_pedal = (P_gain_long * error_long) + (I_gain_long * integral_long);

            // Reset the memory
            if(in->VLgtFild < 0.15 && a0_bar < 0.0 && j_req > 0.0){
               a0_bar = 0.0;
               integral_long = 0.0;
            }

            // PID longitudinal control
            static double integral_lat = 0.0;
            double P_gain_lat = 5.;
            double I_gain_lat = 1.;
            double req_steer;
            double error_lat = req_steer_angle - steer;
            integral_lat = integral_lat + (error_lat * DT);
            req_steer = (P_gain_lat * error_lat) + (I_gain_lat * integral_lat);

            // Update output: requested acceleration and requested steering angle
            out->RequestedAcc = req_pedal;
            out->RequestedSteerWhlAg = req_steer;


/* -------------------------------------------------------------------------------------------------------------- */

            //   ____ ___ ____  ____  _        _ __   __
            //  |  _ \_ _/ ___||  _ \| |      / \\ \ / /
            //  | | | | |\___ \| |_) | |     / _ \\ V / 
            //  | |_| | | ___) |  __/| |___ / ___ \| |  
            //  |____/___|____/|_|   |_____/_/   \_\_|  
                                                     
            // Log_vars
            logger.log_var(filename, "N Cycle", in->CycleNumber);
            logger.log_var(filename, "Time", num_seconds);
            logger.log_var(filename, "Vel_act", in->VLgtFild);
            logger.log_var(filename, "Acc_act", in->ALgtFild);
            logger.log_var(filename, "TrafficLight", in->TrfLightCurrState);
            logger.log_var(filename, "Vel_req", v_req);
            logger.log_var(filename, "Acc_req", req_pedal);
            logger.log_var(filename, "T_green", T_green);
            logger.log_var(filename, "T_red", T_red);
            logger.log_var(filename, "T1", T1);
            logger.log_var(filename, "T2", T2);
            logger.log_var(filename, "v_min", v_min);
            logger.log_var(filename, "v_max", v_max);
            logger.log_var(filename, "TrfLightDist",in->TrfLightDist);
            logger.log_var(filename, "c1", m_star[1]);
            logger.log_var(filename, "c2", m_star[2]);
            logger.log_var(filename, "c3", m_star[3]);
            logger.log_var(filename, "c4", m_star[4]);
            logger.log_var(filename, "c5", m_star[5]);

            // Write log
            logger.write_line(filename_traj);
            logger.write_line(filename);

            // Screen print
            printLogVar(message_id, "Status", in->Status);
            printLogVar(message_id, "CycleNumber", in->CycleNumber);
            printLogVar(message_id, "Time", num_seconds);
            printLogVar(message_id, "TrafficLight", in->TrfLightCurrState);
            printLogVar(message_id, "Actual velocity", in->VLgtFild);
            printLogVar(message_id, "Actual acceleration", in->ALgtFild);
            printLogVar(message_id, "Actual steering wheel", steer);
            printLogVar(message_id, "Vehicle X coordinate", vehicle_X);
            printLogVar(message_id, "Vehicle Y coordinate", vehicle_Y);
            printLogVar(message_id, "Vehicle Yaw coordinate", yaw);


            // Send manoeuvre message to the environment
            if (server_send_to_client(server_run, message_id, &manoeuvre_msg.data_struct) == -1) {
                perror("error send_message()");
                exit(EXIT_FAILURE);
            } else {
                printLogTitle(message_id, "sent message");
            }
        }
    }

    // Close the server of the agent
    server_agent_close();
    return 0;
}

//   ____ _____  _  _____ ___ ____   _____ _   _ _   _  ____ _____ ___ ___  _   _ 
//  / ___|_   _|/ \|_   _|_ _/ ___| |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | |
//  \___ \ | | / _ \ | |  | | |     | |_  | | | |  \| | |     | |  | | | | |  \| |
//   ___) || |/ ___ \| |  | | |___  |  _| | |_| | |\  | |___  | |  | | |_| | |\  |
//  |____/ |_/_/   \_\_| |___\____| |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|

static void copy_m(double m1[6], double m2[6]){
  for(int i = 0; i < 6; i++){
    m1[i] = m2[i];
  }
}

static int check_0(double m[6]){
  int tmp = 0;
  for(int i = 0; i < 6; i++){
    if(m[i] != 0) tmp += 1;
  }
  return tmp;
}

static double jEval(double t, double m[6]){
    double jerk = m[3] + m[4] * t + 1.0/2.0 * m[5] * pow(t,2);
    return jerk;
}

static double v_requested(double t, double m[6]){
    double vel = m[1] + m[2] * t + 1.0/2.0 * m[3] * pow(t,2) + 1.0/6.0 * m[4] * pow(t,3) + 1.0/24.0 * m[5] * pow(t,4);
    return vel;
}

static void vehicle_position(double x0, double x_act, double offL, double offR, double* X, double* Y){
    *X = x0 - x_act;
    *Y = offL;
}