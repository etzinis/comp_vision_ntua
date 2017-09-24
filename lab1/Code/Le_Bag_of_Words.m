function [ BOF_tr, BOF_ts ] = Le_Bag_of_Words( data_train,data_test )
cluster_number = 500;
percentage_kept = 0.2;

% Create the vector matrix
vectors = cell2mat(data_train');
N = size(vectors,1);

% Randomly sample about half of it
random_indexes = randsample((1:N),floor(N*percentage_kept));
curr_vectors = vectors(random_indexes,:);

% Cluster the data using the kmeans algorithm
[~,centers] = kmeans(curr_vectors, cluster_number);


%%
% Find min distance of points to clusters
BOF = cellfun(@(x) my_hist(x,centers),data_train,'UniformOutput',false);
BOF_tr = cell2mat(BOF)';

%% For the test file
BOF = cellfun(@(x) my_hist(x,centers),data_test,'UniformOutput',false);
BOF_ts = cell2mat(BOF)';

end

