k1 = ses(120);
k2 = ses(120);
k3 = ses(120);
k4 = ses(200);
P = [0;0;0;30];

% degree of freedom 4, 4 points * 1 directions
% initialize
K = zeros(4,4);

K = springAssemble(K, k1, 1, 2);
K = springAssemble(K, k2, 2, 3);
K = springAssemble(K, k3, 2, 3);
K = springAssemble(K, k4, 3, 4);

% i think k2 and k3 overlap, which equals to a 240 kN spring
% Fixing boundary conditions
K(1,1) = 1;
K(1,2) = 0;
K(2,1) = 0;


U = K \ P 



