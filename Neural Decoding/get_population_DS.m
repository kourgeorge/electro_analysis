function ds = get_population_DS(rastersDir, event, stage, label, numSplits, num_times_to_repeat_each_label_per_cv_split, binSize,  stepSize, train_label_values, test_label_values)

generalization = true;

if nargin < 10
    generalization = false;
end

use_unique_data_in_each_CV_split = 1;

%GET_POPULATION_DS Summary of this function goes here
%   Detailed explanation goes here
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

%%% Build the Data Source                           
if generalization
    ds = generalization_DS(binned_data_file_name, label , numSplits, train_label_values, test_label_values);
    ds.use_unique_data_in_each_CV_split=use_unique_data_in_each_CV_split;
    
    % When the number split is small add more samples to test
    ds.num_times_to_repeat_each_label_per_cv_split=num_times_to_repeat_each_label_per_cv_split;
else
    ds = basic_DS(binned_data_file_name, label, numSplits);
end

ds.num_times_to_repeat_each_label_per_cv_split = num_times_to_repeat_each_label_per_cv_split;
enoughCellIndx = find_sites_with_k_label_repetitions(trialsLabels, num_times_to_repeat_each_label_per_cv_split+1);
ds.sites_to_use = enoughCellIndx;

end
