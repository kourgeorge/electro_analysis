function test_augment_ds()
%TEST_AUGMENT_DS Summary of this function goes here
%   Detailed explanation goes here


config = get_config();
rasters = fullfile(config.rasters_folder,'Rasters_short'); 
binSize = 150;
stepSize = 50;
numSplits = 5;
label = 'ArmType';
event = 'ITI';

ds= get_population_DS(rasters, event, [], label, numSplits, 2, binSize, stepSize);

[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;

[all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = augment_ds(ds,1);


assert(all(size(all_XTr{1}{1})==size(all_XTr_aug{1}{1})))

end

