%% =============Computer Vision Lab 1=================== 
close all;
clear all;
%% 1.1.1
I=imread('cv16_lab1_material\edgetest_16.png');
I=im2double(I);

%% 1.1.2
Imax=max(max(I));
Imin=min(min(I));
PSNR(1)=20;
PSNR(2)=10;
sn(1)=(Imax-Imin)/(10^(PSNR(1)/20));
noise(:,:,1)=imnoise(I,'gaussian',0,sn(1)^2);
sn(2)=(Imax-Imin)/(10^(PSNR(2)/20));
noise(:,:,2)=imnoise(I,'gaussian',0,sn(2)^2);

%imshow(noise(:,:,1));
%imshow(noise(:,:,2));

%Oi parametroi brethikan me th xrhsh tou maximize_params.m
D(:,:,1) = EdgeDetect(noise(:,:,1), 1.3, 0.19, 0);
figure();
imshow(D(:,:,1));
D(:,:,2) = EdgeDetect(noise(:,:,1), 1.3, 0.18, 1);
figure();
imshow(D(:,:,2));
D(:,:,3) = EdgeDetect(noise(:,:,2), 1.7, 0.28, 0);
figure();
imshow(D(:,:,3));
D(:,:,4) = EdgeDetect(noise(:,:,2), 1.9, 0.26, 1);
figure();
imshow(D(:,:,4));


%% 1.3.1
B=strel('disk',1);
thetarealedge=0.1; 
M=imdilate(I,B)-imerode(I,B);
T=M>thetarealedge;
imshow(T);
%% 1.3.2
for K=1:4
    DandT(:,:)=D(:,:,K) & T(:,:);
    Recall(K)=sum(DandT)/sum(T);
    Precision(K) =sum(DandT(:,:))/sum(D(:,:,K));
    C(K) = (Precision(K) + Recall(K)) /2;
    display(Precision(K));
    display(Recall(K));
    display(C(K));
end;
