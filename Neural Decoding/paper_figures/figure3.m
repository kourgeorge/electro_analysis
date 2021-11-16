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

%[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
num_times_to_repeat_each_label_per_cv_split = 2;
numSplits=10;
ds = get_population_DS(rasters, event, [], target, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
%decoding_results = load(decoding_results_path);
plot_theoretical_decoding(ds)

suptitle ('theoretical classification accuracy for ‘Rewarded’ during ITI')
%% Fig 3c – classification accuracy for Rewarded, separated by Arm Type
%	 - preferably the whole timeline, if not looking nice then only maximum, and timeline in supplementary

config = get_config();
event = 'ITI';

rasters_food = fullfile(config.rasters_folder,'food');
rasters_water = fullfile(config.rasters_folder,'water');

numSplits = 10;

[decoding_results_path, shuffle_dir_name,ds_food] = runClassifierPVal(rasters_food, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3c - classification accuracy for Rewarded in food arms'])


[decoding_results_path, shuffle_dir_name,ds_water] = runClassifierPVal(rasters_water, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3c - classification accuracy for Rewarded for water arms'])


%%  Fig 3c(1) – Population geometry for Rewarded, separated by Arm Type

config = get_config();
target = 'Rewarded';

event = 'ITI'; 
timebin = 2;
binSize = 150;
stepSize = 50;

rasters_food = fullfile(config.rasters_folder,'food');
rasters_water = fullfile(config.rasters_folder,'water');
rasters = fullfile(config.rasters_folder,'all');

numSplits = 2;
num_times_to_repeat_each_label_per_cv_split = 5;


ds = get_population_DS(rasters, event, [], target, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
ds_food = get_population_DS(rasters_food, event, [], target, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
ds_water = get_population_DS(rasters_water, event, [], target, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);

[geom1, geom2, ~, ~] = plot_ds_timebin_geometry(ds, timebin, true);
snr_a = SNR(geom1, geom2);
snr_b = SNR(geom2, geom1);
pred_accuracy = 1-mean([snr_a.error(geom1.N),snr_b.error(geom2.N)]);
annotation('textbox', [0.7, 0.2, 0.2, 0.1], 'String', ['Pred Acc.:',num2str(pred_accuracy)])
title(['All Trials at ',event])

[geom1, geom2, ~, ~]=plot_ds_timebin_geometry(ds_food, timebin, true);
snr_a = SNR(geom1, geom2);
snr_b = SNR(geom2, geom1);
pred_accuracy = 1-mean([snr_a.error(geom1.N),snr_b.error(geom2.N)]);
annotation('textbox', [0.7, 0.2, 0.2, 0.1], 'String', ['Pred Acc.:',num2str(pred_accuracy), '   m: ', num2str(geom1.N)])
title(['Food Trials at ',event])

[geom1, geom2, ~, ~] = plot_ds_timebin_geometry(ds_water, timebin, true);
snr_a = SNR(geom1, geom2);
snr_b = SNR(geom2, geom1);
pred_accuracy = 1-mean([snr_a.error(geom1.N),snr_b.error(geom2.N)]);
annotation('textbox', [0.7, 0.2, 0.2, 0.1], 'String', ['Pred Acc.:',num2str(pred_accuracy), '   m: ', num2str(geom1.N)])
title(['Water Trials at ',event])

%% Fig 3d – transfer classification accuracy (target Rewarded, transfer ArmType, trained on water, tested on food)

config = get_config();
rasters = fullfile(config.rasters_folder, 'all'); 

event = 'ITI';
binSize = 150;
stepSize = 50;
numSplits = 10;

transfer = 'ArmType';
target = 'Rewarded';

[train_label_values,test_label_values] = get_transfer_label_values(transfer,target);
[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, [transfer,target], binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])
suptitle('Fig 3d – transfer classification accuracy')


%% Fig 3e – confusion matrix for the most interesting point/s in Fig 3d (maximum, significant minimum) if there is one
timebin = 9;
plot_population(ds, timebin)
suptitle(['Fig 3e – confusion matrix for the minimum  point (timebin=',num2str(timebin),')'])


%% Fig 3f – estimated geometries for the same point/s3


config = get_config();

event = 'ITI';
transfer = 'ArmType';
target = 'Rewarded';
binSize = 150;
stepSize = 50;

timebin = 9;

numSplits = 2;
num_times_to_repeat_each_label_per_cv_split = 5;

rasters = fullfile(config.rasters_folder, 'all'); 

%[train_label_values, test_label_values] = partition_label_values(transfer, target);
[train_label_values,test_label_values] = get_transfer_label_values(transfer,target);

ds = get_population_DS(rasters, event, [], [transfer,target], numSplits, num_times_to_repeat_each_label_per_cv_split, ...
    binSize, stepSize, train_label_values, test_label_values);

[geom1, geom2, geom3, geom4]=plot_ds_timebin_geometry(ds, timebin);

snr_T_a = SNR_T(geom1, geom2, geom3);
snr_T_b = SNR_T(geom2, geom1, geom4);

snr_a = SNR(geom1, geom2);
snr_b = SNR(geom2, geom1);

m = 10;
pred_accuracy = 1-mean([snr_a.error(m),snr_b.error(m)]);
pred_trans_accuracy = 1-mean([snr_T_a.error(m),snr_T_b.error(m)]);

title(['Fig 3f – Event:', event, ' Transfer: ',transfer,' Target: ',target])

annotation('textbox', [0.7, 0.2, 0.2, 0.1], 'String', ['Pred Acc.:',num2str(pred_accuracy),' Trans Acc.:',num2str(pred_trans_accuracy), '    m: ', num2str(m)])

%% Fig 3g – theoretical SNRT for the same points, or for the entire timeline 
transfer = 'ArmType';
target = 'Rewarded';
numSplits = 10;

[train_label_values,test_label_values] = get_transfer_label_values(transfer,target);
%[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, [transfer,target], binSize, stepSize, numSplits, ...
%  [],train_label_values,test_label_values);
%decoding_results = load(decoding_results_path);


ds = get_population_DS(rasters, event, [], [transfer,target], numSplits, num_times_to_repeat_each_label_per_cv_split, ...
    binSize, stepSize, train_label_values, test_label_values);



plot_theoretical_decoding(ds)
suptitle(['Fig 3g – Empirical vs. theoretical accuracy around ', event,' . Tran: ',transfer,' Tar: ', target])

%% Fig 3h – theoretical confusion matrices for same points
% didn't we show that in 3e?