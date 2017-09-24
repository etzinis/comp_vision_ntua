clear all;
close all;

%% 2.3.1
threshold = 0.12;

L=imread('cv16_lab1_material\sunflowers.png');
L1=im2double(L);
I=rgb2gray(L1);

%Compute Is
s = 2;
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

% interest_map = (maxima & (R >= threshold * Rmax));
% [interest_points(:,2), interest_points(:,1)] = ind2sub(size(I) ,find(interest_map));
% interest_points = horzcat(interest_points,ones(size(interest_points,1),1) * s);
% 
% interest_points_visualization(L1,interest_points);


%% 2.3.2

N=4;
s0=s;
scale=1.85;
threshold = 0.07;
%Ypologizoume thn LoG gia oles tis klimakes
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


%Show the results
interest_points_visualization(L1,Parameters);

