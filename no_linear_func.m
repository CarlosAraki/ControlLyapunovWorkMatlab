function [ sys,y, d_zetta] = no_linear_func( zetta, u )

    MJ = 1.0731; % [kg]
    m  = 0.209;  % [kg]
    l  = 0.3302; % [m]
    bK = 5.4;    % [N.s/(m²)]
    Kr = 1.0717; % [N/V]
    g  = 9.81;   % [m/s²]
    A = [0 1 0 0
        0 -bK/MJ m*g/MJ 0
        0 0 0 1
        0 bK/(MJ*l) -((g/l)+(m*g/(MJ*l))) 0];
    
    B = [0 
        Kr/MJ
        0
        -Kr/(MJ*l)];
    
    C = [1 0 0 0];
    
    D = [0];
    
    d_zetta = A*zetta + B*u;
    
    y = C*zetta + D*u;
    


end