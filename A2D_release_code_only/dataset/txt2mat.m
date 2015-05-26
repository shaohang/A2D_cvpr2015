clear, close all;


srcpath = './dtfeature';
dstpath = './matfeat';
mkdir(dstpath);
mkdir(fullfile(dstpath, 'dtinfo'));
mkdir(fullfile(dstpath, 'dtfeat'));
mkdir(fullfile(dstpath, 'hogfeat'));
mkdir(fullfile(dstpath, 'hoffeat'));
mkdir(fullfile(dstpath, 'mbhxfeat'));
mkdir(fullfile(dstpath, 'mbhyfeat'));
mkdir(fullfile(dstpath, 'location'));
% mkdir(fullfile(dstpath, 'dt_whole'));

srclist = dir(fullfile(srcpath, '*.txt'));

delimiter = '\t';
matlabpool(30);
number_file = length(srclist);
parfor id = 1 : number_file
%     id 
 
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
    fileID = fopen(fullfile(srcpath, srclist(id).name),'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
    fclose(fileID);
    dataArray = dataArray(1:end-1);
    dataArray = cell2mat(dataArray);
    dtinfo   = dataArray(:,   1:10); % 10
    dtfeat   = dataArray(:, 11: 40); % 62 = 30 + 32
    hogfeat  = dataArray(:, 41:136); % 96
    hoffeat  = dataArray(:,137:244); % 108
    mbhxfeat = dataArray(:,245:340); % 96
    mbhyfeat = dataArray(:,341:436); % 96
    location = dataArray(:,437:466); % 30
    dt_whole = cat(2, dtfeat,hogfeat, hoffeat, mbhxfeat, mbhyfeat);
    
    parsave([dstpath   '/dtinfo/'   [srclist(id).name(1:end-4)  '.mat']], 'dtinfo' ,dtinfo);
    parsave([dstpath, '/dtfeat/',  [srclist(id).name(1:end-4), '.mat']], 'dtfeat', dtfeat);
    parsave([dstpath, '/hogfeat/', [srclist(id).name(1:end-4), '.mat']],  'hogfeat',hogfeat);
    parsave([dstpath, '/hoffeat/', [srclist(id).name(1:end-4), '.mat']], 'hoffeat' ,hoffeat);
    parsave([dstpath, '/mbhxfeat/',[srclist(id).name(1:end-4), '.mat']], 'mbhxfeat',mbhxfeat);
    parsave([dstpath, '/mbhyfeat/',[srclist(id).name(1:end-4), '.mat']],'mbhyfeat' ,mbhyfeat);
    parsave([dstpath, '/location/',[srclist(id).name(1:end-4), '.mat']], 'location',location);
%     parsave([dstpath, '/dt_whole/',[srclist(id).name(1:end-4), '.mat']],'dt_whole', dt_whole);
    
%     save(fullfile(dstpath, 'dtinfo',  [srclist(id).name(1:end-4), '.mat']), 'dtinfo');
%     save(fullfile(dstpath, 'dtfeat',  [srclist(id).name(1:end-4), '.mat']), 'dtfeat');
%     save(fullfile(dstpath, 'hogfeat', [srclist(id).name(1:end-4), '.mat']), 'hogfeat');
%     save(fullfile(dstpath, 'hoffeat', [srclist(id).name(1:end-4), '.mat']), 'hoffeat');
%     save(fullfile(dstpath, 'mbhxfeat',[srclist(id).name(1:end-4), '.mat']), 'mbhxfeat');
%     save(fullfile(dstpath, 'mbhyfeat',[srclist(id).name(1:end-4), '.mat']), 'mbhyfeat');
%     save(fullfile(dstpath, 'location',[srclist(id).name(1:end-4), '.mat']), 'location');
%     save(fullfile(dstpath, 'dt_whole',[srclist(id).name(1:end-4), '.mat']), 'dt_whole');
    
    %delete(fullfile(srcpath, srclist(id).name));
   
end
matlabpool close;
%finish_music();

% discriptor setting : 1~10 are the information about the trajectory (10)
%                               11~40  trajectory discriptor (30)
%                               41~136 HOG (96)
%                               137~244 HOF (108)
%                               245~340 MBHx (96)
%                               341~436 MBHy (96)
