rastersDir_sim = '/Users/gkour/Box/phd/Electro_Rats/Rasters_simple';
event = 'ITI';
binSize = 150;
stepSize = 50;
numSplits = 20;

transfer = 'Rewarded';
target = 'ArmType';

[the_training_label_names, the_test_label_names] = partition_label_values(transfer, target);
%[the_training_label_names, the_test_label_names] = partition_label_values_train_test(transfer, target);

[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rastersDir_sim, event, 'Combination', binSize, stepSize, numSplits, ...
  [],the_training_label_names,the_test_label_names);


decoding_results_path = '/Users/gkour/Box/phd/Electro_Rats/Rasters_simple/_ITI_Combination_Results';
shuffle_dir_name = '/Users/gkour/Box/phd/Electro_Rats/Rasters_simple/Shuffle__ITI_Combination';
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])
 
%plot_population(ds, 8)

%  
% [decoding_results_path, shuffle_dir_namem, ds]  = runClassifierPVal(rastersDir, event, target, binSize, stepSize, numSplits, []);
% plotClassifierResults(decoding_results_path, shuffle_dir_name, [])


% runClassifierPVal(rastersDir, event, 'Combination', binSize, stepSize, numSplits, ...
%     'WR1', the_training_label_names, the_test_label_names)
% 

%[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rastersDir_sim, event, target, binSize, stepSize, numSplits,[]);
%plotClassifierResults(decoding_results_path, shuffle_dir_name,[])


