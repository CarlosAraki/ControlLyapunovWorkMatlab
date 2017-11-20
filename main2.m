%parte discreta 7/8


clear
close all
clc

% Dados do sistema

MJ = 1.0731; % [kg]
m  = 0.209;  % [kg]
l  = 0.3302; % [m]
bK = 5.4;    % [N.s/(m²)]
Kr = 1.0717; % [N/V]

g  = 9.81;   % [m/s²]

zetta = [0 0 0 0]';
u = 0; %12 volts bateria de carro degrau

s = tf('s');
[sys,y,d_zetta] = linear_func(zetta,u);
tfG = tf(sys);
tfG = tfG/s;
b = [.9987 0 29.67];
a = [1 5.032 35.5 149.5 0 0];

[r,p,k] = residue(b,a)

syms s

f1 = .9775/(s+ 4.51);
f2 = 0.002935/(  s^2 + 0.5218*s + 33.15);
%.9775*exp(-4.51*t)
%5.1028e-04 *(sin(5.7517*t)*exp(-.2609*t))
 













