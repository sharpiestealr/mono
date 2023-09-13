%% setup
%clear all; clc

s = tf('s');

%% using tfs from modelo_carlitos_altered.mlx - novaes approach
pwmr_tr=-(192*(874201199812819007337421340672*s^2 - 18205122848505604556609342321071))/(s*(- 316912650057057350374175801344*s^3 - 13223242347360487239310626521088*s^2 + 6959380772886439520039690305536*s + 275372250050450334591067953921219));
pwmr_trp=-(192*(874201199812819007337421340672*s^2 - 18205122848505604556609342321071))/(- 316912650057057350374175801344*s^3 - 13223242347360487239310626521088*s^2 + 6959380772886439520039690305536*s + 275372250050450334591067953921219);
pwmr_phi=(32*(271114892551252557355840176128*s + 1385451354099195))/(- 316912650057057350374175801344*s^3 - 13223242347360487239310626521088*s^2 + 6959380772886439520039690305536*s + 275372250050450334591067953921219);
pwmr_phip=(32*s*(271114892551252557355840176128*s + 1385451354099195))/(- 316912650057057350374175801344*s^3 - 13223242347360487239310626521088*s^2 + 6959380772886439520039690305536*s + 275372250050450334591067953921219);
pwmw_tw=(4*(- 3299548357467755518178644459520*s^2 + 1481813165475937*s + 91676819232077530400128296809960))/(s*(- 39614081257132168796771975168*s^3 - 1778992559850625591990877683712*s^2 + 2311774460694557101810278989824*s + 41146109432590922895027409222719));
pwmw_twp=(4*(- 3299548357467755518178644459520*s^2 + 1481813165475937*s + 91676819232077530400128296809960))/(- 39614081257132168796771975168*s^3 - 1778992559850625591990877683712*s^2 + 2311774460694557101810278989824*s + 41146109432590922895027409222719);
pwmw_psi=(196*(13554881644059779096733810688*s + 30241085009713))/(- 39614081257132168796771975168*s^3 - 1778992559850625591990877683712*s^2 + 2311774460694557101810278989824*s + 41146109432590922895027409222719);
pwmw_psip=(196*s*(13554881644059779096733810688*s + 30241085009713))/(- 39614081257132168796771975168*s^3 - 1778992559850625591990877683712*s^2 + 2311774460694557101810278989824*s + 41146109432590922895027409222719);

syst = stack(1,pwmr_tr,pwmr_trp,pwmr_phi,pwmr_phip,pwmw_tw,pwmw_twp,pwmw_psi,pwmw_psip);

%% rlocus time
rlocus(pwmr_tr);
rlocus(pwmr_trp);
rlocus(pwmr_phi);
rlocus(pwmr_phip);
rlocus(pwmw_tw);
rlocus(pwmw_twp);
rlocus(pwmw_psi);
rlocus(pwmw_psip);

%% do the gambs
pwmr_tr=tf(zpk(pwmr_tr));
pwmr_trp=tf(zpk(pwmr_trp));
pwmr_phi=tf(zpk(pwmr_phi));
pwmr_phip=tf(zpk(pwmr_phip));
pwmw_tw=tf(zpk(pwmw_tw));
pwmw_twp=tf(zpk(pwmw_twp));
pwmw_psi=tf(zpk(pwmw_psi));
pwmw_psip=tf(zpk(pwmw_psip));

%% factor the velocity ones

pwmw = [1 44.91 -58.36 -1039];
pwmr = [1 41.73 -21.96 -868.9];

a = roots(pwmr);
b = roots(pwmw);

poly_r = (s-a(3))*(s-a(2));
poly_w = (s-b(3))*(s-b(2));

Gr = 1/poly_r
Gw = 1/poly_w

syms Kr Kw real

%% roda de inércia

wnr = sqrt(20.81+Kr);
zetar = 0.02758/(2*wnr) == .547;

ganho_r = simplify(solve(zetar,Kr))

%% roda no chão

wnw = sqrt(22.74+Kw);
zetaw = 0.7796/(2*wnw) == .636;

ganho_w = simplify(solve(zetaw,Kw))

%% tunado - roda de inércia

step(feedback(Cr*Gr_tuned,1))

%% tunado - roda no chão

step(feedback(Cw*Gw_tuned,1))