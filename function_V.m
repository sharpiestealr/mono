function out1 = function_V(phi_d,psi_,psi_d,thetar_d,thetaw_d)
%function_V
%    OUT1 = function_V(PHI_D,PSI_,PSI_D,THETAR_D,THETAW_D)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    11-Dec-2023 15:07:59

t2 = sin(psi_);
t3 = phi_d.^2;
t4 = psi_.*2.0;
t6 = thetar_d.*6.330668163944997e-1;
t7 = psi_d.*1.980840051306861e-1;
t8 = thetaw_d.*2.980840051306861e-1;
t5 = sin(t4);
out1 = [t6;-t6-phi_d.*psi_d.*t2.*5.79291549184e-2-phi_d.*psi_d.*t5.*1.01989758972032e-1;-t7+t8-psi_d.^2.*t2.*2.89645774592e-2;t7-t8+t2.*t3.*2.89645774592e-2+t3.*t5.*5.0994879486016e-2];
end
