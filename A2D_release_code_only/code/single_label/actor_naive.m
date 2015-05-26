%% This function performs the action prediction by using Naive Bayes method
% Author: Shao-Hang Hsieh
function actor_naive(dataset_path,number_clusters)

load('./data/kernel.mat', 'train_kernel', 'test_kernel');
%% construct corresponding lables
load([dataset_path 'VS.mat']);
semantic_label = VS.label;

% ** just actor
semantic_label = floor(semantic_label/10);

number_video = length(semantic_label);
label_index = unique(semantic_label);  % transfer semantic label to 1 to 36
video_name = VS.vid;

all_label=  zeros(number_video,1);
for i =1: number_video
    all_label(i,1) = find(label_index==semantic_label(i,1));
end

test_video_name = VS.vid(VS.test);
split_rule = VS.test;
number_train = sum(split_rule==0);
number_test = sum(split_rule==1);

train_label = all_label(find(split_rule==0));
test_label = all_label(find(split_rule==1));


%% Training
number_active_class = length(label_index);
KernelMatrix_train =cat(2,(1:number_train)', train_kernel);
KernelMatrix_test = cat(2,(1:number_test)',test_kernel);

svm_model = cell(number_active_class,1);

% training stage
svm_model = cell(number_active_class,1);
for i = 1:number_active_class
    svm_model{i,1} = svmtrain(double(train_label==i), KernelMatrix_train, '-t 4 -c 10 -b 1 -q');
    [trainpredict_label, trainaccuracy, trainprob_estimates] = svmpredict(double(train_label==i), KernelMatrix_train, svm_model{i,1}, '-b 1 -q');
end

% testing stage
prob = zeros(length(test_label),number_active_class);
for i = 1:number_active_class
    [predict_label, test_accuracy, prob_estimates] = svmpredict(double(test_label==i), KernelMatrix_test, svm_model{i,1}, '-b 1 -q');
    prob(:,i) = prob_estimates(:,find(svm_model{i,1}.Label ==1))';
end

[~,prediction] = max(prob,[],2);
accuracy = sum(prediction==test_label)/ length(test_label);
disp(['Actor Test accuracy: ' num2str(accuracy)]);

confusion_matrix = zeros(number_active_class, number_active_class);
for i  = 1:number_active_class
    temp_idx = find(test_label ==i);
    for j = 1: length(temp_idx)
        confusion_matrix(i,prediction(temp_idx(j))) = confusion_matrix(i,prediction(temp_idx(j))) +1;
    end
end
confusion_matrix  = confusion_matrix ./ repmat(sum(confusion_matrix,2), 1,number_active_class);

actor_prediction = prediction;
save('./data/actor_prediction.mat', 'actor_prediction', 'prob','test_label');
