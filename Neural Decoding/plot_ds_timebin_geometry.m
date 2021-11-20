function [geom1, geom2, geom3, geom4] = plot_ds_timebin_geometry(ds, timebin, merge_train_test)
%PLOT_DS_GEOMETRY Summary of this function goes here
%   Detailed explanation goes here

if nargin<3
    merge_train_test=false;
end

transfer_ds = isequal(class(ds),'generalization_DS');

factor = 0;

[all_XTr_aug, all_YTr, all_XTe_aug, all_YTe] = augment_ds(ds, factor);
labels = unique(all_YTr);
X1 = all_XTr_aug{timebin}{1}(:,all_YTr==labels(1))';
X2 = all_XTr_aug{timebin}{1}(:,all_YTr==labels(2))';
X3 = all_XTe_aug{timebin}{1}(:,all_YTe==labels(1))';
X4 = all_XTe_aug{timebin}{1}(:,all_YTe==labels(2))';


if transfer_ds || merge_train_test==false
    geom1 = extract_geometry(X1);
    geom2 = extract_geometry(X2);
    geom3 = extract_geometry(X3);
    geom4 = extract_geometry(X4);
    X_dr = DirectectedDR([X1;X2;X3;X4], geom1.centroid-geom2.centroid, 2);
    
    n = [size(X1,1),size(X2,1),size(X3,1),size(X4,1)];
    n = cumsum(n);
    
    X1_red = X_dr(1:n(1),:);
    X2_red = X_dr(n(1)+1:n(2),:);
    X3_red = X_dr(n(2)+1:n(3),:);
    X4_red = X_dr(n(3)+1:n(4),:);
    
    
    plot_geometries_2d(X1_red, X2_red, X3_red, X4_red);
    
    subtitle (['Label:',ds.label ,' Num Cells: ', num2str(size(all_XTr_aug{1}{1},1)), ...
        ' TrainSize: ', num2str(length(all_YTr)), ' TestSize: ', num2str(length(all_YTe)), '. Timebin:', num2str(timebin)])
   
    if transfer_ds
        legend(ds.the_training_label_names{1}{1}, ds.the_training_label_names{2}{1},... 
            ds.the_training_label_names{1}{1}, ds.the_training_label_names{2}{1},...
            ds.the_test_label_names{1}{1}, ds.the_test_label_names{2}{1}, ...
            ds.the_test_label_names{1}{1}, ds.the_test_label_names{2}{1}, 'Interpreter', 'none');
    else
        legend(['Train: ',num2str(labels(1))], ['Train: ', num2str(labels(2))], '', '', ...
        ['Test: ',num2str(labels(1))], ['Test: ', num2str(labels(2))] , 'Interpreter', 'none');
    end
    
else
    % In case of non-transfer... without showing the train and test in
    % different manifolds
    
    % TODO: In this case we can collect all splits...
    
    X_train = [X1;X3];
    X_test = [X2;X4];
    geom1 = extract_geometry(X_train);
    geom2 = extract_geometry(X_test);
    X_dr = DirectectedDR([X_train;X_test], geom1.centroid-geom2.centroid, 2);
    n = size(X_train,1);
    plot_geometries_2d(X_dr(1:n,:), X_dr(n+1:end,:));
    
    subtitle (['Label:',ds.label ,' Num Cells: ', num2str(size(all_XTr_aug{1}{1},1)), ...
        ' LabelRep: ', num2str(size(X_train,1)), '. Timebin:', num2str(timebin)])
    
    legend(['Train: ',num2str(labels(1))], ['Train: ', num2str(labels(2))], 'Interpreter', 'none');
    
    geom3 = NaN;
    geom4 = NaN;
end

