function [label_group1, label_group2] = partition_label_values_train_test(transfer_label, target_label)
%%% The transfer_label is the label we check generalization on and the
%%% target_labelis the label we will decode.

    values =  [0,0,0,0,{'left_NR_food_train'} 
               0,0,1,0,{'left_NR_water_train'}
               0,1,0,0,{'left_R_food_train'}
               0,1,1,0,{'left_R_water_train'}
               1,0,0,0,{'right_NR_food_train'}
               1,0,1,0,{'right_NR_water_train'}
               1,1,0,0,{'right_R_food_train'} 
               1,1,1,0,{'right_R_water_train'}
               0,0,0,1,{'left_NR_food_test'} 
               0,0,1,1,{'left_NR_water_test'}
               0,1,0,1,{'left_R_food_test'}
               0,1,1,1,{'left_R_water_test'}
               1,0,0,1,{'right_NR_food_test'}
               1,0,1,1,{'right_NR_water_test'}
               1,1,0,1,{'right_R_food_test'} 
               1,1,1,1,{'right_R_water_test'}];
           
           
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
    case 'Test'
        train_ind = find(cell2mat(values(:,4))==0);
        test_ind = find(cell2mat(values(:,4))==1);
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

label_group1 = [{values(intersect(train_ind, class0),5)'},{values(intersect(train_ind, class1),5)'}];
label_group2 = [{values(intersect(test_ind, class0),5)'},{values(intersect(test_ind, class1),5)'}];

end