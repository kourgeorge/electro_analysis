function plotClassifierResults(decodingResultsFile, shuffledResultsFolder, txt)
%PLOTCLASSIFIERRESULTS Plots the classifier decoding results. 

decoding_results = load(decodingResultsFile);
numSplits = decoding_results.DECODING_RESULTS.DS_PARAMETERS.num_cv_splits;
used_sites = decoding_results.DECODING_RESULTS.DS_PARAMETERS.sites_to_use';
modelName = decoding_results.DECODING_RESULTS.TRAINED_MODELS(1).name;
event = decoding_results.DECODING_RESULTS.event;
label = decoding_results.DECODING_RESULTS.label;
stage = decoding_results.DECODING_RESULTS.stage;

figure;
plot_obj = plot_standard_results_object({decodingResultsFile}, '');

%plot_obj.significant_event_times = [1000,4000,5000,5600,10600];
plot_obj.errorbar_file_names = ({decodingResultsFile});
plot_obj.errorbar_transparency_level = .15;
plot_obj.errorbar_edge_transparency_level = 0.05;
plot_obj.errorbar_stdev_multiplication_factor = 1/sqrt(numSplits); %to make it SEM

%plot_obj.null_distribution_file_prefix_name=[event,'_',toDecode];

pval_dir{1} = shuffledResultsFolder;
plot_obj.p_values = pval_dir;
plot_obj.collapse_all_times_when_estimating_pvals = 1;
plot_obj.p_value_alpha_level = 0.05;
plot_obj.two_sided_pvalue = true;
plot_obj.plot_results;

grid off
title(txt)
subtitle(['Stage: ', stage, ' ', event, ' ', label, ' Num Splits: ', num2str(numSplits), ...
    ' #Cell: ', num2str(length(used_sites)), ' Class.: ', modelName]);
legend off;

