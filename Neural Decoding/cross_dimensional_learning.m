rastersDir = '/Users/gkour/Box/phd/Electro_Rats/Rasters_100_augmented';
event = 'Bin';
binSize=150;
stepSize = 50;
numSplits = 10;
                        
[the_training_label_names, the_test_label_names] = ...
    partition_label_values('Rewarded', 'ArmType'); 
% The generalization dimension is Rewarded and the decoding dimension is
% ArmType


runClassifierPVal(rastersDir, event, 'Combination', binSize, stepSize, numSplits, ...
     [], the_training_label_names, the_test_label_names)

runClassifierPVal(rastersDir, event, 'Combination', binSize, stepSize, numSplits, ...
    'odor1_WR', the_training_label_names, the_test_label_names)


runClassifierPVal(rastersDir, event, 'Rewarded', binSize, stepSize, numSplits);

runClassifierPVal(rastersDir, event, 'Rewarded', binSize, stepSize, numSplits, 'odor1_WR');