config = get_config();
rasters_allocentric = fullfile(config.rasters_folder,'Rasters_allocentric');
raster_egoentric = fullfile(config.rasters_folder,'Rasters_egocentric');

event = 'ITI';
binSize = 150;
stepSize = 50;
numSplits = 20;

transfer = 'ArmType';
target = 'Rewarded';

% == An example of how to run decoding analysis with transfer learning ==
[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters_allocentric, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])


% == An example of how to limit the analysis to a single stage ==
% runClassifierPVal(config.rasters_folder, event, 'Combination', binSize, stepSize, numSplits, ...
%     'WR1', the_training_label_names, the_test_label_names)
% 


% == An example of how to perform decoding analysis with no transfer ==
% [decoding_results_path, shuffle_dir_name] = runClassifierPVal(config.rasters_folder, event, target, binSize, stepSize, numSplits,[]);
% plotClassifierResults(decoding_results_path, shuffle_dir_name,[])


% == An example of how to plot population firing rate in 2D space ==
%ds = get_population_DS(config.rasters_folder, event, [], 'Combination', 1,num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
%plot_population(ds, 8)

num_times_to_repeat_each_label_per_cv_split = 10;
timebin = 15;
ds = get_population_DS(rasters_allocentric, event, ['WR'], 'Combination', 1, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
%ds = get_population_DS(config.rasters_folder, event, [], target, 2,num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
plot_population(ds, timebin)

[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;
X = all_XTr{timebin}{1}';
X_1 = X(all_YTr==1,:);
X_2 = X(all_YTr==2,:);

X_T = all_XTe{timebin}{1}';
X_3 = X_T(all_YTe==1,:);
X_4 = X_T(all_YTe==2,:);

[geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(X_1);
[geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(X_2);
[geom3.centroid, geom3.D, geom3.U, geom3.Ri, geom3.N] = extract_geometry(X_3);
[geom4.centroid, geom4.D, geom4.U, geom4.Ri, geom4.N] = extract_geometry(X_4);

[snr,error_a] = SNR(geom1, geom2);
arrayfun(error_a, 1:20)

[snr,error_a_T] = SNR_T(geom1, geom2, geom3);
[snr,error_b_T] = SNR_T(geom2, geom1, geom4);


arrayfun(error_a_T, 1:20)