function actor_action_tri(dataset_path)

%%
load([dataset_path 'VS.mat']);
action_prediction = load('./data/action_prediction.mat');
actor_prediction = load('./data/actor_prediction.mat');
joint_prediction = load('./data/joint_prediction.mat');

%%
split_rule = VS.test;
semantic_label = VS.label;

number_video = length(semantic_label);
label_index = unique(semantic_label);  % transfer semantic label to 1 to 36

number_train = sum(split_rule==0);
number_test = sum(split_rule==1);

all_label=  zeros(number_video,1);
for i =1: number_video
    all_label(i,1) = find(label_index==semantic_label(i,1));
end

train_label = all_label(find(split_rule==0));
test_label = all_label(find(split_rule==1));

semantic_label = VS.label;
label_index = unique(semantic_label);
number_active_class = length(label_index);

%%
action_prediction.prob = -log(action_prediction.prob);
actor_prediction.prob = -log(actor_prediction.prob);
log_prob = -log(joint_prediction.prob);

alpha = 2;
new_energy = zeros(number_test,number_active_class );
for i  = 1:number_active_class
    action_idx = mod(label_index(i),10);
    actor_idx = floor(label_index(i)/10);

    new_energy(:,i) = (action_prediction.prob(:,action_idx) + actor_prediction.prob(:,actor_idx)) + alpha*log_prob(:,i);
end

[score,prediction] = min(new_energy,[],2);
accuracy = sum(prediction==test_label)/ length(test_label);
disp(['<A,A> test accuracy: ' num2str(accuracy)]);




%** action label prediction
action_label = mod(label_index(test_label),10);
action_prediction2 = mod(label_index(prediction),10);

accuracy = sum(action_prediction2 ==action_label)/ length(action_label);
disp(['Action Test accuracy: ' num2str(accuracy)]);


%** actor label prediction
actor_label = floor(label_index(test_label)/10);
actor_prediction2 = floor(label_index(prediction)/10);

accuracy = sum(actor_prediction2 ==actor_label)/ length(actor_label);
disp(['Actor Test accuracy: ' num2str(accuracy)]);



