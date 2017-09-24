function Parameters = corner_one_scale( L,s,r,k,thetacorn )
    

    I=im2double(L);


    ns=ceil(3*s)*2+1;
    nr=ceil(3*r)*2+1;
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

    %Find the indices of corners and save them at the parameters array
    [params(:,2),params(:,1)] = find(Cond1 & Cond2);
    Parameters = horzcat(params, ones(size(params,1),1) * s);
     

end

