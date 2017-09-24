function [ H ] = Harris_Detector( L )

    coef = 0.01;

    s = 0.5;
    ns = ceil(3*s)*2+1;
    gauss1d = gausswin(ns);

    % TODO: Maybe we have to incorporate scale into grad
    grad_L = find_grad(L);

    % TODO: Find a way to do this without the for loop (maybe with reshape)
    temp = zeros(size(L,1), size(L,2), size(L,3), size(grad_L,4), size(grad_L,4));
    for i=1:size(grad_L,1)
       for j=1:size(grad_L,2)
           for k=1:size(grad_L,3)
               temp(i,j,k,:,:) = squeeze(grad_L(i,j,k,:)) * squeeze(grad_L(i,j,k,:))';
           end
       end 
    end 

    M = sep_conv(temp, gauss1d, 3);

    dets = zeros(size(L,1), size(L,2), size(L,3));
    traces = zeros(size(L,1), size(L,2), size(L,3));
    for i=1:size(grad_L,1)
        for j=1:size(grad_L,2)
            for k=1:size(grad_L,3)
                dets(i,j,k) = det(squeeze(M(i,j,k,:,:)));
                traces(i,j,k) = trace(squeeze(M(i,j,k,:,:)))^3;
            end
        end 
    end 

    H = dets - coef*traces;

end

