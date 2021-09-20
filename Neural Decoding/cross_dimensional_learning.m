config = get_config();
rasters = fullfile(config.rasters_folder,'Rasters_short'); 

event = 'Bin';
binSize = 150;
stepSize = 50;
numSplits = 5;

transfer = 'Rewarded';
target = 'ArmType';

% == An example of how to run decoding analysis with transfer learning ==
[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])


% == An example of how to limit the analysis to a single stage ==
runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
    ['WR1'], train_label_values, test_label_values)



% == An example of how to perform decoding analysis with no transfer ==
[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name,[])

