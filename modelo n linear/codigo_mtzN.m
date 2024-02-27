function N = codigo_mtzN(t,Ke_d,Ke_w,Kt_d,Kt_w,L,Mb,Mr,R_d,R_w,Rw,d,n_d,n_w,phi_d,psi_,psi_d,thetad_d,thetaw_d)
%codigo_mtzN
%    N = codigo_mtzN(T,Ke_d,Ke_w,Kt_d,Kt_w,L,Mb,Mr,R_d,R_w,Rw,D,N_D,N_W,PHI_D,PSI_,PSI_D,THETAD_D,THETAW_D)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    11-Aug-2023 19:43:10

t2 = sin(psi_);
t3 = L.^2;
t4 = d.^2;
t5 = n_d.^2;
t6 = n_w.^2;
t7 = phi_d.^2;
t8 = psi_.*2.0;
t9 = psi_d.^2;
t11 = 1.0./R_d;
t12 = 1.0./R_w;
t10 = sin(t8);
t13 = Ke_w.*Kt_w.*n_w.*psi_d.*t12;
t14 = Ke_d.*Kt_d.*t5.*t11.*thetad_d;
t15 = Ke_w.*Kt_w.*t6.*t12.*thetaw_d;
N = [t14;-t14-Mb.*phi_d.*psi_d.*t3.*t10-Mr.*phi_d.*psi_d.*t3.*t10-Mr.*phi_d.*psi_d.*t4.*t10-L.*Mb.*Rw.*phi_d.*psi_d.*t2.*2.0-L.*Mr.*Rw.*phi_d.*psi_d.*t2.*2.0-L.*Mr.*d.*phi_d.*psi_d.*t10.*2.0-Mr.*Rw.*d.*phi_d.*psi_d.*t2.*2.0;-t13+t15-L.*Mb.*Rw.*t2.*t9-L.*Mr.*Rw.*t2.*t9-Mr.*Rw.*d.*t2.*t9;t13-t15+(Mb.*t3.*t7.*t10)./2.0+(Mr.*t3.*t7.*t10)./2.0+(Mr.*t4.*t7.*t10)./2.0+L.*Mb.*Rw.*t2.*t7+L.*Mr.*Rw.*t2.*t7+L.*Mr.*d.*t7.*t10+Mr.*Rw.*d.*t2.*t7];
end
