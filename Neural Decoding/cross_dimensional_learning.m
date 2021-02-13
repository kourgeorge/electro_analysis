rastersDir = '/Users/gkour/Box/phd/Electro_Rats/Rasters_100_augmented';
event = 'Bin';
binSize=300;
stepSize = 50;
numSplits = 10;
                        
[the_training_label_names, the_test_label_names] = ...
    partition_label_values('Rewarded', 'ArmType');

runClassifierPVal(rastersDir, event, 'combination', binSize, stepSize, numSplits, ...
    the_training_label_names, the_test_label_names)
                        

