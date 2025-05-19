clear all; close all;clc;
h = 1.5; % height
v = 3.5;  % velocity of the bike
a = 1; % wheel base
b = 0.33; % distance wheel hub to COM
mu = 133; % a derived quantity
gamma = 4.0; % a derived quantity
g = 9.81;
% initial conditions alpha, alpha1, theta, theta1
s0 = [0 1 0 0];
% time settings
tspan=[0 3];

dsdt = @(t,s)[s(2);
    mu * (s(3)-(v^2/(g*a))*s(1)) + (gamma *v*s(4));
    s(4);
    (g/h)*(s(3)-(v^2)/(g*a))*s(1)-((b*v)/(h*a))*s(2)];
[t,s] = ode45(dsdt,tspan,s0);
plot(t,s)



