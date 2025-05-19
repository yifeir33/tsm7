clear all; close all;clc;
dsdt = @(t,s)[s(2);(1-s(1)^2) * s(2)-s(1)];
s0 = [2,0];
tspan =[0;20];
[t,s] = ode45(dsdt, tspan, s0);
plot(t,s)
