function plotClassifierResults(rastersDir, event, toDecode, numSplits, EnoughCellsINX)
%PLOTCLASSIFIERRESULTS Plots the classifier decoding results. 
%   plotClassifierResults('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters','Ain', 'Rewarded',EnoughCellsINX ,20)

decoding_results = fullfile(rastersDir,[event,'_',toDecode,'_Results']);

figure;
result_names{1} = fullfile(rastersDir,[event,'_',toDecode,'_Results']);
plot_obj = plot_standard_results_object(result_names, '');

plot_obj.significant_event_times = [1000,4000,5000,5600,10600];
plot_obj.errorbar_file_names = ({decoding_results});
plot_obj.errorbar_transparency_level = .15;
plot_obj.errorbar_edge_transparency_level = 0.05;
plot_obj.errorbar_stdev_multiplication_factor = 1/sqrt(numSplits); %to make it SEM

%plot_obj.null_distribution_file_prefix_name=[event,'_',toDecode];

pval_dir{1} = fullfile(rastersDir,'Shuffle');
plot_obj.p_values = pval_dir;
plot_obj.collapse_all_times_when_estimating_pvals = 1;
plot_obj.p_value_alpha_level = 0.05;
plot_obj.plot_results;

grid off
title([event, ' ', toDecode, ' Num Splits: ', num2str(numSplits), ...
    ' Num Cells: ', num2str(length(EnoughCellsINX)), ' Clasifier: MaxCorrelation']);
legend off;

end

