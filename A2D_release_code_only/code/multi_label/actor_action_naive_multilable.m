%% This function performs the action prediction by using Naive Bayes method
% Author: Shao-Hang Hsieh
function actor_action_naive_multilable(dataset_path,number_clusters)


%% construct corresponding lables
load('./data/multi_label.mat');
load('./../dataset/VS.mat');
number_video = size(multi_label_table,1);
video_name = VS.vid;
class_idx = unique(VS.label);
split_rule = VS.test;
test_prune_label = prune_label(split_rule);

split_rule = VS.test;
number_train = sum(split_rule==0);
number_test = sum(split_rule==1);

%% Combine the results
actor_prob = load('./data/actor_prob_ml.mat');
action_prob = load('./data/action_prob_ml.mat');

test_multi_label_table = multi_label_table(split_rule,:);
combine_prob = zeros(number_test,length(class_idx));

for i = 1:length(class_idx)
    temp_class = class_idx(i);
    combine_prob(:,i) = actor_prob.prob(:,floor(temp_class/10)).*action_prob.prob(:,mod(temp_class,10));
end

combine_ap = zeros(length(class_idx),1);
for i  = 1:length(class_idx)
    [rec,prec,combine_ap(i,1)] = TH14eventclspr(combine_prob(:,i),test_multi_label_table(:,i));
end
combine_mAP = sum(combine_ap)/length(class_idx);
disp(['<A,A> Mean Average Precision(NB): ' num2str(combine_mAP)]);







