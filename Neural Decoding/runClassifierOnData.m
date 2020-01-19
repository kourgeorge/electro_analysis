function runClassifierOnData(rastersDir, event,toDecode,binSize,sampleWindow,numSplits,EnoughCellsINX)

% runClassifierOnData('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Decoding', 'Ain','Chosen',150,50,10,EnoughCellsINX)

rng('shuffle','twister'); 
saveFile = fullfile(rastersDir,[event,'_',toDecode,'_Results']);
binnedDataName = fullfile(rastersDir,[event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat']);
l = load(binnedDataName,'binned_labels');
eval(['labelToDecode = l.binned_labels.',toDecode,';']);
% the name of your binned-format data
switch toDecode
        case 'Correct'
        allPossibilities = [0 1];
        ylim = [20 80];
    case 'Irrelevant'
        allPossibilities = [0 1];
        ylim = [20 80];
    case 'irrelevantCue'
        allPossibilities = [0 1];
        ylim = [20 80];
    case 'relevantCue'
        allPossibilities = [0 1];
        ylim = [20 80];
    case 'Chosen'
        allPossibilities = [1 2 3 4];
        ylim = [10 50];
    case 'Unchosen'
        allPossibilities = [1 2 3 4];
        ylim = [10 50];
    case 'Poked'
        allPossibilities = [1 2 3 4];
        ylim = [10 50];
end


% create a basic datasource
ds = basic_DS(binnedDataName, toDecode, numSplits);
ds = ds.set_specific_sites_to_use(EnoughCellsINX{numSplits});
ds.label_names_to_use = allPossibilities;
% create a feature proprocessor and a classifier
the_feature_preprocessors{1} = zscore_normalize_FP;
the_classifier = max_correlation_coefficient_CL;
% the_classifier = libsvm_CL;
 
% create a cross-validation object
the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
 
% run the decoding analysis
DECODING_RESULTS = the_cross_validator.run_cv_decoding;
 
% save the datasource parameters for our records
DATASOURCE_PARAMS = ds.get_DS_properties;
 
% save the decoding results as 'My_Decoding_Results
save(saveFile, 'DECODING_RESULTS', 'DATASOURCE_PARAMS');
figure; 
% plot the results
% plot_obj = plot_standard_results_object({'My_Decoding_Results.mat'});
plot_obj = plot_standard_results_object({saveFile});
plot_obj.significant_event_times = 1000;

plot_obj.plot_results;
set(gca,'ylim',ylim);
title([event,' ',toDecode]);
grid off;
