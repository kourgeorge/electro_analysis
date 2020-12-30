function combinations = getLabelsCombinations( filter_labels )
%GETLABELSCOMBINATIONS Given an array of labels, creates all values
%combinations. i.e., if filter_labels=[A,B], where A={a1, a2, ...} and 
% B={b1, b2, ...}, then combinations=AXB.

if isempty(filter_labels)
    combinations = [];
    return
end
combinations = getLabelValues(filter_labels{1});
for i=2:length(filter_labels)
    combinations = combvec(combinations, getLabelValues(filter_labels{i}));
end
end

