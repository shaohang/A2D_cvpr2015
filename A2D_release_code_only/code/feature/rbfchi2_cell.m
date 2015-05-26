function D = rbfchi2_cell(X,Y)

num_channel = size(X,1);
num_instanceX = size(X{1},1);
num_instanceY = size(Y{1},1);
D = zeros(size(X{1},1),size(Y{1},1), num_channel);
matlabpool(5)
tic;
parfor channel = 1: num_channel
    
%     temp_D = vl_alldist2(X(:,:,channel)',Y(:,:, channel)', 'chi2' )/2;
    temp_D = vl_alldist2(X{channel}',Y{channel}', 'chi2' )/2;
    % compute the mean of chi2 distance
    mean = sum(sum(temp_D))/(num_instanceX*num_instanceY);

    % compute kernel matrix
    temp_D = temp_D/mean;
    D(:,:,channel) = temp_D;
end
toc;
matlabpool close;
D = exp(-sum(D,3)/num_channel);