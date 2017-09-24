function [ H ] = Gabor_Detector( L )
%GABOR_DETECTOR Summary of this function goes here
%   Detailed explanation goes here
    t_scale = 1;

    s = 0.5;
    ns = ceil(3*s)*2+1;
    gauss1d = gausswin(ns);

    Ismooth = sep_conv(L, gauss1d, 2);

    [hev, hodd] = gabor_filters(t_scale);

    t_hev = zeros(1,1,size(hev,2));
    t_hev(1,1,:) = hev;
    Iev = convn(Ismooth, t_hev, 'same').^2;

    t_hodd = zeros(1,1,size(hodd,2));
    t_hodd(1,1,:) = hodd;
    Iodd = convn(Ismooth, t_hodd, 'same').^2;

    H = Iev + Iodd;

end

