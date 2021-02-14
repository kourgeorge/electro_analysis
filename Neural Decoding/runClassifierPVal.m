function runClassifierPVal(rastersDir, event, label, binSize, stepSize, numSplits, stage, train_label_values, test_label_values)

%runClassifierPVal('/Users/gkour/Box/phd/Electro_Rats/Rasters_100_simple','Ain','Rewarded',150,50,20)
%runClassifierPVal('/Users/gkour/Box/phd/Electro_Rats/Rasters_100_augmented','Ain','combination',150,50,20, the_training_label_names, the_test_label_names)
generalization = true;

if nargin < 8
    generalization = false;
end

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



if ~isempty(stage)
    event_raster_dir = fullfile(rastersDir,event,['*',stage,'*']);
    save_prefix_name = fullfile(rastersDir,[stage,'_',event,'_Binned']);
else
    event_raster_dir = fullfile(rastersDir,event);
    save_prefix_name = fullfile(rastersDir,[event,'_Binned']);
end

binned_data_file_name = create_binned_data_from_raster_data(event_raster_dir, save_prefix_name, binSize, stepSize);%, start_time, end_time);

l = load(binned_data_file_name);
trialsLabels = l.binned_labels.(label);

enoughCellIndx = find_sites_with_k_label_repetitions(trialsLabels, numSplits);

%%% Build the Data Source                           
if generalization
    ds = generalization_DS(binned_data_file_name, label , numSplits, train_label_values, test_label_values);
else
    ds = basic_DS(binned_data_file_name, label, numSplits);
end

ds.sites_to_use = enoughCellIndx;
ds.randomly_shuffle_labels_before_running = 0;

%%% Build and run the cross validation
the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
the_cross_validator.test_only_at_training_times = 1; % train and test on same time slot
DECODING_RESULTS = the_cross_validator.run_cv_decoding;
    
% save the decoding results as 'My_Decoding_Results
decoding_results_path = fullfile(rastersDir,[stage, '_',event,'_',label,'_Results']);
save(decoding_results_path, 'DECODING_RESULTS');
    

for shuff_num = 1:5
    
    disp('running reshuffle decoding');
    disp(['Shuffle number ',num2str(shuff_num )]);
    %%% Build the Data Source                           
    if generalization
        ds = generalization_DS(binned_data_file_name, label , numSplits, train_label_values, test_label_values);
    else
        ds = basic_DS(binned_data_file_name, label, numSplits);
    end

    ds.sites_to_use = enoughCellIndx;
    ds.randomly_shuffle_labels_before_running = 1;
    
    the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
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

plotClassifierResults(decoding_results_path, shuffle_dir_name)
