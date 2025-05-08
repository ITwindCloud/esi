function entropy = compute_entropy(data)
% https://www.zhihu.com/question/274997106
    data = data(:);
    binEdge = linspace(min(data),max(data),100);
    [counts,~] = histcounts(data,binEdge);
    probabilities = counts / numel(data);
    entropy = - sum(probabilities .* log2(probabilities + 1e-5));
end