% all springs are the same
kspring = ses(120);
% initialize 
K = zeros(5,5);
P = [0;0; 0; 0; 20]

% fem of spring system
K = springAssemble(K,kspring,1,3);
K = springAssemble(K,kspring,3,4);
K = springAssemble(K,kspring,3,5);
K = springAssemble(K,kspring,3,5);
K = springAssemble(K,kspring,5,4);
K = springAssemble(K,kspring,4,2);


% replace the spring with the fixed situation 3-4 =2 3-5 = 1

K(1,1) = 1;
K(1,3) = 0;
K(3,1) = 0;
K(2,4) = 0;
K(4,2) = 0;
K(2,2) = 1;

K

U = K\P

