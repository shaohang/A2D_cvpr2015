%% This function performs the action prediction by using Naive Bayes method
% Author: Shao-Hang Hsieh
function actor_action_tri_ml(dataset_path)

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
number_active_class = size(multi_label_table,2);

%% Energy mininization
action_prob = load('./data/action_prob_ml.mat');
actor_prob = load('./data/actor_prob_ml.mat');
load('./data/joint_prediction_ml.mat');

action_prob.prob = action_prob.prob./repmat((sum(action_prob.prob,2)/size(action_prob.prob,2)), 1, size(action_prob.prob,2));
actor_prob.prob = actor_prob.prob./repmat((sum(actor_prob.prob,2)/size(actor_prob.prob,2)), 1, size(actor_prob.prob,2));

action_prob.prob = -log(action_prob.prob+eps);
actor_prob.prob = -log(actor_prob.prob+eps);

log_prob = -log(prob);

alpha = 1;
alpha_action = 0.75;
alpha_actor = 1;

new_energy = zeros(number_test,number_active_class );
for i  = 1:number_active_class
    action_idx = mod(class_idx(i),10);
    actor_idx = floor(class_idx(i)/10);

    new_energy(:,i) = (alpha_actor*action_prob.prob(:,action_idx) + alpha_action*actor_prob.prob(:,actor_idx)) + alpha*log_prob(:,i);
end

%% <A,A> Prediction

average_precision = zeros(number_active_class,1);
for i  = 1:number_active_class
    [rec,prec,average_precision(i,1)] = TH14eventclspr(-new_energy(:,i),test_label(:,i));
end
mean_average_precision = sum(average_precision)/number_active_class;
disp(['<A,A> Mean Average Precision(Tri): ' num2str(mean_average_precision)]);


%% Action Prediction
number_action = 8;
prob_action = zeros(number_test, number_action);
action_label = zeros(number_test, number_action);


for i = 1:number_action
    temp_idx = find(mod(class_idx,10)==i);
    for j = 1: number_test

        % average
        prob_action(j,i) = sum(exp(-new_energy(j,temp_idx)))/length(temp_idx);


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
disp(['Action Mean Average Precision(Tri): ' num2str(action_mAP)]);

%% Actor Prediction
number_actor = 7;
prob_actor = zeros(number_test, number_actor);
actor_label = zeros(number_test, number_actor);


for i = 1:number_actor
    temp_idx = find(floor(class_idx/10)==i);
    for j = 1: number_test
        % average
        prob_actor(j,i) = sum(exp(-new_energy(j,temp_idx)))/length(temp_idx);


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
disp(['Actor Mean Average Precision(Tri): ' num2str(actor_mAP)]);

    










