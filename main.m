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
zetta = [0 0 0 0]';
u = 2; %12 volts bateria de carro degrau
s = tf('s');
[sys,y,d_zetta] = linear_func(zetta,u);
ftG = tf(sys);
polosG = pole(ftG);
zerosG = zero(ftG);

% Controlador obsoleto
% C1 = (s+3)/(s+15);

% Novo Controlador
C1 = 24*(s+5)/(s+15);
% Tempo de estabilização: 2.08 s
% Esforço de controle: 24 V
% Amortecimento: 
[Cnum, Cden] = tfdata(C1, 'v');

sisotool(ftG)


