function mbhyfeat_Clustering(k)
%% This script takes the sub-dataset and get the cluster centers
%%
% vlfeat
run('./vlfeat-0.9.17/toolbox/vl_setup.m');

load('./data/mbhy_subdataset.mat');
proData = cell2mat(mbhy_subdataset);

number_initialization = 8;

disp(['Perform K-means on mbhyfeat...']);
tic;
[centers,~] = vl_kmeans(proData',k, 'distance', 'l2', 'algorithm', 'elkan' , 'NumRepetitions', number_initialization,'Initialization', 'plusplus');
mkdir('./data/codebooks');
save(['./data/codebooks/mbhyfeat_kmeans.mat'], 'centers');
disp(['Time for mbhyfeat K-means: ' num2str(toc) ' seconds.']);
