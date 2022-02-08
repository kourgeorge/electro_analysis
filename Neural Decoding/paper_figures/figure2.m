addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';
clearvars;
close all;

%% Figure 3a  classification accuracy along the time of the ITI response to goal type (arm type) (stimulus time marked)
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

%[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
%plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Fig 3a - classification accuracy along the time of the ',event,' response to goal type.'])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,['WR']);
plotClassifierResults(decoding_results_path, shuffle_dir_name,['Fig 3a (1) - classification accuracy along the time of the ',event,' response to goal type: WR Stages'])

[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,['FR']);
plotClassifierResults(decoding_results_path, shuffle_dir_name,['Fig 3a (2) - classification accuracy along the time of the ',event,'  response to goal type: FR Stages'])

%% Fig 3b - maximum classification accuracy in each stage
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

title('3b - maximum classification accuracy of goal type in each stage at around ITI. Num cells above bars.')

%% Fig 2e - Suplementary! theoretical maximum classification accuracy according to Sompolinsky’s SNR, or according to SNRT with the test, 
%for each such day or stage (if possible, then day would be much better), separating food and water and both.

event = 'ITI';
target = 'ArmType';

config = get_config();

rasters = fullfile(config.rasters_folder,'all'); 

binSize = 150;
stepSize = 50;
numSplits = 2;


%[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
%plotClassifierResults(decoding_results_path, shuffle_dir_name,[])
%decoding_results = load(decoding_results_path);

%TODO: check the verage radius of water vs. food (on the decoder data) to explain why is the recall of
% water is much higher than the recall of food.

num_times_to_repeat_each_label_per_cv_split = 10;
%numSplits = 2;

ds = get_population_DS(rasters, event, [], target, [],numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
%[all_XTr, all_YTr_aug, all_XTe_aug, all_YTe_aug] = ds.get_data_MC;

plot_theoretical_decoding(ds, 100)
title('Fig 2e (2) - for supplementary information, a figure with the whole timeline of the cut, showing correspondence Between theoretical and empirical SNR')
legend('Theory Accuracy', ['Theory recall: Water'], ['Theory recall: Food'],'AutoUpdate','off');
%ylim([0.75,0.85])


%% Fig 2f Neural geometry of ArmType at ITI
event = 'ITI';
target = 'ArmType';
timebin = 4;

config = get_config();
rasters = fullfile(config.rasters_folder,'all'); 

binSize = 150;
stepSize = 50;
numSplits = 2;

num_times_to_repeat_each_label_per_cv_split = 10;

ds = get_population_DS(rasters, event, ['FR'], target, [], numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);

[all_XTr, all_YTr, all_XTe, all_YTe] = augment_ds(ds, 10);
%[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;

labels = unique(all_YTr);
X1 = all_XTr{timebin}{1}(:,all_YTr==labels(1))';
X2 = all_XTr{timebin}{1}(:,all_YTr==labels(2))';
X3 = all_XTe{timebin}{1}(:,all_YTe==labels(1))';
X4 = all_XTe{timebin}{1}(:,all_YTe==labels(2))';

geom1 = extract_geometry([X1;X3]);
geom2 = extract_geometry([X2;X4]);
snr = SNR(geom1,geom2);

X_dr = DirectectedDR([X1;X2;X3;X4], geom1.centroid-geom2.centroid, 2);

n = size(X1,1);

X1_red = X_dr(1:n,:);
X2_red = X_dr(n+1:2*n,:);
X3_red = X_dr(2*n+1:3*n,:);
X4_red = X_dr(3*n+1:4*n,:);

m=length(all_YTr);

figure;
%plot_geometries_2d(X1_red, X3_red);
plot_geometries_2d([X1_red;X3_red], [X2_red;X4_red]);

title(['Fig 3f – Estimated geometries for interesting points (timebin=',num2str(timebin),')'])
subtitle (['Num Cells: ', num2str(size(all_XTr{1}{1},1)), '#TrainSize: ', num2str(length(all_YTr)), ' #TestSize: ', num2str(length(all_YTe)), '. Pred.Acc:', num2str(1-snr.error(m))])

legend('food', 'water')