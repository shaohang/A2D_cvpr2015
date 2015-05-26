% build up script file
clear; close all;
%% Setting

% DT_bin_path = './improved_trajectory_release_focus/release/DenseTrackStab';
DT_bin_path = './improved_trajectory_release_retina/release/DenseTrackStab';
mkdir './commands'
system('mkdir ./dtfeature');
video_list = dir('./clips320H/*.mp4');
number_core = 30;


%%
number_video = size(video_list,1);
number_video_per_core = ceil(number_video/number_core);

for i = 1:number_core
    fid = fopen(['./commands/command_' num2str(i) '.sh' ], 'wt');
    for j = 1: number_video_per_core
        video_name_index = (i-1)*number_video_per_core+j;
        if video_name_index<=number_video
            fprintf(fid, [DT_bin_path    ' "./clips320H/' video_list(video_name_index).name   '"  > "./dtfeature/' video_list(video_name_index).name  '.txt"\n' ]);
        end
    end
    
    fclose(fid);
end


%% And then execute this command under the command prompt
% for i in $(seq 1 2); do . ./commands/command_$i.sh & done
