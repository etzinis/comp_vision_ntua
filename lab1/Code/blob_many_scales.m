function Parameters = blob_many_scales( L, s0,scale, threshold,N )
I=im2double(L);

AbsLog = compute_LoG( N, s0,scale , I);

for i=1:N
    s=s0*scale^(i-1);
    ns=ceil(3*s)*2+1;
    Gs =fspecial('gaussian', ns, s);
    Is = imfilter(I,Gs,'symmetric');

    %Compute Hessian
    [gx,gy] = gradient(Is);
    [hxx,hxy] = gradient(gx);
    [hxy,hyy] = gradient(gy);

    R = hxx.*hyy - hxy.*hxy;

    %Finds maxima
    ns=ceil(3*s)*2+1;
    B_sq = strel('disk', ns);
    maxima = (R==imdilate(R,B_sq));
    Rmax = max(max(R));
    
    if (i==1)     AbsLogCond = AbsLog(:,:,i) >= AbsLog(:,:,i+1) ; 
    elseif(i==N) AbsLogCond= AbsLog(:,:,i) >= AbsLog(:,:,i-1); 
    else     AbsLogCond = AbsLog(:,:,i) >= AbsLog(:,:,i+1) & AbsLog(:,:,i) >= AbsLog(:,:,i-1); 
    end
    [temp_y,temp_x] = find(maxima & (R >= threshold * Rmax) & AbsLogCond );
    Temp_Parameters = horzcat(temp_x,temp_y, ones(size(temp_x,1),1) * s);
    if i == 1
        Parameters = Temp_Parameters;
    else
        Parameters = cat(1,Temp_Parameters,Parameters);
    end
    
    
end
end

