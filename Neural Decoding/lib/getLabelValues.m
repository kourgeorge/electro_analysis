function allPossibilities = getLabelValues(label)

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