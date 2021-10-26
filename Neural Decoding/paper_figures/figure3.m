addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';
clearvars;
close all;

%% Fig 3a classification accuracy for ‘Rewarded’ during ITI
% - if it works, and if the same works in Fig 2 as well, then only in WR stages (or separately for WR and FR stages).
% - this should show no significant classification ability

config = get_config();
rasters = fullfile(config.rasters_folder,'all'); 

event = 'ITI';
binSize = 150;
stepSize = 50;
numSplits = 10;

target = 'Rewarded';


[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3a - classification accuracy for ‘Rewarded’ during ITI'])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,['WR']);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3a(1) - classification accuracy for ‘Rewarded’ during ITI in WR stages'])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,['FR']);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3a(2) - classification accuracy for ‘Rewarded’ during ITI in WR stages']);

%% Fig 3b – theoretical classification accuracy for the same

[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
%num_times_to_repeat_each_label_per_cv_split = 10;
%numSplits=2;
%ds = get_population_DS(rasters, event, [], target, 2, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
decoding_results = load(decoding_results_path);
plot_theoretical_decoding(ds,decoding_results)

suptitle ('theoretical classification accuracy for ‘Rewarded’ during ITI')
%% Fig 3c – classification accuracy for Rewarded, separated by Arm Type
%	 - preferably the whole timeline, if not looking nice then only maximum, and timeline in supplementary

rasters_food = fullfile(config.rasters_folder,'food');
rasters_water = fullfile(config.rasters_folder,'water');

numSplits = 10;

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters_food, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3c - classification accuracy for Rewarded in food arms'])
hold on;
[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters_water, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3c - classification accuracy for Rewarded for water arms'])
hold off;


%% Fig 3d – transfer classification accuracy (target Rewarded, transfer ArmType, trained on water, tested on food)

config = get_config();
rasters = fullfile(config.rasters_folder,'all'); 

event = 'ITI';
binSize = 150;
stepSize = 50;
numSplits = 10;

transfer = 'ArmType';
target = 'Rewarded';

[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])
suptitle('Fig 3d – transfer classification accuracy')


%% Fig 3e – confusion matrix for the most interesting point/s in Fig 3d (maximum, significant minimum) if there is one
timebin = 10;
plot_population(ds, timebin)
suptitle(['Fig 3e – confusion matrix for the minimum  point (timebin=',num2str(timebin),')'])


%% Fig 3f – estimated geometries for the same point/s3

transfer = 'ArmType';
target = 'Rewarded';

num_times_to_repeat_each_label_per_cv_split = 4;
[train_label_values, test_label_values] = partition_label_values(transfer, target);
ds = get_population_DS(rasters, event, [], 'Combination', 1, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);

[all_XTr_aug, all_YTr, all_XTe_aug, all_YTe] = augment_ds(ds, 10);
[all_XTr_reduced, all_XTe_reduced] = dimensionality_reduce_ds(all_XTr_aug, all_XTe_aug);

Xt_red = all_XTr_reduced{timebin}{1}';
X1_red = Xt_red(all_YTr==1,:);
X2_red = Xt_red(all_YTr==2,:);

Xe_red = all_XTe_reduced{timebin}{1}';
X3_red = Xe_red(all_YTe==1,:);
X4_red = Xe_red(all_YTe==2,:);
    
figure;
plot_geometries_2d(X1_red,X2_red,X3_red,X4_red)
title(['Fig 3f – Estimated geometries for the minimum point (timebin=',num2str(timebin),')'])

%% Fig 3g – theoretical SNRT for the same points, or for the entire timeline 
transfer = 'ArmType';
target = 'Rewarded';

[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
decoding_results = load(decoding_results_path);

plot_theoretical_decoding(ds, decoding_results)
suptitle(['Fig 3g – Empirical vs. theoretical accuracy around ', event,' . Tran: ',transfer,' Tar: ', target])

%% Fig 3h – theoretical confusion matrices for same points
% didn't we show that in 3e?