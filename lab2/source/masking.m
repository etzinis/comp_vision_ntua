function [ Ihand ] = masking( I , U, hand )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    Iycbcr = double(rgb2ycbcr(I));
    for k = 1:3
        Iycbcr(:,:,k) = Iycbcr(:,:,k) .* U;
    end

    polyx=[hand(1),hand(1)+hand(3),hand(1)+hand(3),hand(1),hand(1)];
    polyy=[hand(2),hand(2),hand(2)+hand(4),hand(2)+hand(4),hand(2)];
    Imask = poly2mask(polyx,polyy,size(I,1),size(I,2));
    Ihand=double(rgb2gray(I))/255.*Imask;

end

