function compute_kernel(dataset_path,size_codebook)

temp = load([dataset_path 'VS.mat']);
VS = temp.VS;
video_name = VS.vid;
number_video = length(VS.vid);
mkdir('./data/kernel_single_label');

split_rule = VS.test;

train_traj_histogram = [];
train_hog_histogram = [];
train_hof_histogram = [];
train_mbhx_histogram = [];
train_mbhy_histogram = [];

test_traj_histogram = [];
test_hog_histogram = [];
test_hof_histogram = [];
test_mbhx_histogram = [];
test_mbhy_histogram = [];

train_label = [];
test_label = [];

%1: traj , 2: hog, 3: hof, 4: mbhx, 5:mbhy
for i = 1:number_video
    disp(['Loading ' num2str(i) ' / '  num2str(number_video) ' traj encoding...']);
    if split_rule(i,1) ==0  % training set
        temp_video_name = video_name{i,1};
        load(['./data/dt_' num2str(size_codebook) '/' temp_video_name '.mat']);
        
        train_traj_histogram = [train_traj_histogram ; getHist(featHist(:,32), 1:length(featHist(:,32)), size_codebook)];
        train_hog_histogram = [ train_hog_histogram ; getHist(featHist(:,33), 1:length(featHist(:,33)), size_codebook)];
        train_hof_histogram = [train_hof_histogram ;  getHist(featHist(:,34), 1:length(featHist(:,34)), size_codebook)];
        train_mbhx_histogram = [train_mbhx_histogram ; getHist(featHist(:,35), 1:length(featHist(:,35)), size_codebook)];
        train_mbhy_histogram = [train_mbhy_histogram ; getHist(featHist(:,36), 1:length(featHist(:,36)), size_codebook)];
        
        
    elseif split_rule(i,1) ==1  % testing Set
        temp_video_name = video_name{i,1};
        load(['./data/dt_' num2str(size_codebook) '/' temp_video_name '.mat']);
        
        test_traj_histogram = [test_traj_histogram ;  getHist(featHist(:,32), 1:length(featHist(:,32)), size_codebook)];
        test_hog_histogram = [test_hog_histogram ; getHist(featHist(:,33), 1:length(featHist(:,33)), size_codebook)];
        test_hof_histogram = [test_hof_histogram ; getHist(featHist(:,34), 1:length(featHist(:,34)), size_codebook)];
        test_mbhx_histogram =[test_mbhx_histogram ;  getHist(featHist(:,35), 1:length(featHist(:,35)), size_codebook)];
        test_mbhy_histogram = [test_mbhy_histogram ; getHist(featHist(:,36), 1:length(featHist(:,36)), size_codebook)];
        
    end
end

train_histogram_cell = {train_traj_histogram ; train_hog_histogram ; train_hof_histogram ; train_mbhx_histogram ; train_mbhy_histogram};
test_histogram_cell = {test_traj_histogram ; test_hog_histogram ; test_hof_histogram ; test_mbhx_histogram ; test_mbhy_histogram};


%% Computing kerenl

train_kernel = rbfchi2_cell(train_histogram_cell, train_histogram_cell);
test_kernel = rbfchi2_cell(test_histogram_cell, train_histogram_cell);

save('./data/kernel.mat', 'train_kernel', 'test_kernel' , 'train_histogram_cell', 'test_histogram_cell');