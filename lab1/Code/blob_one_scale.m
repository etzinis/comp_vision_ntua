function interest_points = blob_one_scale( L, s, threshold )


I=im2double(L);


%Compute Is

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

interest_map = (maxima & (R >= threshold * Rmax));
[interest_points(:,2), interest_points(:,1)] = ind2sub(size(I) ,find(interest_map));
interest_points = horzcat(interest_points,ones(size(interest_points,1),1) * s);

end

