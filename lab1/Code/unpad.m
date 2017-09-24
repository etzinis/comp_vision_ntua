function [ s ] = unpad( temp_s , pad )
%UNPAD Summary of this function goes here
%   Detailed explanation goes here
sx = size(temp_s,1);
sy = size(temp_s,2);
s = temp_s(pad:sx - pad ,pad:sy - pad);

end

