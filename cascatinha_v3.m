% doing the cascade but MODERN
% thoroughly modern millie style
%% setup
%clear all; clc

s = tf('s');

%% using tfs from modelo_carlitos_altered.mlx - novaes approach
tr = system.G_Td_Pr;
tpr = system.G_Tdd_Pr;

phi = system.G_Phi_Pr;
phip = system.G_Phid_Pr;

tw = system.G_Tw_Pr;
tpw = system.G_Twd_Pw;

psi = system.G_Psi_Pw;
psip = system.G_Psid_Pw;

matriz = [tpr,0;
         phi,0;
         phip,0;
         0,tpw;
         0,psi;
         0,psip]

%% state space time

%%% tpr
%%%% 1 thetappp + 41.73 thetapp - 21.96 thetap - 868.9 theta = 529.6 pwmrpp
%%%% - 1103 pwmr
tprA = [0        1      0;...
        0        0      1;...
        41.73 -21.96 -868.9];
tprB = [0;       0;    1103];
tprC = eye(3);
tprD = zeros(3);

%%% phi
phiA = tprA;
phiB = [0; 0; -27.38];
phiC = tprC;
phiD = tprD;

%%% phip
phipA = tprA;
phipB = phiB;
phipC = phiC;
phipD = phiD;

%%% tpw
%%%% 1 thetappp + 44.91 thetapp - 58.36 thetap - 1039 theta = 333.2 pwmwpp
%%%% - 9257 owmw
tpwA = [0        1     0;...
        0        0     1;...
        44.91 -58.36 1039];
tpwB = [0;       0;  9257];
tpwC = tprC;
tpwD = tprD;

%%% psi
psiA = tpwA;
psiB = [0; 0; -67.07];
psiC = tpwC;
psiD = tpwD;

%%% psid
psipA = tpwA;
psipB = psiB;
psipC = psiC;
psipD = psiD;

%% now we acker
poles = [-10 -5+5i -5-5i];

tprK = acker(tprA,tprB,poles);
tprKi = tprK(1);
tprKt = tprK(2);
tprKd = tprK(3);

phiK = acker(phiA,phiB,poles);
phiKi = phiK(1);
phiKt = phiK(2);
phiKd = phiK(3);

phipK = acker(phipA,phipB,poles);
phipKi = phipK(1);
phipKt = phipK(2);
phipKd = phipK(3);

tpwK = acker(tpwA,tpwB,poles);
tpwKi = tpwK(1);
tpwKt = tpwK(2);
tpwKd = tpwK(3);

psiK = acker(psiA,psiB,poles);
psiKi = psi(1);
psiKt = psiK(2);
psiKd = psiK(3);

psipK = acker(psipA,psipB,poles);
psipKi = psipK(1);
psipKt = psipK(2);
psipKd = psipK(3);

%% pid time baybee

tprPID = tprKi/s + tprKt + tprKd*s;
phiPID = phiKi/s + phiKt + phiKd*s;
phipPID = phipKi/s + phipKt + phipKd*s;

tpwPID = tpwKi/s + tpwKt + tpwKd*s;
psiPID = psiKi/s + psiKt + psiKd*s;
psipPID = psipKi/s + psipKt + psipKd*s;