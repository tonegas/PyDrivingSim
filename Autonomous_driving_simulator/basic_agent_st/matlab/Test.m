clear 
close all
clc

T = 100;
dt = 1;
time = 1:dt:T;
v0 = 10;
a0 = 1.5;
sf = 100;

[m_star, tf, smax] = stop_primitive(v0,a0,sf);

%[] = pass_primitive(a0,v0,sf,3,13,)

velocity = zeros(1,length(1:smax));
space = zeros(1,length(1:smax));

for i = 1:tf
    space(:,i) = m_star(2)*i + 1/2*m_star(3)*i^2 + 1/6 * m_star(4) * i^3 + 1/24 * m_star(5) * i^4 + 1/120 * m_star(6) * i^5;
    velocity(:,i) = m_star(2) + m_star(3)*i + 1/2 * m_star(4) * i^2 + 1/6 * m_star(5) * i^3 + 1/24 * m_star(6) * i^4;
end

%% Plot

figure, clf, hold on;
plot(1:smax, velocity);
