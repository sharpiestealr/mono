%% Modelo monociclo simbolico
clear all; close all; clc;

%% Definicao das variaveis
% Definição de variaveis
syms Rr Rw L d Mw Mb Mr;
syms Jw Jr Jbr Jbw;
syms thetar(t) phi(t) thetaw(t) psi(t) g t;

phi_p = diff(phi);
phi_pp = diff(phi_p);
psi_p = diff(psi);
psi_pp = diff(psi_p);
thetaw_p = diff(thetaw);
thetaw_pp = diff(thetaw_p);
thetar_p = diff(thetar);
thetar_pp = diff(thetar_p);

%% Energia
% vetores posição
p1 = [Rw*thetaw  Rw*sin(phi) Rw*cos(phi)];
p2 = [Rw*thetaw+L*sin(psi) Rw*sin(phi)+L*cos(psi)*sin(phi)...
    Rw*cos(phi)+L*cos(psi)*cos(phi)];
p3 = [Rw*thetaw+(L+d)*sin(psi) Rw*sin(phi)+(L+d)*cos(psi)*sin(phi)...
    Rw*cos(phi)+(L+d)*cos(psi)*cos(phi)];

% velocidade translacao
v1 = diff(p1);
v2 = diff(p2);
v3 = diff(p3);

% Energia translacao
Et = 1/2*v1*Mw*v1.'+1/2*v2*Mb*v2.'+1/2*v3*Mr*v3.';

% Energia rotacao
Er=1/2*Jw*thetaw_p^2+1/2*Jbr*psi_p^2+1/2*Jr*(thetar_p+phi_p)^2+...
    1/2*Jbw*phi_p^2;

% Energia potencial
U=Mw*g*Rw*cos(phi)+Mb*g*(Rw*cos(phi)+L*cos(phi)*cos(psi))+...
    Mr*g*(Rw*cos(phi)+(L+d)*cos(phi)*cos(psi));

%% Equacao de Lagrange
Lagr = Et+Er-U;

% dL\d(thetar_d)              
Lpthetar = deriv(Lagr, thetar_p);
% d(dL\d(thetar_d))\dt        
Ltthetar = diff(Lpthetar, t);
% dL\dthetar               
Lthetar = deriv(Lagr, thetar);
% 
Lthetard = simplify(expand(Ltthetar - Lthetar));

% dL\d(phi_d)              
Lpphi = deriv(Lagr, phi_p);
% d(dL\d(phi_d))\dt        
Ltphi = diff(Lpphi, t);
% dL\dphi               
Lphi = deriv(Lagr, phi);
% 
Lphid = simplify(expand(Ltphi - Lphi));

% dL\d(thetaw_d)              
Lpthetaw = deriv(Lagr, thetaw_p);
% d(dL\d(thetaw_d))\dt        
Ltthetaw = diff(Lpthetaw, t);
% dL\dthetaw               
Lthetaw = deriv(Lagr, thetaw);
% 
Lthetawd = simplify(expand(Ltthetaw - Lthetaw));

% dL\d(psi_d)              
Lppsi = deriv(Lagr, psi_p);
% d(dL\d(psi_d))\dt        
Ltpsi = diff(Lppsi, t);
% dL\dpsi               
Lpsi = deriv(Lagr, psi);
% 
Lpsid = simplify(expand(Ltpsi - Lpsi));

% Substituição de variaveis
syms phi_ phi_d phi_dd psi_ psi_d psi_dd thetaw_ thetaw_d thetaw_dd thetar_ thetar_d thetar_dd

Lphid_ = subs(Lphid,phi_pp,phi_dd);
Lphid_ = subs(Lphid_,phi_p,phi_d);
Lphid_ = subs(Lphid_,phi,phi_);
Lphid_ = subs(Lphid_,psi_pp,psi_dd);
Lphid_ = subs(Lphid_,psi_p,psi_d);
Lphid_ = subs(Lphid_,psi,psi_);
Lphid_ = subs(Lphid_,thetaw_pp,thetaw_dd);
Lphid_ = subs(Lphid_,thetaw_p,thetaw_d);
Lphid_ = subs(Lphid_,thetaw,thetaw_);
Lphid_ = subs(Lphid_,thetar_pp,thetar_dd);
Lphid_ = subs(Lphid_,thetar_p,thetar_d);
Lphid_ = subs(Lphid_,thetar,thetar_);

Lpsid_ = subs(Lpsid,phi_pp,phi_dd);
Lpsid_ = subs(Lpsid_,phi_p,phi_d);
Lpsid_ = subs(Lpsid_,phi,phi_);
Lpsid_ = subs(Lpsid_,psi_pp,psi_dd);
Lpsid_ = subs(Lpsid_,psi_p,psi_d);
Lpsid_ = subs(Lpsid_,psi,psi_);
Lpsid_ = subs(Lpsid_,thetaw_pp,thetaw_dd);
Lpsid_ = subs(Lpsid_,thetaw_p,thetaw_d);
Lpsid_ = subs(Lpsid_,thetaw,thetaw_);
Lpsid_ = subs(Lpsid_,thetar_pp,thetar_dd);
Lpsid_ = subs(Lpsid_,thetar_p,thetar_d);
Lpsid_ = subs(Lpsid_,thetar,thetar_);

Lthetawd_ = subs(Lthetawd,phi_pp,phi_dd);
Lthetawd_ = subs(Lthetawd_,phi_p,phi_d);
Lthetawd_ = subs(Lthetawd_,phi,phi_);
Lthetawd_ = subs(Lthetawd_,psi_pp,psi_dd);
Lthetawd_ = subs(Lthetawd_,psi_p,psi_d);
Lthetawd_ = subs(Lthetawd_,psi,psi_);
Lthetawd_ = subs(Lthetawd_,thetaw_pp,thetaw_dd);
Lthetawd_ = subs(Lthetawd_,thetaw_p,thetaw_d);
Lthetawd_ = subs(Lthetawd_,thetaw,thetaw_);
Lthetawd_ = subs(Lthetawd_,thetar_pp,thetar_dd);
Lthetawd_ = subs(Lthetawd_,thetar_p,thetar_d);
Lthetawd_ = subs(Lthetawd_,thetar,thetar_);

Lthetard_ = subs(Lthetard,phi_pp,phi_dd);
Lthetard_ = subs(Lthetard_,phi_p,phi_d);
Lthetard_ = subs(Lthetard_,phi,phi_);
Lthetard_ = subs(Lthetard_,psi_pp,psi_dd);
Lthetard_ = subs(Lthetard_,psi_p,psi_d);
Lthetard_ = subs(Lthetard_,psi,psi_);
Lthetard_ = subs(Lthetard_,thetaw_pp,thetaw_dd);
Lthetard_ = subs(Lthetard_,thetaw_p,thetaw_d);
Lthetard_ = subs(Lthetard_,thetaw,thetaw_);
Lthetard_ = subs(Lthetard_,thetar_pp,thetar_dd);
Lthetard_ = subs(Lthetard_,thetar_p,thetar_d);
Lthetard_ = subs(Lthetard_,thetar,thetar_);

% Entrada
syms Kt_r Ke_r R_r PWMr;
syms Kt_w Ke_w R_w PWMw;
syms Bw Br
talw=Kt_w/R_w*(12*PWMw-Ke_w*(thetaw_d-psi_d));
talr=Kt_r/R_r*(12*PWMr-Ke_r*(thetar_d));

% Resolver as equações
s1=simplify(expand(Lthetard_-talr+Br*thetar_d));
s2=simplify(expand(Lphid_+talr-Br*thetar_d));
s3=simplify(expand(Lthetawd_-talw+Bw*thetaw_d));
s4=simplify(expand(Lpsid_+talw-Bw*thetaw_d));

%Vetor de estados
q_dd=[thetar_dd; phi_dd; thetaw_dd; psi_dd];
q_d=[thetar_d; phi_d; thetaw_d; psi_d];
q=[thetar_; phi_; thetaw_; psi_];
x = [q;q_d];

%Entrada
u = [PWMr;PWMw];

% Modelo não linear na forma M(q)q_pp+V(q,q_p)+G(q)=P(q)u
M=simplify(expand(jacobian([s1; s2; s3; s4],q_dd)));
G=simplify(expand(jacobian([s1; s2; s3; s4],g)*g));
P=simplify(expand(-jacobian([s1; s2; s3; s4],u)));
V=simplify(expand([s1; s2; s3; s4]-M*q_dd-G+P*u));

% parametros
%Rd=0.20; Rw=0.071000; L=0.19406; d=(0.33660-L); Mw=0.30220; Mb=1.27712; Mr=0.47568;
%Jw=0.000770; Jr=0.013472; Jbr=0.04190; Jbw=0.07689;
%Kt_r=(958.2*0.00706155183333)/(20); Ke_r=(12-0.53*0.6)/(118*2*pi/60); R_r=0.6;
%Kt_w=(250*0.00706155183333)/(5);   Ke_w=(12-0.3*2.4)/(80*2*pi/60);   R_w=2.4;
%Br=0.1; Bw=0.1; g=9.81;
numvars;

M=subs(M);
V=subs(V);
P=subs(P);
G=subs(G);

matlabFunction(M(0),'File','function_M','Vars',{psi_});
matlabFunction(V(0),'File','function_V','Vars',{phi_d, psi_, psi_d, thetar_d, thetaw_d});
matlabFunction(G(0),'File','function_G','Vars',{phi_, psi_});
matlabFunction(P(0),'File','function_P');

xpp = M^-1*(P*u-V-G);
xp = [q_d; xpp];

%% Modelo linear
% Linearização
As=jacobian(xp,x);
Bs=jacobian(xp,u);

phi_=0; phi_d=0; phi_dd=0;
thetar_=0; thetar_d=0; thetar_dd=0;
psi_=0; psi_d=0; psi_dd=0;
thetaw_=0; thetaw_d=0; thetaw_dd=0;
PWMr=0; PWMw=0;

A = double(subs(As));
B = double(subs(Bs));
C = eye(8);

% consertando a ordem dos estados
%T = [1 0 0 0 0 0 0 0;
%     0 0 1 0 0 0 0 0;
%     0 0 0 0 1 0 0 0;
%     0 0 0 0 0 0 1 0;
%     0 1 0 0 0 0 0 0;
%     0 0 0 1 0 0 0 0;
%     0 0 0 0 0 1 0 0;
%     0 0 0 0 0 0 0 1];
%A = T\A*T;
%B = T\B;

% Remocao dos estados da posicao das rodas de recao e do chao
% Remoção do estado não controlado (posição do disco)
% Ar=A(2:end,2:end);
% Br=B(2:end,:);
% Cr=C(2:end,2:end);
Ar=A(2:end,2:end);
Br=B(2:end,:);

% Remoção do estado não controlado (posição da roda)
% Ard=[Ar(1:3,1:3) Ar(1:3,5:end);
%      Ar(5:end,1:3) Ar(5:end,5:end)];
% Brd=[Br(1:3,:);
%      Br(5:end,:)];
% Crd=[Cr(1,1) Cr(1,3:end);
%      Cr(3:end,1) Cr(3:end,3:end)];
Ard=[Ar(1,1) Ar(1,3:end);
     Ar(3:end,1) Ar(3:end,3:end)];
Brd=[Br(1,:);
     Br(3:end,:)];

%% Projeto controle LQR
% Regra de Bryson
Rot_m=118*2*pi/60;
ang_max=15*pi/180;

Qc=[1/ang_max^2           0         0  0          0 0;
              0 1/ang_max^2         0  0          0 0;
              0           0 1/Rot_m^2  0          0 0;
              0           0         0 20          0 0;
              0           0         0  0  1/Rot_m^2 0;
              0           0         0  0          0 1];
  
Rc=1*[1 0;
      0 1];
  
K=lqr(Ard,Brd,Qc,Rc);

%% Simulacao
v_ic = [0; 0; 0; 0];
x_ic = [0; 5*pi/180; 0; -5*pi/180]*1;

%% separacao ft para cascata
C = [1 0 0 0 0 0;...
     0 1 0 0 0 0;...
     0 0 1 0 0 0;...
     0 0 0 0 1 0];
G = tf(ss(Ard,Brd,C,zeros(4,2)));
    
% roll
G_roll_v1 = G(1,1);
G_thetap_v1 = minreal(G(3,1));
G_roll_thetap = minreal(G_roll_v1/G_thetap_v1); 

% pitch
G_pitch_v2 = G(2,2);
G_thetap_v2 = minreal(G(4,2));
G_pitch_thetap = minreal(G_pitch_v2/G_thetap_v2);

%% declaring pid backups

pidtop = [20 25 5 100];
ktop = 0.01;
pidbottom = [10 20 15 100];
kbottom = 0.35;