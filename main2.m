%% Modelagem Sistema
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

%% Projeto Controlador Contínuo

% Controlador obsoleto
% C1 = (s+3)/(s+15);

% Novo Controlador
%C = 24*(s+5)/(s+15);
% Tempo de estabilização: 2.08 s
% Esforço de controle: 24 V
% Amortecimento: 

% Agora sim um Controlador correto
C = 1.8488*(s+3.5774)/(s+1.9705);
[NC, DC] = tfdata(C, 'v');

% sisotool(tfG, C)

sysC = sim('nonlinear_sys','SimulationMode','normal');
y = sysC.get('yout').get('y').Values.Data;
t = sysC.get('yout').get('y').Values.Time;
ye = sysC.get('yout').get('esf').Values.Data;
te = sysC.get('yout').get('esf').Values.Time;

figure;
title('Deslocamento Controlador');
hold all;
grid on
plot(t, y, 'b');

errMaior = (10.2)*ones(length(t),1);
errMenor = (9.8)*ones(length(t),1);
plot(t, errMaior, 'black --');
plot(t, errMenor, 'black --');
legend('Controlador', 'Erro Regime', 'Erro Regime')
hold off

figure;
title('Esforço de Controle');
hold all;
grid on
plot(te, ye, 'b');
legend('Controlador', 'Erro Regime', 'Erro Regime')
hold off


%% Controlador Discretizado

Ts = [0.2 0.5 1.0];

for T=Ts
    % Discretização por: ZOH
    Cdz = c2d(C, T, 'zoh');
    [NCZ, DCZ] = tfdata(Cdz, 'v');

    % Discretização por: Tustin
    Cdt = c2d(C, T, 'tustin');
    [NCT, DCT] = tfdata(Cdt, 'v');

    % Discretização por: mapping
    Cdm = c2d(C, T, 'mapping');
    [NCM, DCM] = tfdata(Cdm, 'v');
    
    NCd = NCZ;
    DCd = DCZ;
    sysZ = sim('discrete','SimulationMode','normal');
    yZ = sysZ.get('yout').get('y').Values.Data;
    tZ = sysZ.get('yout').get('y').Values.Time;
    yeZ = sysZ.get('yout').get('esf').Values.Data;
    teZ = sysZ.get('yout').get('esf').Values.Time;
    
    NCd = NCM;
    DCd = DCM;
    sysM = sim('discrete','SimulationMode','normal');
    yM = sysM.get('yout').get('y').Values.Data;
    tM = sysM.get('yout').get('y').Values.Time;
    yeM = sysM.get('yout').get('esf').Values.Data;
    teM = sysM.get('yout').get('esf').Values.Time;
    
    NCd = NCT;
    DCd = DCT;
    sysT = sim('discrete','SimulationMode','normal');
    yT = sysT.get('yout').get('y').Values.Data;
    tT = sysT.get('yout').get('y').Values.Time;
    yeT = sysT.get('yout').get('esf').Values.Data;
    teT = sysT.get('yout').get('esf').Values.Time;
    
    figure;
    title(['Deslocamento T = ', num2str(T), ' s']);
    hold all;
    grid on
    plot(tZ, yZ, 'b');
    plot(tT, yT, 'r');
    plot(tM, yM, 'g');
    
    errMaior = (10.2)*ones(length(tZ),1);
    errMenor = (9.8)*ones(length(tZ),1);
    plot(tZ, errMaior, 'black --');
    plot(tZ, errMenor, 'black --');
    
    legend('ZOH','TUSTIN','MAPPING', 'Erro Regime', 'Erro Regime')
    hold off
    
    figure;
    title(['Esforço de Controle T = ', num2str(T), ' s']);
    hold all;
    grid on
    stairs(teZ, yeZ, 'b');
    stairs(teT, yeT, 'r');
    stairs(teM, yeM, 'g');
    legend('ZOH','TUSTIN','MAPPING')
    hold off
    
    if T==0.2
        bestControllerInfo = stepinfo(yZ,tZ);
    end
end

discretSettlingTime = bestControllerInfo.SettlingTime; % [s]

%% Controlador Discreto

T= 1;
Gdz = c2d(tfG, T, 'ZOH');

% Controlador discreto
z = tf('z',1);
CD = 2.2652*(z+0.11)/(z-0.01);
[NCD, DCD] = tfdata(CD, 'v');

% Controlador discretizado
T = 0.2;
Cdz = c2d(C, T, 'ZOH');
[NCZ, DCZ] = tfdata(Cdz, 'v');

T=1;
NCd = NCD;
DCd = DCD;
sysD = sim('discrete','SimulationMode','normal');
yD = sysD.get('yout').get('y').Values.Data;
tD = sysD.get('yout').get('y').Values.Time;
yeD = sysD.get('yout').get('esf').Values.Data;
teD = sysD.get('yout').get('esf').Values.Time;

T = 0.2;
NCd = NCZ;
DCd = DCZ;
sysZ = sim('discrete','SimulationMode','normal');
yZ = sysZ.get('yout').get('y').Values.Data;
tZ = sysZ.get('yout').get('y').Values.Time;
yeZ = sysZ.get('yout').get('esf').Values.Data;
teZ = sysZ.get('yout').get('esf').Values.Time;

figure;
title('Comparação Discreto Vs Discretizado');
hold all;
grid on
plot(tD, yD, 'b');
plot(tZ, yZ, 'g');
errMaior = (10.2)*ones(length(tD),1);
errMenor = (9.8)*ones(length(tD),1);
plot(tD, errMaior, 'black --');
plot(tD, errMenor, 'black --');
legend('Discreto','ZOH', 'Erro Regime', 'Erro Regime')
hold off

figure;
title('Esforço de Controle Discreto Vs Discretizado');
hold all;
grid on
stairs(teD, yeD, 'b');
stairs(teZ, yeZ, 'g');
legend('Discreto','ZOH');
hold off
%% Graficos comparação Discretizado e discreto

ySD = sysD.get('yout').get('state').Values.Data;
tSD = sysD.get('yout').get('state').Values.Time;

ySZ = sysZ.get('yout').get('state').Values.Data;
tSZ = sysZ.get('yout').get('state').Values.Time;

figure;
title('Controlador Discretizado com ZOH');
subplot(4,1,1);
plot(tSZ, ySZ(:,1));
subplot(4,1,2);
plot(tSZ, ySZ(:,2));
subplot(4,1,3);
plot(tSZ, ySZ(:,3));
subplot(4,1,4);
plot(tSZ, ySZ(:,4));

figure;
title('Controlador Projetado Discreto');
subplot(4,1,1);
plot(tSD, ySD(:,1));
subplot(4,1,2);
plot(tSD, ySD(:,2));
subplot(4,1,3);
plot(tSD, ySD(:,3));
subplot(4,1,4);
plot(tSD, ySD(:,4));

