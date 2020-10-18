function [ combinations, baseline, targets, binned_rasters ] = getCellBaselineTargetFR( event_cell_data, labels , baseline_range_bins, target_range_bins )
%GET_BASELINE_TARGET_FR Given the cell data for a given event, returns the
%baseline and target firing rate for each value in the label dimensions.
%   Detailed explanation goes here

baseline = [];
targets = [];
binned_rasters = [];
output_labels = [];
%filter_values = getLabelValues(label);
combinations = getLabelsCombinations(labels);
for v=1:length(combinations)
    
    [~, binned_raster] = RasterPsthUnderFilter (event_cell_data, labels, combinations(:,v));
    bin_size = event_cell_data.raster_site_info.binsize;
    binned_xaxis = event_cell_data.raster_site_info.cut_info(1)*1000/bin_size:event_cell_data.raster_site_info.cut_info(2)*1000/bin_size;
    event_bin = find(binned_xaxis==0);
    baseline_range = event_bin+baseline_range_bins(1):event_bin+baseline_range_bins(2);
    target_range = event_bin+target_range_bins(1):event_bin+target_range_bins(2);
    
    baseline_fr = mean(binned_raster(:,baseline_range),2);
    baseline = [baseline; {baseline_fr}];
    target_fr = binned_raster(:,target_range);
    targets = [targets; {target_fr}];
    
    binned_rasters = [binned_rasters; {binned_raster}];

    
end
end

