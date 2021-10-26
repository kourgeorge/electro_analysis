addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';
clearvars;
close all;

%% Figure 2c - 2c  classification accuracy along the time of the ITI response to goal type (arm type) (stimulus time marked)
%%%	use the best looking of the following:
%%%	- separately on WR and FR stages
%%%	- only on WR stages
%%% - all trials of all days together

config = get_config();
rasters = fullfile(config.rasters_folder,'all'); 

event = 'ITI';
target = 'ArmType';
binSize = 150;
stepSize = 50;
numSplits = 10;

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 2c - classification accuracy along the time of the ',event,' response to goal type.'])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,['WR']);
plotClassifierResults(decoding_results_path, shuffle_dir_name,['Fig 2c (1) - classification accuracy along the time of the ',event,' response to goal type: WR Stages'])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,['FR']);
plotClassifierResults(decoding_results_path, shuffle_dir_name,['Fig 2c (2) - classification accuracy along the time of the ',event,'  response to goal type: FR Stages'])

%% Fig 2d - maximum classification accuracy in each stage
all_stage_names = {'odor1_WR1','odor2_WR1','odor2_XFR','odor3_WR2','spatial_WR2'};
maximal_goal_decoding_accuracy_all_stages = [];
num_cell = [];

for stage=all_stage_names
    [decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,stage{:});
    decoding_results = load(decoding_results_path);
    maximal_goal_decoding_accuracy_all_stages = [maximal_goal_decoding_accuracy_all_stages,...
        max(decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results)];
    num_cell = [num_cell, length(ds.sites_to_use)];
end


X = categorical(all_stage_names);
X = reordercats(X,all_stage_names);
figure;
b = bar(X, maximal_goal_decoding_accuracy_all_stages);


xtips = b(1).XEndPoints;
ytips = b(1).YEndPoints;
labels = string(num_cell);
text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

title('2d - maximum classification accuracy of goal type in each stage at around ITI. Num cells above bars.')

%% Fig 2e - theoretical maximum classification accuracy according to Sompolinsky’s SNR, or according to SNRT with the test, 
%for each such day or stage (if possible, then day would be much better), separating food and water and both.

event = 'ITI';
target = 'ArmType';

config = get_config();

rasters = fullfile(config.rasters_folder,'all'); 

binSize = 150;
stepSize = 50;
numSplits = 10;


[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
%plotClassifierResults(decoding_results_path, shuffle_dir_name,[])
decoding_results = load(decoding_results_path);

num_times_to_repeat_each_label_per_cv_split = 10;
numSplits = 2;

ds = get_population_DS(rasters, event, [], target, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
%[all_XTr, all_YTr_aug, all_XTe_aug, all_YTe_aug] = ds.get_data_MC;

plot_theoretical_decoding(ds, decoding_results)
title('Fig 2e (2) - for supplementary information, a figure with the whole timeline of the cut, showing correspondence Between theoretical and empirical SNRT')


%% Fig 2f confusion matrix of something? Help me think here…
event = 'ITI';
target = 'ArmType';

ds = get_population_DS(rasters, event, [], target, 2, 10, binSize, stepSize);
%[all_XTr, all_YTr, all_XTe, all_YTe] = augment_ds(ds, 10);
plot_population(ds, 8)
