function actor_action_naive(dataset_path)

load([dataset_path 'VS.mat']);
load('./data/action_prediction.mat');
load('./data/actor_prediction.mat');
split_rule = VS.test;


combine_test_label = VS.label(split_rule);
combine_prediction = (actor_prediction*10) + action_prediction;

accuracy = sum(combine_prediction==VS.label(split_rule))/ length(VS.label(split_rule));
disp(['<A,A> Test accuracy: ' num2str(accuracy)]);

save('./data/NB_prediction.mat', 'combine_prediction', 'combine_test_label');