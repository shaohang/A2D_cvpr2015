function construct_hist_set(dataset_path,number_clusters)

temp = load([dataset_path 'VS.mat']);
VS = temp.VS;
number_video = length(VS.vid);
mkdir(['./data/dt_' num2str(number_clusters)]);

matlabpool(30);
parfor i = 1:number_video
    % read in the mat file name
    vid_name = [VS.vid{i} '.mp4.mat'];
    
    % load dt info
    dt_info = load([dataset_path '/matfeat/dtinfo/' vid_name]);
    
    number_traj = size(dt_info.dtinfo,1);
    featHist = zeros(number_traj,36);
    
    featHist(:,1) = dt_info.dtinfo(:,1);
    % load traj location
    location = load([dataset_path '/matfeat/location/' vid_name]);
    
    featHist(:,2:31) = location.location;
    
    %32: traj , 33: hog, 34: hof, 35: mbhx, 36:mbhy
    % load traj encoding 
    traj_encode = load(['./data/encoding/dtfeat/' vid_name]);
    featHist(:,32) = traj_encode.idx;
    
    % load hog encoding 
    hog_encode = load(['./data/encoding/hogfeat/' vid_name]);
    featHist(:,33) = hog_encode.idx;
    
    % load hof encoding 
    hof_encode = load(['./data/encoding/hoffeat/' vid_name]);
    featHist(:,34) = hof_encode.idx;
    
    % load mbhx encoding 
    mbhx_encode = load(['./data/encoding/mbhxfeat/' vid_name]);
    featHist(:,35) = mbhx_encode.idx;
    
    % load mbhy encoding 
    mbhy_encode = load(['./data/encoding/mbhyfeat/' vid_name]);
    featHist(:,36) = mbhy_encode.idx;
    
    path = ['./data/dt_' num2str(number_clusters) '/' VS.vid{i} '.mat'];
    parsave_dt(path, featHist);
end
matlabpool close;
end

function parsave_dt(path, featHist)
    save(path, 'featHist');
end









