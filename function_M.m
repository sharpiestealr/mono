function out1 = function_M(psi_)
%function_M
%    OUT1 = function_M(PSI_)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    11-Dec-2023 15:07:59

t2 = cos(psi_);
t3 = t2.*2.89645774592e-2;
out1 = reshape([1.3472e-2,1.3472e-2,0.0,0.0,1.3472e-2,t2.*5.79291549184e-2+t2.^2.*1.01989758972032e-1+1.00721255e-1,0.0,0.0,0.0,0.0,1.1129255e-2,t3,0.0,0.0,t3,1.43889758972032e-1],[4,4]);
end
