clear all; close all; clc;


%% Meros 1

load('skinSamplesRGB.mat');
%imshow(skinSamplesRGB);
sampling = 200;

% TODO Check double
skinSamplesYCbCr = double(rgb2ycbcr(skinSamplesRGB));
cb = skinSamplesYCbCr(:,:,2);
cr = skinSamplesYCbCr(:,:,3);
total_size = size(cb,1) * size(cb ,2);

meanGaussian(1) = sum(sum(cb))/total_size;
meanGaussian(2) = sum(sum(cr))/total_size;

covarianceGaussian = cov(cb,cr);
x1 = (1:sampling); x2 = (1:sampling);
[X1,X2] = meshgrid(x1,x2);
multiGaussian = mvnpdf([X1(:) X2(:)],meanGaussian, covarianceGaussian);
multiGaussian = reshape(multiGaussian,length(x2),length(x1));
% figure;
% surf(x1,x2,multiGaussian);
% caxis([min(multiGaussian(:))-.5*range(multiGaussian(:)),max(multiGaussian(:))]);
% title('Probability Gaussian');
% xlabel('Cb') % x-axis label
% ylabel('Cr') % y-axis label


I = imread('Chalearn\1.png');


Iycbcr = double(rgb2ycbcr(I));
binUser = imread('ChalearnUser\U1.png');
for k = 1:3
    Iycbcr(:,:,k) = Iycbcr(:,:,k) .* binUser;
end

%% Find the initial hand
hand = find_hand(Iycbcr, meanGaussian, covarianceGaussian);

figure;
imshow(I);
hold on;
rec = rectangle('Position',hand,'EdgeColor', 'g');


%% Meros 2 Lukas Kanade algorithm


%% Test in Chalearn
for i=1:60
    path = strcat('Chalearn\',int2str(i),'.png');
    I1= imread(path);
    path = strcat('Chalearn\',int2str(i+1),'.png');
    I2= imread(path);
    path = strcat('ChalearnUser\U',int2str(i),'.png');
    U1= imread(path);
    path = strcat('ChalearnUser\U',int2str(i+1),'.png');
    U2= imread(path);
    new_hand = Lucas_Kanade(I1,I2,U1,U2,hand,i);
    fig=figure;
    imshow(I2);
    hold on;
    rec = rectangle('Position',hand,'EdgeColor', 'g');
    rec = rectangle('Position',new_hand,'EdgeColor', 'r');   
    hand=new_hand;
    saveas(fig,strcat('Multi_Scale_Images/Frames/frame',int2str(i),'.png'));
    close all
end





