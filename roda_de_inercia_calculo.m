d = 7850; % densidade do material, 8410 latão
re = 0.128; % raio externo
ri = re - 10e-3; % raio interno
rc = 5e-3; % raio do círculo de dentro
h = 3e-3; % espessura da placa
t = 5e-3; % espessura dos raios

v = pi*(re^2-ri^2)*h;
m1 = d*v;

v = ri*h*t;
m2 = d*v;

v = pi*rc*h;
m3 = d*v;

moi = 0.5*m1*(re^2-ri^2) + 3*(m2*ri^2/3) + 0.5*m3*rc^2 % 20x smaller
      % 0.0001347355 - nx