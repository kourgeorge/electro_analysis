addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';

%% 5a – show the population in 2D under motivation transfer in maximal bin arounnd ITI


%%

config = get_config();
rasters = fullfile(config.rasters_folder,'all'); 

event = 'Ain';
bin_size = 150;
timebin = 3;

raster_cells_data = dir([fullfile(rasters, event), '/*.mat']);


filter_labels = {'ArmType', 'Direction'};
combinations = getLabelsCombinations( filter_labels );

%filter_values = {{[1],[0]}, {[1],[1]}, {[2],[0]}, {[2],[1]}, {[3],[0]}, {[3],[1]}, {[4],[0]}, {[4],[1]}};

all_conditions_vectors = [];
for comb = combinations
    all_cells_condition_mean = [];
    for cell_raster_file = raster_cells_data'
        cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
        relevant_trials = filter_trials (cell_data, filter_labels, comb);
        %get the mean firing over the entire cut in all relevant trials
        if isempty(relevant_trials)
            binned_raster = nan(1,5);
        else
            
            binned_raster = create_binned_raster_from_raster(cell_data.raster_data(relevant_trials,:), bin_size);
        end
        all_cells_condition_mean=[all_cells_condition_mean, nanmean(binned_raster(:,timebin))];
    end
    all_conditions_vectors = [all_conditions_vectors;all_cells_condition_mean];
end

%all_conditions_vectors(isnan(all_conditions_vectors))=0;
%all_conditions_vectors = zscore(all_conditions_vectors);
%RSA_mat = pdist2(all_conditions_vectors,all_conditions_vectors, 'correlation');
RSA_mat = corrcoef(all_conditions_vectors','rows','pairwise');
figure;
colormap(bluewhitered)
imagesc(-RSA_mat)
colorbar
clim([-1,1])
armtype = [{'food'}, {'water'}];
direction = [{'left'},{'right'}];
labels = [];

for comb=combinations 
    labels = [labels; {[armtype{comb(1)},' ' ,direction{comb(2)}]}];
end
xticks([1,2,3,4]);
xticklabels(labels)
yticks([1,2,3,4]);
yticklabels(labels)

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

function binned_raster = create_binned_raster_from_raster(raster, binsize)
actual_bins =  floor(size(raster,2)/binsize);

norm_raster = zscore(raster, 0, 'all');

binned_raster = [];
for row=1:size(norm_raster,1)
    [binned_raster_row,~] = histcounts(find(norm_raster(row,:)),actual_bins);
    binned_raster = [binned_raster;binned_raster_row];
end

% return window 
end