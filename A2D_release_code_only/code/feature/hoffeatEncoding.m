function hoffeatEncoding(dataset_path,ClusterNum)

load(['./data/codebooks/hoffeat_kmeans.mat'], 'centers');
centers = centers';
infodir = [dataset_path 'dtinfo'];
infolist = dir(fullfile(infodir, '*.mat'));
trajLen = 15;


dtdir = [dataset_path 'hoffeat'];
dtlist = dir(fullfile(dtdir, '*.mat'));
mkdir('./data/encoding');
mkdir('./data/encoding/hoffeat');   
matlabpool(30);
parfor id = 1 : length(dtlist)
    
    hof_temp = load(fullfile(dtdir, dtlist(id).name), 'hoffeat');
    hoffeat = hof_temp.hoffeat;
    
    [idx , dist] = knnsearch(centers, hoffeat,'k',1);
    
    dtinfo_temp = load(fullfile(infodir, infolist(id).name), 'dtinfo');
    dtinfo = dtinfo_temp.dtinfo;
    StInfo = dtinfo(:,8:10); % 8 col, 9 row, 10 time
%     load(['./encoding/dt/', dtlist(id).name], 'idx');
    
    enDtFeat = cell(6,1);
    
    h1v1t1 = getHist(idx, 1:1:length(idx), ClusterNum);
    enDtFeat{1,1} = h1v1t1;
    
    h31idx  = find(StInfo(:,2)<=1/3);
    h31v1t1 = getHist(idx, h31idx, ClusterNum);
    h32idx  = setdiff(find(StInfo(:,2)<=2/3), h31idx);
    h32v1t1 = getHist(idx, h32idx, ClusterNum);
    h33idx  = setdiff(1:1:length(idx), h31idx);
    h33idx  = setdiff(h33idx, h32idx);
    h33v1t1 = getHist(idx, h33idx, ClusterNum);
    enDtFeat{2,1} = [h31v1t1; h32v1t1; h33v1t1];

    h21v21idx = intersect(find(StInfo(:,1)<=1/2), find(StInfo(:,2)<=1/2));
    h21v21t1 = getHist(idx, h21v21idx, ClusterNum);
    h21v22idx = intersect(find(StInfo(:,1)<=1/2), find(StInfo(:,2)>1/2));
    h21v22t1 = getHist(idx, h21v22idx, ClusterNum);
    h22v21idx = intersect(find(StInfo(:,1)>1/2),  find(StInfo(:,2)<=1/2));
    h22v21t1 = getHist(idx, h22v21idx, ClusterNum);
    h22v22idx = intersect(find(StInfo(:,1)>1/2),  find(StInfo(:,2)>1/2));
    h22v22t1 = getHist(idx, h22v22idx, ClusterNum);
    enDtFeat{3,1} = [h21v21t1; h21v22t1; h22v21t1; h22v22t1];
    
    t1idx = find(StInfo(:,3)<=1/2);
    h1v1t21 = getHist(idx, t1idx, ClusterNum);
    t2idx = setdiff(find(StInfo(:,3)<=1), find(StInfo(:,3)<=1/2));
    h1v1t22 = getHist(idx, t2idx, ClusterNum);
    enDtFeat{4,1} = [h1v1t21; h1v1t22];

    h31t1idx = intersect(h31idx, t1idx);
    h31v1t1  = getHist(idx, h31t1idx, ClusterNum);
    h32t1idx = intersect(h32idx, t1idx);
    h32v1t1  = getHist(idx, h32t1idx, ClusterNum);
    h33t1idx = intersect(h33idx, t1idx);
    h33v1t1  = getHist(idx, h33t1idx, ClusterNum);
    
    h31t2idx = intersect(h31idx, t2idx);
    h31v1t2  = getHist(idx, h31t2idx, ClusterNum);
    h32t2idx = intersect(h32idx, t2idx);
    h32v1t2  = getHist(idx, h32t2idx, ClusterNum);
    h33t2idx = intersect(h33idx, t2idx);
    h33v1t2  = getHist(idx, h33t2idx, ClusterNum);
    enDtFeat{5,1} = [h31v1t1; h32v1t1; h33v1t1; h31v1t2; h32v1t2; h33v1t2];
    
    h21v21t1idx = intersect(h21v21idx, t1idx);
    h21v21t1    = getHist(idx, h21v21t1idx, ClusterNum);
    h21v22t1idx = intersect(h21v22idx, t1idx);
    h21v22t1    = getHist(idx, h21v22t1idx, ClusterNum);
    h22v21t1idx = intersect(h22v21idx, t1idx);
    h22v21t1    = getHist(idx, h22v21t1idx, ClusterNum);
    h22v22t1idx = intersect(h22v22idx, t1idx);
    h22v22t1    = getHist(idx, h22v22t1idx, ClusterNum);
    
    h21v21t2idx = intersect(h21v21idx, t2idx);
    h21v21t2    = getHist(idx, h21v21t2idx, ClusterNum);
    h21v22t2idx = intersect(h21v22idx, t2idx);
    h21v22t2    = getHist(idx, h21v22t2idx, ClusterNum);
    h22v21t2idx = intersect(h22v21idx, t2idx);
    h22v21t2    = getHist(idx, h22v21t2idx, ClusterNum);
    h22v22t2idx = intersect(h22v22idx, t2idx);
    h22v22t2    = getHist(idx, h22v22t2idx, ClusterNum);
    enDtFeat{6,1} = [h21v21t1; h21v22t1; h22v21t1; h22v22t1; ...
                     h21v21t2; h21v22t2; h22v21t2; h22v22t2];
    
    parsave(['./data/encoding/hoffeat/', dtlist(id).name], idx, enDtFeat);
end
matlabpool close;



