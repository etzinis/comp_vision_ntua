function [ sA,sB,sC,sD ] = computeSs_Integral( intI, shiftX, shiftY, offsetx, offsety )
%COMPUTESS_INTEGRAL Summary of this function goes here
    %Right-Bottom corner
    sD = circshift(intI,-shiftY + offsety,1);
    sD = circshift(sD,-shiftX + offsetx,2);
    %Left-Top Corner
    sA = circshift(intI,shiftY + offsety,1);
    sA = circshift(sA,shiftX + offsetx,2);
    %Right-Top corner
    sB = circshift(intI,shiftY + offsety,1);
    sB = circshift(sB,-shiftX + offsetx,2);
    %Left-Bottom Corner
    sC = circshift(intI,-shiftY + offsety,1);
    sC = circshift(sC,shiftX + offsetx,2);
end

