% FOR HELICOPTER NR 3-10
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert h�sten 2006 av Jostein Bakkeheim
% Oppdatert h�sten 2008 av Arnfinn Aas Eielsen
% Oppdatert h�sten 2009 av Jonathan Ronen
% Updated fall 2010, Dominik Breu
% Updated fall 2013, Mark Haring
% Updated spring 2015, Mark Haring


%%%%%%%%%%% Calibration of the encoder and the hardware for the specific
%%%%%%%%%%% helicopter
Joystick_gain_x = 1;
Joystick_gain_y = -1;


%%%%%%%%%%% Physical constants
g = 9.81; % gravitational constant [m/s^2]
l_c = 0.46; % distance elevation axis to counterweight [m]
l_h = 0.66; % distance elevation axis to helicopter head [m]
l_p = 0.175; % distance pitch axis to motor [m]
m_c = 1.92; % Counterweight mass [kg]
m_p = 0.72; % Motor mass [kg]

v_s_star = 6.95; %Equilibrium voltage for elevation
k_f = g*(2*m_p*l_h-m_c*l_c)/(v_s_star*l_h); % Motorforce constant

k_1 = k_f/(2*m_p*l_p);
k_2 = (k_f*l_h)/(m_c*(l_c^2) + 2*m_p*(l_h^2));
k_3 = g*(m_c*l_c - 2*m_p*l_h)/(m_c*(l_c^2) + 2*m_p*((l_h^2) + (l_p^2)));

%%%%%%%%%%% Pitch controller
k_pp = 1/k_1; %exact value for k_pp, used in pitch regulator
k_pd = 0.9/k_1; %Best response we found

%%%%%%%%%%% Travel rate controller
k_rp = 0.5/k_3;

