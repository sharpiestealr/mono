d = 7850; % densidade do material kg/m^3:
          % aço 4340 = 7850, latão naval = 8410
re = 0.129; % raio externo [m]
ri = re - 10e-3; % raio interno [m]
rc = 5e-3; % raio do círculo de dentro [m]
h = 3e-3; % espessura da placa [m]
t = 5e-3; % espessura dos raios [m]

v = pi*(re^2-ri^2)*h;
m1 = d*v;

v = ri*h*t;
m2 = d*v;

v = pi*rc*h;
m3 = d*v;

moi = 0.5*m1*(re^2-ri^2) + 3*(m2*ri^2/3) + 0.5*m3*rc^2 % 4x bigger
      % 0.0001347355 - nx