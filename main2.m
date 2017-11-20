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
% b = [.9987 0 29.67];
% a = [1 5.032 35.5 149.5 0 0];
% [r,p,k] = residue(b,a)
% f2 = 0.002935/(  s^2 + 0.5218*s + 33.15);
% f3 = .04805/(s+4.51);
% f4 = -.04713/s;
% f5 = .1985/s;
%.04805*exp(-4.51*t) -> .04805 * z/z-exp(-4.51)
%5.1028e-04 *(sin(5.7517*t)*exp(-.2609*t)) ->
%5.1028e-04*(sin(5.7517)*exp(-.2609)*z)/(z^2  -2*cos(5.7571)*exp(-.2609)*z + exp(-.5212))
%-.04713*u(t) -> Ztrans = -.04713 *z/z-1
%.1985*u(t) - > .1985 * z/z-1
T= 1;
Gdz = c2d(tfG, T, 'zoh');
sisotool(Gdz)














