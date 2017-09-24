function Parameters = corner_many_scales( L,N,k,s0,r0,scale,thetacorn)


I=im2double(L);
%Ypologizoume thn LoG gia oles tis klimakes
AbsLog = compute_LoG(N,s0,scale,I);

for i=1:N
    s=s0*scale^(i-1);
    r=r0*scale^(i-1);
    ns = ceil(3*s)*2+1;
    nr = ceil(3*r)*2+1;
    Gs =fspecial('gaussian', ns, s);
    Gr =fspecial('gaussian', nr, r);

    %Find Is
    Is=imfilter(I,Gs,'symmetric');
    [dx,dy] = gradient(Is);

    %Compute Js
    J1 = imfilter(dx.*dx,Gr,'symmetric');
    J2 = imfilter(dx.*dy,Gr,'symmetric');
    J3 = imfilter(dy.*dy,Gr,'symmetric');

    %% 2.1.2
    J1minusJ3sq=(J1-J3).*(J1-J3);
    J2sq=J2.*J2;
    lplus=0.5*(J1 + J3 + sqrt(J1minusJ3sq + 4*J2sq));
    lminus=0.5*(J1 + J3 - sqrt(J1minusJ3sq + 4*J2sq));

    %% 2.1.3
    R = lplus.*lminus - k.*(lplus+lminus).^2;

    ns=ceil(3*s)*2+1;
    B_sq = strel('disk', ns);
    Cond1 = (R==imdilate(R,B_sq));

    maxR = max(max(R));
    Cond2 = ( R >= thetacorn*maxR);
    if (i==1)     AbsLogCond = AbsLog(:,:,i) >= AbsLog(:,:,i+1) ; 
    elseif(i==N) AbsLogCond= AbsLog(:,:,i) >= AbsLog(:,:,i-1); 
    else     AbsLogCond = AbsLog(:,:,i) >= AbsLog(:,:,i+1) & AbsLog(:,:,i) >= AbsLog(:,:,i-1); 
    end
    [temp_y,temp_x] = find(Cond1 & Cond2 & AbsLogCond);
    Temp_Parameters = horzcat(temp_x,temp_y, ones(size(temp_x,1),1) * s);
    if i == 1
        Parameters = Temp_Parameters;
    else
        Parameters = cat(1,Temp_Parameters,Parameters);
    end
    
    
end

end

