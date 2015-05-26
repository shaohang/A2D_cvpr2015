function preprocess_label()
% Preprocess the label into multilabel format 
load('./../dataset/SB.mat');
load('./../dataset/VS.mat');

origin_label = SB.labelList; 
prune_label = cell(length(origin_label),1);

for i = 1: length(origin_label)
    temp_label = origin_label{i,1};
    temp_label(find(temp_label==1)) = [];
    if isempty(find(mod(temp_label,10)==9))~=1
        temp_label(find(mod(temp_label,10)==9))=[];
    end
    
    % union VS. label to avoid empty label
    prune_label{i,1} = union(temp_label, VS.label(i));
end

% also build up multi-label table
class_idx = unique(VS.label);
number_class = length(class_idx);
multi_label_table = zeros(length(origin_label),number_class);


for i  = 1: length(origin_label)
    temp_label = prune_label{i,1};
    for j = 1:length(temp_label)
        multi_label_table(i,find(class_idx==temp_label(j)))=1;
    end  
end

save('./data/multi_label.mat','multi_label_table', 'prune_label','class_idx');







