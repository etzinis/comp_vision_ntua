function [ d_x, d_y ] = lk( I1, I2, r, epsilon, d_x0, d_y0 )
%LK Summary of this function goes here
%   Detailed explanation goes here
    I1=double(I1);
    I2=double(I2);
    nr=ceil(3*r)*2+1;
    Gr = fspecial('gaussian',[nr nr],r);

    [x_0,y_0]=meshgrid(1:size(I1,2), 1:size(I1,1)); 
    [start_A1,start_A2]=gradient(I1);
    dx=d_x0;
    dy=d_y0;

    i=1;
    threshold = 0.5;
    while (i < 60)
        Iprevd=interp2(I1,x_0+dx,y_0+dy, 'linear', 0);
        A1 = interp2(start_A1,x_0+dx,y_0+dy, 'linear', 0);
        A2 = interp2(start_A2,x_0+dx,y_0+dy, 'linear', 0);
        E=I2-Iprevd;
        
        a11 = imfilter(A1.^2, Gr, 'symmetric') + epsilon;
        a12 = imfilter(A1.*A2, Gr, 'symmetric');
        a22 = imfilter(A2.^2, Gr, 'symmetric') + epsilon;
        
        b1 = imfilter(A1.*E, Gr, 'symmetric');
        b2 = imfilter(E.*A2, Gr, 'symmetric');
        
        detino = (a11.*a22 - a12.*a12);
        
        u_x = (a22.*b1 - a12.*b2) ./ detino;
        u_y = (a11.*b2 - a12.*b1) ./ detino;

        dx = dx + u_x;
        dy = dy + u_y;

%         display(norm(u_x));
%         display(norm(u_y));
        plotas(i,1)=norm(u_x);
        plotas(i,2)=norm(u_y);
        if(norm(u_x) < threshold & norm(u_y) < threshold)
            break
        end
        i = i + 1;
    end

    d_x = dx;
    d_y = dy;
    
%     figure;
%     trampa=1:size(plotas(:,1));
%     plot(trampa,plotas(:,1),trampa,plotas(:,2));

end

