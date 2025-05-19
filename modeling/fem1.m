clear all; 
close all;clc;



% spring k1 element
k1 = ses(100);

% spring k2 element
k2 = ses(200);

% initialize, 3 points * 1 degree of freedom
K = zeros(3, 3);

% adding one by one
K = springAssemble(springAssemble(K, k1, 1, 2), k2,2,3)

% Fixing boundary conditions ？？
K(1,1) = 1;
K(1,2) = 0;
K(2,1) = 0;
K

% solve for [0; 0; 15]
F = [0;0;15];
U = K\F