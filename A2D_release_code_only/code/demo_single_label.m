% This script is the demo of the Action_Actor paper
% Author: Shao-Hang Hsieh
% Date: 3/12/2015
%% Setting :

%  Modify the dataset path to the dataset
dataset_path = './../dataset/';
mat_path = [dataset_path '/matfeat/'];

% the size of codebooks
number_clusters = 4000;

% number of workers when using parfor
number_core = 30;

run('./vlfeat-0.9.17/toolbox/vl_setup.m');
construct_hist = false;

addpath('./feature');
addpath('./single_label');

%% Constructing Histogram for each video
if construct_hist   
    % Sampling Trajectories and construct sub-dataset
    sample_trajectory(mat_path,number_core);

    % K-means clustering
    dtfeat_Clustering(number_clusters);
    hoffeat_Clustering(number_clusters);
    hogfeat_Clustering(number_clusters);
    mbhxfeat_Clustering(number_clusters);
    mbhyfeat_Clustering(number_clusters);


    % Encoding
    disp(['Performing dt Encoding...']);
    tic;
    dtEncoding(mat_path,number_clusters);
    disp(['Time for dtfeat Encoding: ' num2str(toc/60) ' mins.']);

    disp(['Performing hof Encoding...']);
    tic;
    hoffeatEncoding(mat_path,number_clusters);
    disp(['Time for hof Encoding: ' num2str(toc/60) ' mins.']);

    disp(['Performing hog Encoding...']);
    tic;
    hogfeatEncoding(mat_path,number_clusters);
    disp(['Time for hog Encoding: ' num2str(toc/60) ' mins.']);

    disp(['Performing mbhx Encoding...']);
    tic;
    mbhxfeatEncoding(mat_path,number_clusters);
    disp(['Time for mbhx Encoding: ' num2str(toc/60) ' mins.']);

    disp(['Performing mbhy Encoding...']);
    tic;
    mbhyfeatEncoding(mat_path,number_clusters);
    disp(['Time for mbhy Encoding: ' num2str(toc/60) ' mins.']);
    
    % This function constructs the histogram for training/testing set
    construct_hist_set(dataset_path,number_clusters); 
    % Compute kernels
    compute_kernel(dataset_path,number_clusters);
    
end

%% Naive Bayes Method
disp('***** Naive Bayes Method *****');
% Action Prediction
action_naive(dataset_path,number_clusters);

% Actor Prediction
actor_naive(dataset_path,number_clusters);

% <Action,Actor> prediction by combining above results
actor_action_naive(dataset_path);

fprintf('\n\n');

%% Joint product space
disp('***** Joint product space Method *****');
% <Actor,Action> product space prediction
actor_action_jps(dataset_path,number_clusters);

fprintf('\n\n');

%% Trilayer Model
disp('***** Trilayer Model *****');
actor_action_tri(dataset_path);





