function combinations = getLabelsCombinations( filter_labels )
%GETLABELSCOMBINATIONS Given an array of labels, creates all values
%combinations. i.e., if filter_labels=[A,B], where A={a1, a2, ...} and 
% B={b1, b2, ...}, then combinations=AXB.

if isempty(filter_labels)
    combinations = [];
    return
end
combinations = label_values(filter_labels{1});
for i=2:length(filter_labels)
    combinations = combvec(combinations, label_values(filter_labels{i}));
end
end



function allPossibilities = label_values(label)

switch label
    case 'Chosen'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm1'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm2'
        allPossibilities = [1 2 3 4];
    case 'Rewarded'
        allPossibilities = [0 1];
    case 'ArmType'
        allPossibilities = [1 2];
end

end

