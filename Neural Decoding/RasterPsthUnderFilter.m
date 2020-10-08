function [raster, raster_binned] = RasterPsthUnderFilter (cell_data, filter_labels, filter_values)
%RASTERPSTHUNDERFILTER Gfor a cell data, returns the raster and PSTH of a
%given labels filter.

relevant_trial = filter_trials(cell_data, filter_labels, filter_values);
raster = cell_data.raster_data.Raster(relevant_trial,:);
raster_binned = cell_data.raster_data.BinnedRaster(relevant_trial,:);
%raster = raster(any(raster ~= 0,2),:);

end

function relevant_trials = filter_trials(cell_data, filter_labels, filter_values)
if isempty(filter_labels)
    relevant_trials = 1:size(cell_data.raster_data,1); %return all trials indices
    return
end
relevant_trials=1:1000;
for i=1:length(filter_labels)
    filter_label = filter_labels{i};
    filter_value = filter_values(i);
    tmp = find(cell_data.raster_labels.(filter_label)==filter_value);
    relevant_trials = intersect(tmp,relevant_trials);
end
end
