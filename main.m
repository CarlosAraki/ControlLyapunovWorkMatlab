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
polosG = pole(tfG);
zerosG = zero(tfG);

% Controlador obsoleto
% C1 = (s+3)/(s+15);

% Novo Controlador
C = 24*(s+5)/(s+15);
% Tempo de estabilização: 2.08 s
% Esforço de controle: 24 V
% Amortecimento: 
[NC, DC] = tfdata(C, 'v');

% sisotool(tfG, C)

Ts = [0.2 0.5 1.0];

for T=Ts
    % Discretização por: ZOH
    Cdz = c2d(C, T, 'zoh');
    [NCZ, DCZ] = tfdata(Cdz, 'v');

    % Discretização por: Tustin
    Cdt = c2d(C, T, 'tustin');
    [NCT, DCT] = tfdata(Cdt, 'v');

    % Discretização por: ZOH
    Cdm = c2d(C, T, 'mapping');
    [NCM, DCM] = tfdata(Cdm, 'v');
    
    NCd = NCZ;
    DCd = DCZ;
    sysZ = sim('discrete','SimulationMode','normal');
    yZ = sysZ.get('yout').get('y').Values.Data;
    tZ = sysZ.get('yout').get('y').Values.Time;
    
    NCd = NCT;
    DCd = DCT;
    sysT = sim('discrete','SimulationMode','normal');
    yT = sysZ.get('yout').get('y').Values.Data;
    tT = sysZ.get('yout').get('y').Values.Time;
    
    NCd = NCM;
    DCd = DCM;
    sysM = sim('discrete','SimulationMode','normal');
    yM = sysM.get('yout').get('y').Values.Data;
    tM = sysM.get('yout').get('y').Values.Time;
    
    figure;
    title(T)
    hold all;
    plot(tZ, yZ, 'blue');
    plot(tT, yT, 'red');
    plot(tM, yM, 'green');
end
