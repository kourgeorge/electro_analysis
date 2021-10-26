addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';
clearvars;
close all;

%% 4a – goal encoding at the end of trial does not depend on actual outcome: classifier results for Bin target ArmType transfer Rewarded

config = get_config();
rasters = fullfile(config.rasters_folder,'all'); 

event = 'Bin';
binSize = 150;
stepSize = 50;
numSplits = 10;


transfer = 'Rewarded';
target = 'ArmType';

[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);

plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 4a – goal encoding at the end of trial does not depend on actual outcome ', '(Tran.: ',transfer, ' Tar.: ', target,')'])


%% 4b – confusion matrix at maximum point of classifier
max_timebin = 6;
plot_population(ds, max_timebin)

suptitle(['Fig 4b - confusion matrix for maximal timebin (=', num2str(max_timebin),')'])
%% Fig. 4c – geometries at maximum point – show the 3 2D manifold estimation in interesting bins  

num_times_to_repeat_each_label_per_cv_split = 4;
ds = get_population_DS(rasters, event, [], 'Combination', 1, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);


[all_XTr_aug, all_YTr, all_XTe_aug, all_YTe] = augment_ds(ds, max_timebin);
[all_XTr_reduced, all_XTe_reduced] = dimensionality_reduce_ds(all_XTr_aug, all_XTe_aug);

Xt_red = all_XTr_reduced{timebin}{1}';
X1_red = Xt_red(all_YTr==1,:);
X2_red = Xt_red(all_YTr==2,:);

Xe_red = all_XTe_reduced{timebin}{1}';
X3_red = Xe_red(all_YTe==1,:);
X4_red = Xe_red(all_YTe==2,:);
    
figure;
plot_geometries_2d(X1_red,X2_red,X3_red,X4_red)
title ('Fig. 4c – geometries at maximum point – show the 3 2D manifold estimation in max accuracy bin.')


%% Fig. 4d – action choice is represented in mPFC in allocentric coordinates: classifier results for Ain

rasters = fullfile(config.rasters_folder,'allocentric'); 

event = 'Ain';
binSize = 150;
stepSize = 50;
numSplits = 10;

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, 'AllocentericDirection', binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig. 4d (1) – action choice is represented in mPFC in Allocentric coordinates: classifier results for ',event ])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, 'Direction', binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig. 4d (2) – action choice is represented in mPFC in Egocentric coordinates: classifier results for ',event ])
%%% Here we see slightly better decoding of allocentric (~80% in 400) than ego-centric (65% in 400)... but not extreme... 


event = 'Ain'; % or Aout. 
transfer = 'Direction';
target = 'ArmType';

[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig. 4d (3) – action choice is represented in mPFC in allocentric coordinates: classifier results for ', event ', target: Armtype, transfer Direction - (Allocentric)'])
%%% Here we see low accuracy (~30%) ib 350-400 - interesting... 

%% Fig. 4e – confusion matrix for minimum bin demonstrating reverse diagonal (alo and egocentric)
numSplits = 1;
num_times_to_repeat_each_label_per_cv_split = 10;

timebin = 7;

ds = get_population_DS(rasters, event, [], 'Combination', numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values,test_label_values);
plot_population(ds, timebin)

suptitle([' Fig. 4e – confusion matrix for minimum bin(=', timebin,') demonstrating reverse diagonal tansfer for decoding armtype over direction (alocentric)'])

%% Fig 4f – geometry for minimum bin, showing that Arm1 is similar to arm 4 and Arm2 to Arm3.

ds = get_population_DS(rasters, event, [], 'Combination', 1, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);

[all_XTr_aug, all_YTr, all_XTe_aug, all_YTe] = augment_ds(ds, 5);
[all_XTr_reduced, all_XTe_reduced] = dimensionality_reduce_ds(all_XTr_aug, all_XTe_aug);

Xt_red = all_XTr_reduced{timebin}{1}';
X1_red = Xt_red(all_YTr==1,:);
X2_red = Xt_red(all_YTr==2,:);

Xe_red = all_XTe_reduced{timebin}{1}';
X3_red = Xe_red(all_YTe==1,:);
X4_red = Xe_red(all_YTe==2,:);
    
figure;
plot_geometries_2d(X1_red,X2_red,X3_red,X4_red)
title(['Fig 4f – geometry for minimum bin (=' ,num2str(timebin), ') showing that Arm1 is similar to arm 4 and Arm2 to Arm3.'])
legend('Food(Arm2)', 'Water(Arm3)', 'Food(Arm1)', 'Water(Arm4)','Food(Arm2)', 'Water(Arm3)', 'Food(Arm1)', 'Water(Arm4)', 'AutoUpdate','off')
