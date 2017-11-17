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

% trabalho com Julieras controle =)
syms teta2 m l P teta M J r R b K teta1 x1 x g

x2 = (-teta2*m*l^2 - P*l*sin(teta))/m*l*cos(teta) ;

f1 = x2*(M +J/r^2) + x1*((b+K^2)/R*r^2) - teta2*(m*l*sin(teta)) + (teta1^2)*(l*sin(teta)^2)/cos(teta) - m*g*tg(teta);


