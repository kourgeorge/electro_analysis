function allPossibilities = getLabelValues(label)

switch label
    case 'Chosen'
        allPossibilities = [1 2 3 4];
    case 'NPChosen'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm1'
        allPossibilities = [1 2];
    case 'CorrectArm2'
        allPossibilities = [3 4];
    case 'Rewarded'
        allPossibilities = [0 1];
    case 'NPRewarded'
        allPossibilities = [0 1];
    case 'ArmType'
        allPossibilities = [1 2];
    case 'combination'
        allPossibilities = [{'right_R_water','left_R_water', 'right_NR_water','left_NR_water'...
            'right_R_food','left_R_food', 'right_NR_food','left_NR_food'}];
end

end