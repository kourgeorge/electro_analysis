function [decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rastersDir, event, label, binSize, stepSize, numSplits, stage, train_label_values, test_label_values)


if nargin < 7
    stage = [];
end

rng('shuffle','twister');

% create a feature proprocessor and a classifier
the_feature_preprocessors{1} = zscore_normalize_FP;
the_classifier = max_correlation_coefficient_CL;

%the_classifier = libsvm_CL;
%the_classifier.multiclass_classificaion_scheme = 'one_vs_all';
%the_classifier.multiclass_classificaion_scheme = 'all_pairs';  %uncomment for svm
%the_classifier.kernel = 'polynomial';
%the_classifier.kernel = 'linear';  %uncomment for svm
%the_classifier.kernel = 'rbf';
% the_classifier.poly_degree = 2;

%%% Create the Binned-data

if nargin > 8
    num_times_to_repeat_each_label_per_cv_split = 4;
    ds = get_population_DS(rastersDir, event, stage, label, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
else
    num_times_to_repeat_each_label_per_cv_split = 8;
    ds = get_population_DS(rastersDir, event, stage, label, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
end


%%% Build and run the cross validation
the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
%the_cross_validator.num_resample_runs = 10;
the_cross_validator.test_only_at_training_times = 1; % train and test on same time slot
DECODING_RESULTS = the_cross_validator.run_cv_decoding;
DECODING_RESULTS.event = event; 
DECODING_RESULTS.label = label;
DECODING_RESULTS.stage = stage;


% save the decoding results as 'My_Decoding_Results
decoding_results_path = fullfile(rastersDir,[stage, '_',event,'_',label,'_Results']);
save(decoding_results_path, 'DECODING_RESULTS');

for shuff_num = 1:5
    
    disp('running reshuffle decoding');
    disp(['Shuffle number ',num2str(shuff_num )]);
    if nargin > 8
        ds_shuff = get_population_DS(rastersDir, event, stage, label, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
    else
        ds_shuff = get_population_DS(rastersDir, event, stage, label, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);
    end
    
    ds_shuff.randomly_shuffle_labels_before_running=1;
    
    the_cross_validator = standard_resample_CV(ds_shuff, the_classifier, the_feature_preprocessors);
    the_cross_validator.num_resample_runs = 10;
    
    % suppress displays
    the_cross_validator.display_progress.zero_one_loss = 0;
    the_cross_validator.display_progress.resample_run_time = 0;
    
    DECODING_RESULTS = the_cross_validator.run_cv_decoding;
    shuffle_dir_name = fullfile(rastersDir,['Shuffle_',stage,'_' ,event,'_',label]);
    softmkdir(shuffle_dir_name)
    save(fullfile(shuffle_dir_name,['ShuffRun_',num2str(shuff_num,'%03d')]), ...
        'DECODING_RESULTS');
end
