function [ sys,y, d_zetta] = linear_func( zetta, u )
%LINEAR_FUNC Summary of this function goes here
%   Detailed explanation goes here
    A = [0 1 0 0;
        0 bK m*g/MJ 0;
        0 0 0 1;
        0 0 -(g/l)*(1+m/MJ)];
    
    B = [0; Kr/MJ; 0; -Kr/l];
    
    C = [1; 0; 0; 0];
    
    D = [0];
    
    d_zetta = A*zetta + B*u;
    
    y = C*zetta + D*u;
    
    sys = ss(A,B,C,D);
end

