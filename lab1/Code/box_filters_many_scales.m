function Parameters = box_filters_many_scales( L, N, s0,scale )
I=im2double(L);

AbsLog = compute_LoG(N,s0,scale,I);
for i=1:4
    s = s0 * scale^(i-1);
    
    interest_map=box_filters_one_scale(I,s); 

    if (i==1)     AbsLogCond = AbsLog(:,:,i) >= AbsLog(:,:,i+1) ; 
    elseif(i==N) AbsLogCond= AbsLog(:,:,i) >= AbsLog(:,:,i-1); 
    else     AbsLogCond = AbsLog(:,:,i) >= AbsLog(:,:,i+1) & AbsLog(:,:,i) >= AbsLog(:,:,i-1); 
    end
    [temp_y,temp_x] = find(interest_map & AbsLogCond);
    Temp_Parameters = horzcat(temp_x,temp_y, ones(size(temp_x,1),1) * s);
    if i == 1
        Parameters = Temp_Parameters;
    else
        Parameters = cat(1,Temp_Parameters,Parameters);
    end

end

end

