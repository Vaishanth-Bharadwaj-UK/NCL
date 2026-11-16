s = tf('s');
K = 0.01342; %System Gain

T = 0.083; %Time Constant
Tdead = 0.0222;

G = (K*exp(Tdead*(-1)*s))/((T*s) + 1);

 Kp = 1.89/K;
 Ki = 22.27/K;
 
 C = pid(Kp,Ki);
 
 L = G*C;
 
 figure;
 bode(G);
 margin(G);
 grid on;
 title("Open Loop Response");

 figure;
 bode(L);
 margin(L);
 grid on;
 title("Closed Loop Response (SIMC Tuning)");

 CL = feedback(L,1);

 figure;
 step(CL);
 grid on;
 title('Closed-Loop Step Response');

 stepinfo(CL);

%opts = pidtuneOptions('PhaseMargin',61.352);
%[C_pid, info_pid] = pidtune(G,"PID",opts)
%[C_pi, info_pi] = pidtune(G,"PI",opts);