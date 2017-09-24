function [ bincounts ] = my_hist( features, centers )
%MY_HIST Summary of this function goes here
Distance = pdist2(features, centers);
[~, min_idx] = min(Distance,[],2);
bincounts = histc(min_idx, (1:size(centers,1)));
norm_L2 = norm(bincounts,2);
bincounts=bincounts ./ norm_L2;
end

