function [ AbsLog ] = compute_LoG( N, s0,scale , I)
%COMPUTE_LOG 
    for K=1:N
        s=s0*scale^(K-1);
        ns = ceil(3*s)*2+1;
        Log = fspecial('log', ns, s);
        Log_I = imfilter(I,Log,'symmetric');
        AbsLog(:,:,K) = s^2 * abs(Log_I);
    end;

end

