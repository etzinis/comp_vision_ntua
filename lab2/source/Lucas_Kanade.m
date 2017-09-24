function [ new_hand ] = Lucas_Kanade( I1, I2, U1, U2, hand, index )

    I1hand = masking(I1,U1,hand);
    I2hand = masking(I2,U2,hand);
    
    d_x0 = 0 * I1hand;
    d_y0 = 0 * I1hand;
    
    r=5;
    epsilon = 0.01;

    %[dx, dy] = pyramid_lk(I1hand,I2hand,r,epsilon,d_x0, d_y0, 2);
    [dx, dy] = lk(I1hand,I2hand,r,epsilon,d_x0, d_y0);
%     plot_dx = imresize(dx(hand(1):hand(1)+hand(3), hand(2):hand(2)+hand(4)), 0.3);
%     plot_dy = imresize(dy(hand(1):hand(1)+hand(3), hand(2):hand(2)+hand(4)), 0.3);
    fig=figure();
    imshow(I2);
    hold on;
    quiver(-dx, -dy);
    title('Optical Flow');
    xlabel('x axis');
    ylabel('y axis');
    saveas(fig,strcat('Multi_Scale_Images/Optical/optical_flow_frame',int2str(index),'.png'));
    
    energy = dx.^2 + dy.^2;
    fig=figure;
    imshow(energy,[]);
    title('Energy');
    saveas(fig,strcat('Multi_Scale_Images/Energy/energy_frame',int2str(index),'.png'));
    
    %[dx, dy] = lk(I1hand,I2hand,r,epsilon,d_x0, d_y0);
    [kx,ky]=displ(dx,dy);
    
    new_hand=hand;

    new_hand(1) = new_hand(1) - kx;
    new_hand(2) = new_hand(2) - ky;
    
end

