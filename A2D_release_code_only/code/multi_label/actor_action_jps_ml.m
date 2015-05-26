%% This function performs the action prediction by using Naive Bayes method
% Author: Shao-Hang Hsieh
function actor_action_jps_ml(dataset_path,number_clusters)


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

%% Training
load('./data/kernel.mat', 'train_kernel', 'test_kernel');

train_label = multi_label_table(find(split_rule==0),:);
test_label = multi_label_table(find(split_rule==1),:);

number_active_class = size(multi_label_table,2);
KernelMatrix_train =cat(2,(1:number_train)', train_kernel);
KernelMatrix_test = cat(2,(1:number_test)',test_kernel);

svm_model = cell(number_active_class,1);

% training stage
svm_model = cell(number_active_class,1);
for i = 1:number_active_class
    svm_model{i,1} = svmtrain(double(train_label(:,i)), KernelMatrix_train, '-t 4 -c 10 -b 1 -q');
end

% testing stage
prob = zeros(size(test_label,1),number_active_class);
for i = 1:number_active_class
    [predict_label, test_accuracy, prob_estimates] = svmpredict(double(test_label(:,i)), KernelMatrix_test, svm_model{i,1}, '-b 1 -q');
    prob(:,i) = prob_estimates(:,find(svm_model{i,1}.Label ==1))';
end

save('./data/joint_prediction_ml.mat','prob', 'test_label');

%% Compute mAP
average_precision = zeros(number_active_class,1);
for i  = 1:number_active_class
    [rec,prec,average_precision(i,1)] = TH14eventclspr(prob(:,i),test_label(:,i));
end
mean_average_precision = sum(average_precision)/number_active_class;
disp(['<A,A> Mean Average Precision(JPS): ' num2str(mean_average_precision)]);

%% Action mAP
number_action = 8;
prob_action = zeros(number_test, number_action);
action_label = zeros(number_test, number_action);


for i = 1:number_action
    temp_idx = find(mod(class_idx,10)==i);
    for j = 1: number_test
        
        % average
        prob_action(j,i) = sum(prob(j,temp_idx))/length(temp_idx);
        
        if isempty(find(test_label(j,temp_idx)==1))~=1
            action_label(j,i) = 1;
        end
    end
end

action_ap = zeros(number_action,1);
for i = 1: number_action
    [rec,prec,action_ap(i,1)] = TH14eventclspr(prob_action(:,i),action_label(:,i));
end
action_mAP = sum(action_ap)/number_action;
disp(['Action Mean Average Precision(JPS): ' num2str(action_mAP)]);

%% Actor mAP
number_actor = 7;
prob_actor = zeros(number_test, number_actor);
actor_label = zeros(number_test, number_actor);


for i = 1:number_actor
    temp_idx = find(floor(class_idx/10)==i);
    for j = 1: number_test
        
        % average
        prob_actor(j,i) = sum(prob(j,temp_idx))/length(temp_idx);

        if isempty(find(test_label(j,temp_idx)==1))~=1
            actor_label(j,i) = 1;
        end
    end
end

actor_ap = zeros(number_actor,1);
for i = 1: number_actor
    [rec,prec,actor_ap(i,1)] = TH14eventclspr(prob_actor(:,i),actor_label(:,i));
end
actor_mAP = sum(actor_ap)/number_actor;
disp(['Actor Mean Average Precision(JPS): ' num2str(actor_mAP)]);








