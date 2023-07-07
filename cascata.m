%% setup
Gr_tf=minreal(tf(Gr));

tf_tpr = Gr_tf(1,1); tf_phi = Gr_tf(2,1);
tf_tpw = Gr_tf(4,2); tf_psi = Gr_tf(5,2);

%% roll
roll=tf_tpr^(-1)*tf_phi;
roll=minreal(tf(zpk(roll)));
GpssObs = canon(roll,'companion');
GpssObsA = GpssObs.A;
GpssObsB = GpssObs.B;
GpssObsC = GpssObs.C;
GpssObsD = GpssObs.D;
a = GpssObsA.';
b = GpssObsC.';
c = GpssObsB.';
d = GpssObsD;

isctrlroll=false;
ctrl_roll=rank(ctrb(a,b));
if (ctrl_roll==2) isctrlroll=true; end

%% pitch
pitch=tf_tpw^(-1)*tf_psi;
pitch=minreal(tf(zpk(pitch)));
GpssObs = canon(pitch,'companion');
GpssObsA = GpssObs.A;
GpssObsB = GpssObs.B;
GpssObsC = GpssObs.C;
GpssObsD = GpssObs.D;
a = GpssObsA.';
b = GpssObsC.';
c = GpssObsB.';
d = GpssObsD;

isctrlpitch=false;
ctrl_pitch=rank(ctrb(a,b));
if (ctrl_pitch==2) isctrlpitch=true; end

%% check
isctrlroll;
isctrlpitch;

%% ctrl roll
tau = 1/30;
syms kp_s kd_s ki_s real
div = 1-0.05169*kd_s;
wn = sqrt((20.82+0.5169*ki_s)/div)
zeta = ((0.05169*kp_s)/div)/(2*wn)