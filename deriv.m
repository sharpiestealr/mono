function fout = deriv(f, g)
clear t qx dqx
% deriv differentiates f with respect to g=g(t)
% the variable g=g(t) is a function of time
syms t qx dqx
lg = {diff(g, t), g};
lx = {dqx, qx};
f1 = subs(f, lg, lx);
f2 = diff(f1, qx);
fout = subs(f2, lx, lg);