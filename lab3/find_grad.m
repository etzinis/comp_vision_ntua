function [ grad_L ] = find_grad( L )
    % Kernel for the x, y  convolution
    kernel = [-1 0 1];

    Lx = convn(L, kernel, 'same');
    Ly = convn(L, kernel', 'same');
    
    % Kernel for the t convolution
    t_kernel = zeros(1,1,3);
    t_kernel(1,1,1) = -1;
    t_kernel(1,1,3) = 1;
    
    Lt = convn(L, t_kernel, 'same');
    
    grad_L = zeros(size(L,1), size(L,2), size(L,3), 3);
    
    grad_L(:,:,:,1) = Lx;
    grad_L(:,:,:,2) = Ly;
    grad_L(:,:,:,3) = Lt;
end

