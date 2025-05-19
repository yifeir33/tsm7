clear all; clc; close all;

E = 210; % GPa
nue = 0.3;
t = 0.025; %m
w = 3000;
n = 4 % nodes
dof = 2; % move up and down
% nodal coordinatates
x1 = 0.0; x2 = 0.5; x3 = 0.5; x4 = 0.0; x5 = 0.25;
y1 = 0.0; y2 = 0.0; y3 = 0.25; y4 = 0.25;y5 = 0.125;
x = [x1 x2 x3 x4 x5];
y = [y1 y2 y3 y4 y5];
% Fin2tri = [0.0,0.0,9.375,0.0,9.375,0.0,0.0,0.0];
Fin4tri = [0.0,0.0,9.375,0,9.375,0.0,0.0,0.0,0.0,0.0];
% patch(x,y,'white');

% with 4 triangles (125,235,345,154)

% initialize 5 points *2 dim
globalK_2 = zeros(10,10);

% get stiffness 1->stress
stiff2_1 = LinearTriangleElementStiffness(E,nue,t,x1,y1,x2,y2,x5,y5,1);
stiff2_2 = LinearTriangleElementStiffness(E,nue,t,x2,y2,x3,y3,x5,y5,1);
stiff2_3 = LinearTriangleElementStiffness(E,nue,t,x3,y3,x4,y4,x5,y5,1);
stiff2_4 = LinearTriangleElementStiffness(E,nue,t,x1,y1,x5,y5,x4,y4,1);

globalK_2 = LinearTriangleAssemble(globalK_2, stiff2_1,1,2,5);
globalK_2 = LinearTriangleAssemble(globalK_2, stiff2_2,2,3,5);
globalK_2 = LinearTriangleAssemble(globalK_2, stiff2_3,3,4,5);
globalK_2 = LinearTriangleAssemble(globalK_2, stiff2_4,1,5,4);

% fixed conditions  1 and 4 are fixed
globalK_2 = FixedBoundaryCondition(globalK_2, 1* 2 - 1);
globalK_2 = FixedBoundaryCondition(globalK_2, 1* 2);
globalK_2 = FixedBoundaryCondition(globalK_2, 4* 2 - 1);
globalK_2 = FixedBoundaryCondition(globalK_2, 4* 2);
globalK_2


% displacement  = stress / strain  K* u = f
U = globalK_2\Fin4tri'