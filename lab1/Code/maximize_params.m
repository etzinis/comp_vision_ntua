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

%TODO Find the correct values and explain
%TODO find s, thetaedge for all noises and laplcae types


%% 1.3.1
B=strel('disk',1);
thetarealedge=0.1; %trial and error
M=imdilate(I,B)-imerode(I,B);
T=M>thetarealedge;
imshow(T);

starting_values = [1.3, 0.18; 1.85, 0.26; ];


for K=1:2
smax(K) = 0;
thetamax(K) = 0;
C(K) = 0;
    for K2 = -10:10
        display(K2);
        curr_s = starting_values(K,1) + K2 * 0.1;
        for K3 = -20:20
            curr_t = starting_values(K,2) + K3 * 0.01;
            D(:,:,K) = EdgeDetect(noise(:,:,K), curr_s, curr_t, 1);
            DandT(:,:)=D(:,:,K) & T(:,:);
            Precision(K)=sum(DandT)/sum(T);
            Recall(K) =sum(DandT(:,:))/sum(D(:,:,K));
            curr_C = (Precision(K) + Recall(K)) /2;
            if(curr_C > C(K))
                C(K) = curr_C;
                smax(K) = curr_s;
                thetamax(K) = curr_t;
            end;
        end;
    end;
    display(C(K));
    display(smax(K));
    display(thetamax(K));
end;

