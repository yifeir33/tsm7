clear all; clc; close all;

E = 70; 
v = 0.25;
t = 0.02;
P = 20;
F = zeros(1,16*2);
F(32) = -20;
% initialize 16 points * 2 dim
globalK = zeros(16*2, 16*2);


function [x,y] = calCoordinate(i)
        x = mod(i,4) * 0.3;
        y = fix(i/4) * 0.3;

end

% 3 points i left bottom of every triangle , j = i + 1, k = i + 4; l = i + 5
for i = 1:12
    if mod(i, 4) ~= 0 && i ~= 6
        % col+1
        j = i + 1;
        % row+1
        k = i + 4;
        % col+1, row+1
        l = i + 5;
    % adding stiffness
        [xi,yi] = calCoordinate(i);
        [xj,yj] = calCoordinate(j);
        [xk,yk] = calCoordinate(k);
        [xl,yl] = calCoordinate(l);
        stiff1 = LinearTriangleElementStiffness(E,v,t,xi,yi,xj,yj,xl,yl,1);
        globalK = LinearTriangleAssemble(globalK, stiff1,i,j,l);
        stiff2 = LinearTriangleElementStiffness(E,v,t,xi,yi,xl,yl,xk,yk,1);
        globalK = LinearTriangleAssemble(globalK, stiff2,i,l,k);
    end


end

% fixed for 1, 5, 9, 13
globalK = FixedBoundaryCondition(globalK, 1* 2 - 1);
globalK = FixedBoundaryCondition(globalK, 1* 2);
globalK = FixedBoundaryCondition(globalK, 5* 2 - 1);
globalK = FixedBoundaryCondition(globalK, 5* 2);
globalK = FixedBoundaryCondition(globalK, 9* 2 - 1);
globalK = FixedBoundaryCondition(globalK, 9* 2);
globalK = FixedBoundaryCondition(globalK, 13* 2 - 1);
globalK = FixedBoundaryCondition(globalK, 13* 2);

U = globalK\F'


