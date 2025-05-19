clear all; clc; close all;

E = 210; % GPa
nue = 0.3;
t = 0.025; %m
w = 3000;
n = 4 % nodes
dof = 2; % move up and down
% nodal coordinatates
x1 = 0.0; x2 = 0.5; x3 = 0.5; x4 = 0.0;
y1 = 0.0; y2 = 0.0; y3 = 0.25; y4 = 0.25;
x = [x1 x2 x3];
y = [y1 y2 y3];
Fin2tri = [0.0,0.0,9.375,0.0,9.375,0.0,0.0,0.0];
% Fin4tri = [0.0,0.0,9.375,0,9.375,0.0,0.0,0.0,0.0,0.0];
% patch(x,y,'white')

% with 2 triangles
% assemble, links, calculation 123 134
% initialize 4 points *2 dim
globalK = zeros(8,8);

% get stiffness 1->stress
stiff1_1 = LinearTriangleElementStiffness(E,nue,t,x1,y1,x2,y2,x3,y3,1);
stiff1_2 = LinearTriangleElementStiffness(E,nue,t,x1,y1,x3,y3,x4,y4,1);

globalK = LinearTriangleAssemble(globalK, stiff1_1,1,2,3);
globalK = LinearTriangleAssemble(globalK, stiff1_2,1,3,4);

% fixed conditions  1 and 4 are fixed
globalK = FixedBoundaryCondition(globalK, 1* 2 - 1);
globalK = FixedBoundaryCondition(globalK, 1* 2 );
globalK = FixedBoundaryCondition(globalK, 4* 2 - 1);
globalK = FixedBoundaryCondition(globalK, 4* 2);
globalK


% displacement  = stress / strain  K* u = f
U = globalK\Fin2tri'


% stress
% stress1 = LinearTriangleElementStresses(E,nue,x1,y1,x2,y2,x3,y3,1,u);
% stress2 = LinearTriangleElementStresses(E,nue,x1,y1,x3,y3,x4,y4,1,u);

% area1 = LinearTriangleElementArea(x1,y1,x2,y2,x3,y3);
% area2 = LinearTriangleElementArea(x1,y1,x3,y3,x4,y4);


