%% SIMBOLICO
syms s C1 C2 R L I1 I2 VI;

ZC1 = 1/(s*C1);
ZC2 = 1/(s*C2);
ZL = s*L;
ZR = R;



A = [ ZC1+ZL  -ZL ; -ZL ZL+ZR+ZC2];
B = [VI; 0];

Sol = A\B

G=Sol(2)*ZC2/VI;
pretty(G)

%% NUMERICO
clear all;
C1 = 10;
C2 = 20;
R = 100;
L = 15;
s = tf('s');

G = (C1*L*s^2)/(C2*R*s + C1*L*s^2 + C2*L*s^2 + C1*C2*L*R*s^3 + 1);
G = tf(zpk(G))

%

A = [ -1/(R*C1),     -1/(R*C1),      1/(C1); ...
      -1/(R*C2),    -1/(R*C2),      0; ...
      -1/L,     0,          0 ];
B = [1/(R*C1); 1/(R*C2); 1/L];

C = [0 1 0];

D = 0;

sys = ss(A, B, C ,D);

Gsys = minreal(tf(sys))



