function [ hand ] = find_hand( I, mu, cov)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    threshold = [0.001 1];

    Iycbcr = I;
    Ilen = size(Iycbcr,1) *  size(Iycbcr,2);
    Icb = reshape(Iycbcr(:,:,2),[1 Ilen])';
    Icr = reshape(Iycbcr(:,:,3),[1 Ilen])';

    Iprob = mvnpdf([Icb Icr] , mu, cov);
    level = graythresh(Iprob*100)/100;
    Ihand = Iprob(:) >= level;
    Ihand = reshape(Ihand,[size(Iycbcr,1) size(Iycbcr,2)]);
    
    figure;
    imshow(Ihand,[]);
    
    % Opening - Closing
    se = strel('disk',1);
    Ihand = imopen(Ihand, se);

    se = strel('disk',8);
    Ihand = imclose(Ihand, se);

    % Labeling and Bounding Box
    labels = bwlabel(Ihand);
    s = regionprops(labels,'BoundingBox');
    hand = s.BoundingBox;

    growing_factor = 0.3;
    grow_x = ceil(growing_factor*hand(3));
    grow_y = ceil(growing_factor*hand(4));

    hand(4) = hand(4) + 2*grow_y;
    hand(3) = hand(3) + 2*grow_x;
    hand(2) = hand(2) - grow_y;
    hand(1) = hand(1) - grow_x;

    maxi = max(hand(3),hand(4));
    hand(1) = hand(1) - (maxi - hand(3))/2;
    hand(2) = hand(2) - (maxi - hand(4))/2;
    hand(4) = maxi;
    hand(3)=hand(4);

end

