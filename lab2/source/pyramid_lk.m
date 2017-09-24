function [ d_x, d_y ] = pyramid_lk( I1, I2, r, epsilon, d_x0, d_y0 , scales)
%PYRAMID_LK Summary of this function goes here
%   Detailed explanation goes here
    
    gauss = 3;
    ns=ceil(3*gauss)*2+1;
    Gs = fspecial('gaussian',ns,gauss);


    s1{1} = I1;
    s2{1} = I2;
    for k = 2:scales
        s1{k} = impyramid( imfilter(s1{k-1}, Gs) ,'reduce');
        s2{k} = impyramid( imfilter(s2{k-1}, Gs) ,'reduce');
    end

    d_x = imresize(d_x0,1/2^(scales));
    d_y = imresize(d_y0,1/2^(scales));
    for k = scales:-1:1
        d_x = 2 * imresize(d_x, 2);
        d_y = 2 * imresize(d_y, 2);
        [d_x, d_y ] = lk(s1{k} , s2{k} , r, epsilon, d_x, d_y);
        
    end
    
    display(max(max(d_x)));
    display(max(max(d_y)));
    
end

