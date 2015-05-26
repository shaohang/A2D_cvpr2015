function sample_trajectory(dataset_path,number_core)
%% this scrip generate the indeices of sample trajectories from the overall dataset

% index of each trajctories and gether information
file_list = dir([dataset_path 'dtinfo/' '*.mat']);
system('mkdir ./data');

num_file = length(file_list);

% >>>>>>
num_traj = 0;
cunum_traj_file = zeros(num_file,1);  % this stores the cumulative number of trajectories of each file
index_traj = cell(num_file,1);
tic;
disp(['Indexing Trajectories....'])
for i = 1:num_file
%     disp(['Indexing the ' num2str(i) ' / ' num2str(num_file)]);
    load([dataset_path 'dtinfo/' file_list(i).name]);
    if isempty(dtinfo)~=1
        cunum_traj_file(i) = num_traj+1;
    
        index_traj{i,1} = cat(2,((num_traj+1):( num_traj + size(dtinfo,1)))', ones(size(dtinfo,1),1)*i);
        num_traj = num_traj + size(dtinfo,1);
    else
        disp('    Empty file, skip!')
    end
     
end
disp(['Indexing done. Time for indexing trajectories: ' num2str(toc) ' seconds.']);
% <<<<<<

save('./data/index_traj.mat', 'index_traj', 'cunum_traj_file');
% load('./data/index_traj.mat');
%% construct the sampled dataset
% permute the index to have random selection
num_sample = 100000;
disp([' Number of samples: ' num2str(num_sample)]);
index_traj = cell2mat(index_traj);
num_traj = size(index_traj,1);
selection = sort(randperm(num_traj, num_sample))';

% read the trajectories from each file
select_file = unique(index_traj(selection,2));
num_select_file = length(select_file);
select_traj = index_traj(selection,:);

tic;
dt_subdataset = cell(num_file,1);
hog_subdataset = cell(num_file,1);
hof_subdataset = cell(num_file,1);
mbhx_subdataset = cell(num_file,1);
mbhy_subdataset = cell(num_file,1);

matlabpool(number_core);
disp('Constructing sub-dataset...');
parfor i = 1: num_file
%     disp(['Constructing the ' num2str(i) ' / ' num2str(num_file)]);
    if isempty(find(i==select_file))~=1
        temp_dt = load([dataset_path 'dtfeat/' file_list(i).name]);
        temp_hog = load([dataset_path 'hogfeat/' file_list(i).name]);
        temp_hof = load([dataset_path 'hoffeat/' file_list(i).name]);
        temp_mbhx = load([dataset_path 'mbhxfeat/' file_list(i).name]);
        temp_mbhy = load([dataset_path 'mbhyfeat/' file_list(i).name]);
        
        
        temp_index_traj = select_traj(find(select_traj(:,2)==i),:);
        temp_index_traj(:,1) = temp_index_traj(:,1)- cunum_traj_file(i)+1;
        
        dt_subdataset{i,1} = temp_dt.dtfeat(temp_index_traj(:,1),:);
        hog_subdataset{i,1} = temp_hog.hogfeat(temp_index_traj(:,1),:);
        hof_subdataset{i,1} = temp_hof.hoffeat(temp_index_traj(:,1),:);
        mbhx_subdataset{i,1} = temp_mbhx.mbhxfeat(temp_index_traj(:,1),:);
        mbhy_subdataset{i,1} = temp_mbhy.mbhyfeat(temp_index_traj(:,1),:);
    end 
end
matlabpool close;
disp(['Time for constructing sub-dataset: ' num2str(toc) ' seconds.']);

save('./data/dt_subdataset.mat', 'dt_subdataset','select_traj','selection','-v7.3');
save('./data/hog_subdataset.mat', 'hog_subdataset','select_traj','selection','-v7.3');
save('./data/hof_subdataset.mat', 'hof_subdataset','select_traj','selection','-v7.3');
save('./data/mbhx_subdataset.mat', 'mbhx_subdataset','select_traj','selection','-v7.3');
save('./data/mbhy_subdataset.mat', 'mbhy_subdataset','select_traj','selection','-v7.3');












