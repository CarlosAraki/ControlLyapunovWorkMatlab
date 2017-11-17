function [ y, d_zetta] = nonlinear_func(zetta, u)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    MJ = 1.0731; % [kg]
    m  = 0.209;  % [kg]
    l  = 0.3302; % [m]
    bK = 5.4;    % [N.s/(m²)]
    Kr = 1.0717; % [N/V]

    M_aux = MJ + m*cos;
    
    A = [ 0 1 0 0
          0 -bk/M_aux 0 -(zetta(4)*l*sin(zetta(3))^2)/(cos(zetta(3))*M_aux)
          0 0 0 1
          0 bk*cos(zetta(3))/(M_aux*l) 0 zetta(4)*sin(zetta(3))^2/(M_aux)];
      
    F1 = m*g*tan(zetta(3)) + Kr*u;
    F2 = -cos(zetta(3))*F1/(l*M_aux);
    
    B = [ 0 F1/M_aux 0 F2]';
    
    y = zetta(1);
    d_zetta = A*zetta + B;

end

