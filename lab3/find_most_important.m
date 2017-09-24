function [ points_subs ] = find_most_important( H, most_important )
%FIND_MOST_IMPORTANT Summary of this function goes here
%   Detailed explanation goes here
H_size = size(H);

%Hvec = reshape(H, [], 1);
[~, Ind] = sort(H(:), 'descend');

points_ind = Ind(1:most_important);
[points_subs(:,2), points_subs(:,1), points_subs(:,4)] = ind2sub(H_size, points_ind);
points_subs(:,3) = (1:most_important) * 0 +0.5;

end

