function [ hev, hodd ] = gabor_filters( t_scale )
%GABOR_FILTERS Summary of this function goes here
%   Detailed explanation goes here
    ts = -2*t_scale:2*t_scale;
    
    % Deutero
%     m =  ceil(3*t_scale)*2+1;
%     ts = linspace(-2*t_scale,2*t_scale,m);
    
    
    omega = 4 / t_scale;
    hev = -cos(2*pi*ts*omega).* exp(-ts.^2/(2*t_scale^2));
    hodd = -sin(2*pi*ts*omega).* exp(-ts.^2/(2*t_scale^2));

    hev = hev / norm(hev, 2);
    hodd = hodd / norm(hodd, 2);
end

