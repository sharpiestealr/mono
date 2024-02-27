function qpp = fcn(x,u)

M = function_M(x(4));
V = function_V(x(6),x(4),x(8),x(5),x(7));
G = function_G(x(2),x(4));
P = function_P();

qpp = M^-1*(-V-G+P*u);