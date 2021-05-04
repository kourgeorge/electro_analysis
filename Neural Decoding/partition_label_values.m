function [label_group1, label_group2] = partition_label_values(transfer_label, target_label)
%%% The transfer_label is the label we check generalization on and the
%%% target_labelis the label we will decode.

    values =  [0,0,0,{'left_NR_food'} 
               0,0,1,{'left_NR_water'}
               0,1,0,{'left_R_food'}
               0,1,1,{'left_R_water'}
               1,0,0,{'right_NR_food'}
               1,0,1,{'right_NR_water'}
               1,1,0,{'right_R_food'} 
               1,1,1,{'right_R_water'}];
           
           
switch(transfer_label)
    case 'Direction'
        train_ind = find(cell2mat(values(:,1))==1);
        test_ind = find (cell2mat(values(:,1))==0);
    case 'Rewarded'
        train_ind = find(cell2mat(values(:,2))==1);
        test_ind = find (cell2mat(values(:,2))==0);
    case 'ArmType'
        train_ind = find(cell2mat(values(:,3))==1);
        test_ind = find (cell2mat(values(:,3))==0);
end

switch target_label
    case 'Direction'
        class0 = find(cell2mat(values(:,1))==1);
        class1 = find (cell2mat(values(:,1))==0);
    case 'Rewarded'
        class0 = find(cell2mat(values(:,2))==1);
        class1 = find (cell2mat(values(:,2))==0);
    case 'ArmType'
        class0 = find(cell2mat(values(:,3))==1);
        class1 = find (cell2mat(values(:,3))==0);
end

label_group1 = [{values(intersect(train_ind, class0),4)'},{values(intersect(train_ind, class1),4)'}];
label_group2 = [{values(intersect(test_ind, class0),4)'},{values(intersect(test_ind, class1),4)'}];

end