config = get_config();
event = 'Bin';
binSize = 150;
stepSize = 50;
numSplits = 20;

transfer = 'ArmType';
target = 'Rewarded';


% == An example of how to run decoding analysis with transfer learning ==
[train_label_values, test_label_values] = partition_label_values(transfer, target);
% [decoding_results_path, shuffle_dir_name] = runClassifierPVal(config.rasters_folder, event, 'Combination', binSize, stepSize, numSplits, ...
%   [],train_label_values,test_label_values);
% plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])


% == An example od how to limit the analysis to a single stage ==
% runClassifierPVal(config.rasters_folder, event, 'Combination', binSize, stepSize, numSplits, ...
%     'WR1', the_training_label_names, the_test_label_names)
% 


% == An example of how to perform decoding analysis with no transfer ==
% [decoding_results_path, shuffle_dir_name] = runClassifierPVal(config.rasters_folder, event, target, binSize, stepSize, numSplits,[]);
% plotClassifierResults(decoding_results_path, shuffle_dir_name,[])


% == An example of how to plot population firing rate in 2D space ==
%ds = get_population_DS(config.rasters_folder, event, [], 'Combination', 2, binSize, stepSize, train_label_values, test_label_values);
% plot_population(ds, 20)


num_times_to_repeat_each_label_per_cv_split = 3;
ds = get_population_DS(config.rasters_folder, event, [], 'Combination', 2, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
%ds = get_population_DS(config.rasters_folder, event, [], target, 4,num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);


[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;
extract_geometry(all_XTr{1});