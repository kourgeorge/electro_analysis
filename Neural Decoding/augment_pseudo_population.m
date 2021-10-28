function [X_aug,Y_aug] = augment_pseudo_population(X, Y, factor)
%AUGMENT_PSEUDO_POPULATION Summary of this function goes here
%   Detailed explanation goes here

if factor==0
    X_aug=X;
    Y_aug=Y;
    return
end

all_labels = unique(Y)';

X_aug = [];
Y_aug = [];

for label=all_labels
   X_label =  X(Y==label,:);
   X_label = repmat(X_label,factor, 1);
   
   [n, cols] = size(X_label) ;
    for c = 1:cols
        X_label_shuffled(:,c) = X_label(randperm(n),c) ;
    end
    
    X_aug = [X_aug; X_label_shuffled];
    Y_aug = [Y_aug; repmat(label, n,1 )]; 
end
end

