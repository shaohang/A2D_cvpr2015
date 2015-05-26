%% This function performs the action prediction by using Naive Bayes method
% Author: Shao-Hang Hsieh
function action_naive_multilable(dataset_path,number_clusters)



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

%%
% revise multi-label table
train_label = multi_label_table(find(split_rule==0),:);
test_label = multi_label_table(find(split_rule==1),:);

number_action = 8;
actor_train_label = zeros(number_train, number_action);
actor_test_label = zeros(number_test, number_action);
for i = 1:number_action
    temp_idx = find(mod(class_idx,10)==i);
    for j = 1:number_train
        if isempty(find(train_label(j,temp_idx)==1))~=1
            action_train_label(j,i) = 1;
        end
    end
    
    for j = 1: number_test
        if isempty(find(test_label(j,temp_idx)==1))~=1
            action_test_label(j,i) = 1;
        end
    end
end

train_label = action_train_label;
test_label = action_test_label;

%% Training
load('./data/kernel.mat', 'train_kernel', 'test_kernel');

number_active_class = size(train_label,2);
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
action_predict_label = zeros(size(test_label,1),number_active_class);
for i = 1:number_active_class
    [predict_label, test_accuracy, prob_estimates] = svmpredict(double(test_label(:,i)), KernelMatrix_test, svm_model{i,1}, '-b 1 -q');
    prob(:,i) = prob_estimates(:,find(svm_model{i,1}.Label ==1))';
    action_predict_label(:,i) = predict_label;
end

%% Compute mAP
average_precision = zeros(number_active_class,1);
for i  = 1:number_active_class
    [rec,prec,average_precision(i,1)] = TH14eventclspr(prob(:,i),test_label(:,i));
end
mean_average_precision = sum(average_precision)/number_active_class;
disp(['Action Mean Average Precision(NB): ' num2str(mean_average_precision)]);
save('./data/action_prob_ml.mat', 'prob', 'action_predict_label');




