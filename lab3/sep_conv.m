function [ output ] = sep_conv( input, kernel, dims )
% kernel must be a n x 1 vector
    output = convn(input,kernel,'same');
    output = convn(output,kernel','same');

    if dims == 3
        t_kernel = zeros(1,1,size(kernel,1));
        t_kernel(1,1,:) = kernel;
        output = convn(output, t_kernel, 'same');
    end
end

