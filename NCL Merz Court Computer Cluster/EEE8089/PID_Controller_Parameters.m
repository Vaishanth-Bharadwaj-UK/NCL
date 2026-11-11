s = tf('s');
K = 0.01342; %System Gain

T = 0.083; %Time Constant
Tdead = 0.0078;

G = (K*exp(Tdead*(-1)*s))/((T*s) + 1);

Kp = 5.32/K;
Ki = 85.26/K;

C = pid(Kp,Ki);

L = G*C;

figure;
bode(L);
margin(L);
grid on;
title("Closed Loop Response");