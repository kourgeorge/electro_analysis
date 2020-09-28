function [psth_mean, psth_sem, raster] = RasterPsthUnderFilter (cell_data, filter_labels, filter_values)
%RASTERPSTHUNDERFILTER Summary of this function goes here
%   Detailed explanation goes here

win = gausswin(3)/sum(gausswin(3));
relevant_trial = filter_trials(cell_data, filter_labels, filter_values);
raster = cell_data.raster_data.Raster(relevant_trial,:);
raster_binned = cell_data.raster_data.BinnedRaster(relevant_trial,:)*(1000/cell_data.raster_site_info.binsize);
%raster = raster(any(raster ~= 0,2),:);
psth_mean=filter(win,1,mean(raster_binned));
psth_std=filter(win,1,std(raster_binned));
psth_sem = psth_std./sqrt(size(raster_binned,1));
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

% function gaussFilter = gauss(sigma)
% width = round((6*sigma - 1)/2);
% support = (-width:width);
% gaussFilter = exp( -(support).^2 ./ (2*sigma^2) );
% gaussFilter = gaussFilter/ sum(gaussFilter);
% end

