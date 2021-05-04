rastersDir = '/Users/gkour/Box/phd/Electro_Rats/Rasters_augmented';
rastersDir_sim_allocentric = '/Users/gkour/Box/phd/Electro_Rats/Rasters_allocentric';
rastersDir_allocentric = '/Users/gkour/Box/phd/Electro_Rats/Rasters_augmented_allocentric';
rastersDir_sim = '/Users/gkour/Box/phd/Electro_Rats/Rasters_simple';
rastersDir_armtype = '/Users/gkour/Box/phd/Electro_Rats/Rasters_armtype';
random_rastersDir = '/Users/gkour/Box/phd/Electro_Rats/Rasters_100_random';
event = 'ITI';
binSize = 150;
stepSize = 50;
numSplits = 2;

transfer = 'Rewarded';
target = 'ArmType';

%addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding/lib/ndt.1.0.4/classifiers/@libsvm_CL/libsvm-master/matlab'

[the_training_label_names, the_test_label_names] = partition_label_values(transfer, target);
%[the_training_label_names, the_test_label_names] = partition_label_values_train_test(transfer, target);

[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rastersDir_allocentric, event, 'Combination', binSize, stepSize, numSplits, ...
   [], the_training_label_names, the_test_label_names);

plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])

plot_population(ds, 8)
 
% [decoding_results_path, shuffle_dir_namem, ds]  = runClassifierPVal(rastersDir, event, target, binSize, stepSize, numSplits, []);
% plotClassifierResults(decoding_results_path, shuffle_dir_name, [])


% runClassifierPVal(rastersDir, event, 'Combination', binSize, stepSize, numSplits, ...
%     'WR1', the_training_label_names, the_test_label_names)
% 

% [decoding_results_path, shuffle_dir_name] = runClassifierPVal(rastersDir_sim, event, target, binSize, stepSize, numSplits, []);
% plotClassifierResults(decoding_results_path, shuffle_dir_name, [])


