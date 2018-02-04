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

%%%%%%% Multivarible system

A = [0,1,0;0,0,0;0,0,0];
B = [0,0; 0, k_1; k_2, 0];
C = [1,0,0;0,0,1];

Q = diag([50 10 200]);
R = diag([5 10]);

K = lqr(A, B, Q, R);

P = inv(C*inv(B*K-A)*B);

%%%%%% Integral effect
A_aug = [A, zeros(3,2); C, zeros(2,2)];
B_aug = [B; zeros(2,2)];

Q_aug = diag([50 10 200 10 30]);

K_aug = lqr(A_aug, B_aug, Q_aug, R);

A_aug_cl = A_aug - B_aug*K_aug;

poles = eig(A_aug_cl);


%%%%%% Observer

A_obs = [0 1 0 0 0 0;
         0 0 0 0 0 0;
         0 0 0 1 0 0;
         0 0 0 0 0 0;
         0 0 0 0 0 1;
       k_3 0 0 0 0 0];
   
B_obs = [0 0;
         0 k_1;
         0 0;
       k_2 0;
         0 0;
         0 0];
     
C_obs = [1 0 0 0 0 0;
         0 0 1 0 0 0;
         0 0 0 0 1 0];
     
C_obs_not_p = [0 0 1 0 0 0;
               0 0 0 0 1 0];
           
C_obs_not_lambda = [1 0 0 0 0 0;
                    0 0 1 0 0 0];
     
Ob = rank(obsv(A_obs, C_obs));
Ob_not_p = rank(obsv(A_obs, C_obs_not_p));
Ob_not_lambda = rank(obsv(A_obs, C_obs_not_lambda));

%Want observer poles x4-10 faster than system
%Slowest pole in A_aug_cl: -0.4434 -> slowest pole in observer (-1.7)-(-4.5)
convert = pi/180;
theta = 20*[1 -1 2 -2 3 -3]*convert;
Pol = -2*[exp(1i*theta(1)) exp(1i*theta(2)) exp(1i*theta(3)) exp(1i*theta(4)) exp(1i*theta(5)) exp(1i*theta(6))];
L = place(A_obs', C_obs_not_p', Pol')';

A_LC = A_obs-L*C_obs_not_p;
poles_A_LC = eig(A_LC);





