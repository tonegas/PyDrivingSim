clc
clear
close all

%% Load data
data = readtable("Long_param.csv");
path = readtable("Path.csv");
traj = readtable("Trajectory.csv");


%% Path plot

X0 = table2array(path(:,1));
Y0 = table2array(path(:,2));
X1 = table2array(traj(:,1));
Y1 = table2array(traj(:,2));

figure, clf, hold on;
axis equal
plot(X0,Y0)
plot(X1,Y1)
xlabel 'x [m]'
ylabel 'y [m]'
title 'Reference vs Actual trajectory'
legend('Reference trajectory','Actual trajectory')

%% Read data

time = table2array(data(:,2));
vel_act = table2array(data(:,3));
acc_act = table2array(data(:,4));
phase = table2array(data(:,5));
vel_req = table2array(data(:,6));

acc_req = table2array(data(:,7));
t_green = table2array(data(:,8));
t_red = table2array(data(:,9));
t1 = table2array(data(:,10));
t2 = table2array(data(:,11));
v_min = table2array(data(:,12));
v_max = table2array(data(:,13));
TrfLightDist = table2array(data(1,14)) - table2array(data(:,14));
c1 = table2array(data(:,15));
c2 = table2array(data(:,16));
c3 = table2array(data(:,17));
c4 = table2array(data(:,18));
c5 = table2array(data(:,19));

%% Plot: velocity & acceleration

% Time domain
figure
tiledlayout(4,4)
nexttile([2 2])
hold on
plot(time, vel_act)
plot(time, vel_req)
plot(time, v_min)
plot(time, v_max)
plot(time, phase, 'r')
xlabel 'time (s)'
ylabel 'velocity (km/h)'
title 'Velocity profile vs time'
legend('velocity act','velocity req','TrafficLight')
nexttile([2 2])
hold on
plot(time, acc_act)
plot(time, acc_req)
plot(time, phase, 'r')
xlabel 'time (s)'
ylabel 'acceleration (m/s^2)'
title 'Acceleration profile vs time'
legend('acceleration act','acceleration req','TrafficLight')

% Space domain
nexttile([2 2])
hold on
plot(TrfLightDist, vel_act)
plot(TrfLightDist, vel_req)
plot(TrfLightDist, v_min)
plot(TrfLightDist, v_max)
plot(TrfLightDist, phase, 'r')
xline(162,'--r',{'Traffic Light'})
xlabel 'Distance (m)'
ylabel 'velocity (km/h)'
title 'Velocity profile vs distance'
legend('velocity act','velocity req','TrafficLight')
nexttile([2 2])
hold on
plot(TrfLightDist, acc_act)
plot(TrfLightDist, acc_req)
plot(TrfLightDist, phase, 'r')
xline(162,'--r',{'Traffic Light'})
xlabel 'Distance (m)'
ylabel 'acceleration (m/s^2)'
title 'Acceleration profile vs distance'
legend('acceleration act','acceleration req','TrafficLight')

%% Plot: time

figure
%tiledlayout(4,4)
%nexttile([2 2])
hold on
plot(TrfLightDist, t_green)
plot(TrfLightDist, t_red)
plot(TrfLightDist, phase, 'r')
xline(162,'--r',{'Traffic Light'})
xlabel 'Distance (m)'
ylabel 'time (s)'
title 'TIme vs space'
legend('T green','T red','TrafficLight')















