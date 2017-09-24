clear all; clc; close all;
%% Ergasthrio 3o %%

total_videos = 9;
most_important = 300;
frame_count = 300;
points_subs = zeros(most_important * total_videos, 4);

for i=1:9
    %% Read Input
    switch i
        case 1
            L = readVideo('material/samples/boxing/person01_boxing_d1_uncomp.avi', frame_count,0);
        case 2
            L = readVideo('material/samples/boxing/person06_boxing_d4_uncomp.avi', frame_count,0);
        case 3
            L = readVideo('material/samples/boxing/person18_boxing_d3_uncomp.avi', frame_count,0);
        case 4
            L = readVideo('material/samples/running/person01_running_d3_uncomp.avi', frame_count,0);
        case 5
            L = readVideo('material/samples/running/person04_running_d1_uncomp.avi', frame_count,0);
        case 6
            L = readVideo('material/samples/running/person07_running_d1_uncomp.avi', frame_count,0);
        case 7
            L = readVideo('material/samples/walking/person01_walking_d2_uncomp.avi', frame_count,0);
        case 8
            L = readVideo('material/samples/walking/person06_walking_d3_uncomp.avi', frame_count,0);
        case 9
            L = readVideo('material/samples/walking/person11_walking_d2_uncomp.avi', frame_count,0);
        otherwise
            display('We are doomed :)');
    end;

    %% Choose a Detector
    
    %H = Harris_Detector(L);
    H = Gabor_Detector(L);
    %% Find most important voxels

    temp_points_subs = find_most_important(H, most_important);
    points_subs((i-1)*most_important + 1 : i*most_important,:) = find_most_important(H, most_important);
    %showDetection(L, temp_points_subs);
    display('Progress: Finished video');
    display(i);
    
    
end


%% Meros 2o


r = 1;
epsilon = 0.02;


optical_flow = zeros(size(H,1), size(H,2), size(H,3), 2);
image_gradient = zeros(size(H,1), size(H,2), size(H,3), 2);


doubleL = im2double(L);
[ image_gradient(:,:,:,1), image_gradient(:,:,:,2)] = gradient(doubleL(:,:,:));

% Hof
for i=1:most_important*total_videos
    
    point = points_subs(i,:);
    x0 = point(1);
    y0 = point(2);
    s0 = point(3);
    t0 = min(point(4), frame_count-1);
    
    % Bound checking, dx0 dy0 set
    x_area = max([x0-ceil(30*s0),1]):min([x0+ceil(30*s0), size(H,2)]);
    y_area = max([y0-ceil(30*s0),1]):min([y0+ceil(30*s0), size(H,1)]);
    dx0 = zeros(length(y_area), length(x_area));
    dy0 = dx0;
    
    [dx, dy] = lk(L(y_area,x_area,t0), L(y_area,x_area,t0+1), r, epsilon, dx0, dy0);
    optical_flow(y_area,x_area,t0,1) = dx; 
    optical_flow(y_area,x_area,t0,2) = dy;
    
    display('First Loop');
    display(i);
end

%% Orientation Histogram
bins = 4;
grid = [3 3];
% Uncomment the next line for only one of HOG / HOF
%histograms = zeros(length(frame_count), bins*grid(1)*grid(2));
% Uncomment the next line for both of HOG / HOF
%histograms = zeros(2*length(frame_count), bins*grid(1)*grid(2));
histograms = zeros(length(frame_count), 2*bins*grid(1)*grid(2));
% TODO: Check if this is correct -> We concat the histograms horizontaly
for i=1:most_important*total_videos
    
    point = points_subs(i,:);
    x0 = point(1);
    y0 = point(2);
    s0 = point(3);
    t0 = min(point(4), frame_count-1);
    
    % Bound checking
    x_area = max(x0-ceil(30*s0),1):min(x0+ceil(30*s0), size(H,2));
    y_area = max(y0-ceil(30*s0),1):min(y0+ceil(30*s0), size(H,1));
    
    dx = optical_flow(y_area,x_area,t0,1); 
    dy = optical_flow(y_area,x_area,t0,2);

    desc = OrientationHistogram( dx, dy, bins, grid);
    histograms(i,(1:bins*grid(1)*grid(2))) = desc;
    %histograms(2*i - 1,:) = desc;
    
    dx = image_gradient(y_area,x_area,t0,1); 
    dy = image_gradient(y_area,x_area,t0,2);

    desc = OrientationHistogram( dx, dy, bins, grid);
    histograms(i,(bins*grid(1)*grid(2)+1:2*bins*grid(1)*grid(2))) = desc;
    %histograms(2* i,:) = desc;

    display('Second Loop');
    display(i);

end

%% BoVW

cluster_number = 20;


% Create the vector matrix
vectors = histograms;
N = size(vectors,1);
curr_vectors = vectors;

% Cluster the data using the kmeans algorithm
% Becareful and uncomment this
[~,centers] = kmeans(curr_vectors, cluster_number, 'MaxIter', 1000);


% Find min distance of points to clusters
% BOF = zeros(size(histograms,1), cluster_number);
% for i=1:size(histograms,1)
%     BOF(i,:) = my_hist(histograms(i,:), centers);
% end

BOF = zeros(total_videos, cluster_number*total_videos);
for i=1:total_videos
    
    % 1st wrong second correct?
    BOF(i,:) = my_hist(histograms((i-1)*most_important+1:i*most_important,:), centers);
    %BOF(i,:) = my_hist(histograms(2*(i-1)*most_important+1:2*i*most_important,:), centers);
end


%% Linkage and dendrogram
tree = linkage(BOF, 'average', 'distChiSq');
labels = ['Box_1'; 'Box_2'; 'Box_3'; 'Run_1'; 'Run_2'; 'Run_3'; 'Wlk_1'; 'Wlk_2'; 'Wlk_3'];
dendrogram(tree, 'Labels', labels);



