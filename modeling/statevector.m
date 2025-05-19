clear all; close all; clc;

% m = 68.1;
% g=9.81;
% c=0.25;
% t=0;
% x=0;
% v= 0;
% tend=12;
% h=0.5;
% % state vector
% y=[x v]';
% dydt=[v g-(c/m)*v^2]';
% i=1;
% while( t<tend )
% y=y + dydt*h;
% dydt=[y(2) g-(c/m)*y(2)^2]';
% loc(i)= y(1);
% vel(i)= y(2);
% tim(i)= t;
% i=i+1;
% t=t+h;
% end
% plot(tim,loc,'+');

mass =0.4;
g = 9.81;
v_i = 15;
angle = pi/6;
v_x = cos(angle)*v_i
v_y = sin(angle)* v_i
t = 0;
x = 0;
y = 0;
tend = 7;
dt =0.1;
i = 1;
beta = 0.142;
% state vector
s = [x v_x y v_y ]'
dsdt = [v_x, 0, v_y, -g]'
while t< tend
    locx(i) = s(1);
    velx(i) = s(2);
    locy(i) = s(3);
    vely(i) = s(4);
    tim(i) = t;
    % euler state vector
    s = s + dsdt*dt;
    dsdt = [s(2),s(2)*-1*beta/mass, s(4), (-1*g)-(beta/mass*s(4))]';
    t = t + dt;
    i= i +1;
    if s(3) < 0
        break;
    end

end

subplot(1,2,1);
plot(locx,locy);
subplot(1,2,2);
plot(velx, vely);

