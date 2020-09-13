function runClassifierPVal(rastersDir, event, toDecode, binSize, ...
    sampleWindow, numSplits, EnoughCellsINX, stage)

% runClassifierPVal('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters','Ain','Rewarded',150,50,20,EnoughCellsINX)
if nargin < 8
    stage = [];
end

rng('shuffle','twister');
saveFile = fullfile(rastersDir,[stage, event,'_',toDecode,'_Results']);
binnedDataName = fullfile(rastersDir,[stage, event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat']);
l = load(binnedDataName,'binned_labels');
labelToDecode = l.binned_labels.(toDecode);

% the name of your binned-format data
switch toDecode
    case 'Chosen'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm1'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm2'
        allPossibilities = [1 2 3 4];
    case 'Rewarded'
        allPossibilities = [0 1];
    case 'ArmType'
        allPossibilities = [1 2];
end
binnedDataName = fullfile(rastersDir,[event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat']);


% create a feature proprocessor and a classifier
the_feature_preprocessors{1} = zscore_normalize_FP;
%the_classifier = max_correlation_coefficient_CL;
the_classifier = libsvm_CL;
%the_classifier.multiclass_classificaion_scheme = 'one_vs_all';
the_classifier.multiclass_classificaion_scheme = 'all_pairs';  %uncomment for svm
the_classifier.kernel = 'polynomial';
the_classifier.kernel = 'linear';  %uncomment for svm

% the_classifier.poly_degree = 2;

for shuff_num = 0:5
    
    % create suffled results for the null distribution
    if shuff_num == 0
        saveFile = fullfile(rastersDir,[stage, event,'_',toDecode,'_Results']);
        % create a basic datasource
        ds = basic_DS(binnedDataName, toDecode, numSplits);
        ds = ds.set_specific_sites_to_use(EnoughCellsINX{numSplits});
        ds.label_names_to_use = allPossibilities;
        ds.randomly_shuffle_labels_before_running = 0;
        % create a cross-validation object
        the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
        
    else
        disp('running reshuffle decoding');
        disp(['Shuffle number ',num2str(shuff_num )]);
        % randomly shuffle the labels before running
        % create a basic datasource
        ds = basic_DS(binnedDataName, toDecode, numSplits);
        ds = ds.set_specific_sites_to_use(EnoughCellsINX{numSplits});
        ds.label_names_to_use = allPossibilities;
        ds.randomly_shuffle_labels_before_running = 1;
        the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
        the_cross_validator.num_resample_runs = 10;
        % suppress displays
        the_cross_validator.display_progress.zero_one_loss = 0;
        the_cross_validator.display_progress.resample_run_time = 0;
        saveFile = fullfile(rastersDir,'Shuffle',[event,'_',toDecode,'_ShuffRun_',num2str(shuff_num,'%03d')]);
    end
    the_cross_validator.test_only_at_training_times = 1; % to speed up
    % run the decoding analysis
    DECODING_RESULTS = the_cross_validator.run_cv_decoding;
    
    
    % save the decoding results as 'My_Decoding_Results
    save(saveFile, 'DECODING_RESULTS');
end

