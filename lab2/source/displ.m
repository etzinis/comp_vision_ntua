function [ kx , ky ] = displ( dx, dy )
    %% Energy
    % Old method
    energy = dx.^2 + dy.^2;
    thresh_energy=0.9 * max(max(energy));
    usefull_pixels=find(energy > thresh_energy);

    angle = dy(usefull_pixels) ./ sqrt(dx(usefull_pixels).^2 + dy(usefull_pixels).^2);
    thresh_angle = 0.5;
    usefull_pixels2 = find( abs(angle - mean(mean(angle))) < thresh_angle);
    display(size(usefull_pixels2));
     kx=mean(dx(usefull_pixels(usefull_pixels2)));
     ky=mean(dy(usefull_pixels(usefull_pixels2)));
    
    % New method
%     best_angle = sum(sum(dy)) / sqrt(sum(sum(dx))^2 + sum(sum(dy))^2);
%     
%     angle = dy ./ sqrt(dx.^2 + dy.^2);
%     usefull_pixels=find(energy > thresh_energy & abs(angle - best_angle) < thresh_angle);
%     
%     if (size(usefull_pixels,1) == 0)
%         usefull_pixels=find(energy > thresh_energy); 
%     end
%     display(size(usefull_pixels));
% 
%     kx=mean(dx(usefull_pixels));
%     ky=mean(dy(usefull_pixels));
%     
    
end

