function his = getHist(index, selidx, clusterNum)

if length(selidx) == 0
    his = zeros(clusterNum, 1);
else
    his = histc(index(selidx), 1:1:clusterNum);
    his = his(:);
    his = his./sum(his);
end
his = his';