function [train_label_values,test_label_values] = get_transfer_label_values(transfer,target)
%GET_TRANSFER_LABEL_VALUES Summary of this function goes here
%   Detailed explanation goes here

if strcmp(transfer,'ArmType') && strcmp(target,'Rewarded')
    train_label_values = [{{'R_water'}},{{'NR_water'}}];
    test_label_values = [{{'R_food'}},{{'NR_food'}}];
    
elseif strcmp(transfer,'Rewarded') && strcmp(target,'ArmType')
    
    train_label_values = [{{'R_food'}},{{'R_water'}}];
    test_label_values = [{{'NR_food'}},{{'NR_water'}}];
    
elseif strcmp(transfer,'ArmType') && strcmp(target,'Direction')
    train_label_values = [{{'left_food'}},{{'right_food'}}];
    test_label_values = [{{'left_water'}},{{'right_water'}}];
    
elseif strcmp(transfer,'Direction') && strcmp(target,'ArmType')
    train_label_values = [{{'left_food'}},{{'left_water'}}];
    test_label_values = [{{'left_food'}},{{'left_water'}}];
    
elseif strcmp(transfer,'Rewarded') && strcmp(target,'Direction')
    train_label_values = [{{'left_R'}},{{'right_R'}}];
    test_label_values = [{{'left_NR'}},{{'right_NR'}}];
    
elseif strcmp(transfer,'Direction') && strcmp(target,'Rewarded')
    train_label_values = [{{'left_R'}},{{'left_NR'}}];
    test_label_values = [{{'right_R'}},{{'right_NR'}}];
    
end

end

