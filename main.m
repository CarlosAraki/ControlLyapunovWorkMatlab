clear
close all
clc


% trabalho com Julieras controle =)
syms teta2 m l P teta M J r R b K teta1 x1 x g

x2 = (-teta2*m*l^2 - P*l*sin(teta))/m*l*cos(teta) ;

f1 = x2*(M +J/r^2) + x1*((b+K^2)/R*r^2) - teta2*(m*l*sin(teta)) + (teta1^2)*(l*sin(teta)^2)/cos(teta) - m*g*tg(teta);


