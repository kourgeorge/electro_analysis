function runClassifierPVal(rastersDir, event, label, binSize, sampleWindow, numSplits, stage)

%runClassifierPVal('/Users/gkour/Box/phd/Electro_Rats/Rasters_100_simple','Ain','Rewarded',150,50,20)
if nargin < 8
    stage = [];
end

[EnoughCells,EnoughCellsINX] = prepareClassifier(rastersDir, event, label,150,50);

rng('shuffle','twister');
saveFile = fullfile(rastersDir,[stage, event,'_',label,'_Results']);
binnedDataName = fullfile(rastersDir,[stage, event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat']);
l = load(binnedDataName,'binned_labels');
labelToDecode = l.binned_labels.(label);

% the name of your binned-format data
allPossibilities = getLabelValues(label);
binnedDataName = fullfile(rastersDir,[event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat']);


% create a feature proprocessor and a classifier
the_feature_preprocessors{1} = zscore_normalize_FP;
%the_classifier = max_correlation_coefficient_CL;
%the_classifier = libsvm_CL;
%the_classifier.multiclass_classificaion_scheme = 'one_vs_all';
%the_classifier.multiclass_classificaion_scheme = 'all_pairs';  %uncomment for svm
%the_classifier.kernel = 'polynomial';
%the_classifier.kernel = 'linear';  %uncomment for svm
%the_classifier.kernel = 'rbf';

% the_classifier.poly_degree = 2;

for shuff_num = 0:5
    
    % create suffled results for the null distribution
    if shuff_num == 0
        saveFile = fullfile(rastersDir,[stage, event,'_',label,'_Results']);
        % create a basic datasource
        ds = basic_DS(binnedDataName, label, numSplits);
        ds.sample_sites_with_replacement = 0;
        ds = ds.set_specific_sites_to_use(EnoughCellsINX{numSplits});
        ds.label_names_to_use = allPossibilities;
        ds.randomly_shuffle_labels_before_running = 0;
        %ds.num_times_to_repeat_each_label_per_cv_split=10;
        
        % create a cross-validation object
        the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
        
    else
        disp('running reshuffle decoding');
        disp(['Shuffle number ',num2str(shuff_num )]);
        % randomly shuffle the labels before running
        % create a basic datasource
        ds = basic_DS(binnedDataName, label, numSplits);
        ds = ds.set_specific_sites_to_use(EnoughCellsINX{numSplits});
        ds.label_names_to_use = allPossibilities;
        ds.randomly_shuffle_labels_before_running = 1;
        
        %ds.num_times_to_repeat_each_label_per_cv_split=10;
        
        the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
        the_cross_validator.num_resample_runs = 10;
        % suppress displays
        the_cross_validator.display_progress.zero_one_loss = 0;
        the_cross_validator.display_progress.resample_run_time = 0;
        saveFile = fullfile(rastersDir,'Shuffle',[event,'_',label,'_ShuffRun_',num2str(shuff_num,'%03d')]);
    end
    the_cross_validator.test_only_at_training_times = 1; % to speed up
    
    % run the decoding analysis
    DECODING_RESULTS = the_cross_validator.run_cv_decoding;
    
    
    % save the decoding results as 'My_Decoding_Results
    save(saveFile, 'DECODING_RESULTS');
     
end

plotClassifierResults(rastersDir, event, label, numSplits, EnoughCellsINX)
