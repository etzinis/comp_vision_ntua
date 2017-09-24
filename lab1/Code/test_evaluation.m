clear; clc;
% simple example of calling anonymous functions for evaluation

% add path of detectors if necessary
addpath(genpath('C:\Users\Konstantinos\Desktop\8o Examhno\VISION\1h Ergasthriakh'));
addpath(genpath('descriptors'));

%% Corner Detection for one scales
% s=2;
% r=2.5;
% k = 0.007;
% thetacorn = 0.01;
% detector_func = @(L) corner_one_scale( L,s,r,k,thetacorn );


%% Corner Detection for many scales
% N=4;
% k=0.001;
% s0=2.3;
% r0=1;
% scale=1.85;
% thetacorn = 0.01;
% detector_func = @(L) corner_many_scales( L,N,k,s0,r0,scale,thetacorn);

%% Blob Detection for one scale
% threshold = 0.12;
% s = 2;
% detector_func = @(L) blob_one_scale( L, s, threshold );

%% Blob Detection for many scales
N=4;
s0=2;
scale=1.85;
threshold = 0.07;
detector_func = @(L) blob_many_scales( L, s0,scale, threshold,N );

%% Box Filters for many scales
% N = 4;
% s0 = 2.5;
% scale = 1.78;
% detector_func = @(L) box_filters_many_scales( L, N, s0,scale );


% example of anonymous function for extracting the SURF features
descriptor_func = @(I,points) featuresSURF(I,points);
%descriptor_func = @(I,points) featuresHOG(I,points);

% get the requested errors, one value for each image in the dataset 
[scale_error,theta_error] = evaluation(detector_func,descriptor_func);