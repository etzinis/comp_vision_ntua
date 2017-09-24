clear all;
close all;

%% 2.5.1
L=imread('cv16_lab1_material\sunflowers.png');
L1=im2double(L);
I=rgb2gray(L1);

s = 2.5;

% interest_map=box_filters_one_scale(I,L1,s);
% [interest_points(:,2), interest_points(:,1)] = ind2sub(size(I) ,find(interest_map));
% interest_points = horzcat(interest_points,ones(size(interest_points,1),1) * s);
% interest_points_visualization(L1,interest_points);

%% Polles klimakes

N = 4;
s0 = 2.5;
scale = 1.78;




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


interest_points_visualization(L1,Parameters);


%TODO FInd correct parameters

