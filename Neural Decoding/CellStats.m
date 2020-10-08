function CellStats()

% 1. Load the cell data (for a given event under s apecific filering by the label) for instace
% 2. get the firing rate from the PSTH data in the time bins in interst.
% 3. Calcuate statistics such as determine responsiveness and selectivity.

raster_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters2';
event = 'Aout';
filter_labels = [{'Chosen'}];
filter_values = [1 2 3 4];

% PARAMS
baseline_range_bins = [-7,-1];
target_range_bins = [0,12];
alpha = 0.05;
consecutive_bins=2;

colors = [0, 0.4470, 0.7410
    0.8500, 0.3250, 0.0980
    0.9290, 0.6940, 0.1250
    0.4940, 0.1840, 0.5560
    0.4660, 0.6740, 0.1880
    0.3010, 0.7450, 0.9330
    0.6350, 0.0780, 0.1840
    0 0 0];

figure;

is_responsive = [];
is_selective = [];
raster_cells_data = dir([fullfile(raster_folder, event), '\*.mat']);
for cell_raster_file = fliplr(raster_cells_data')
%         if ~strcmp(cell_raster_file.name,'odor1_WR_rat10_mpfc_14.10_TT1_SS_6.mat')
%             continue
%         end
    significance = [];
    responsive = false;
    legend_arr = [];
    targets = [];
    for v=1:length(filter_values)
        cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
        [~, binned_raster] = RasterPsthUnderFilter (cell_data, filter_labels, filter_values(v));
        
        bin_size = cell_data.raster_site_info.binsize;
        binned_xaxis = cell_data.raster_site_info.cut_info(1)*1000/bin_size:cell_data.raster_site_info.cut_info(2)*1000/bin_size;
        event_bin = find(binned_xaxis==0);
        baseline_range = event_bin+baseline_range_bins(1):event_bin+baseline_range_bins(2);
        target_range = event_bin+target_range_bins(1):event_bin+target_range_bins(2);
        
        %get the bins under interest
        %win = gausswin(2)/sum(gausswin(2));
        %binned_raster = filter(win,1,binned_raster, [], 2);
        baseline_fr = binned_raster(:,baseline_range);
        baseline_fr = mean(baseline_fr,2);
        target_fr = binned_raster(:,target_range);
        
        
        for i=1:size(target_fr,2)
            significance(v,i) = ttest2(baseline_fr(:), target_fr(:,i), 'alpha', alpha, 'Vartype','unequal');
        end
        
        targets = [targets; {target_fr}];
        significance(isnan(significance))=0;
        responsive = responsive || longestConsecutiveOnes(significance(end,:))>=consecutive_bins;
        % Draw PSTH
        [psth_mean, ~, psth_sem ] = binedRasterToPSTH( binned_raster );
        options.color_line = colors(v,:);
        plot_areaerrorbar(binned_xaxis,psth_mean,psth_sem, options)
        legend_arr = [legend_arr;{num2str(v)}];
        hold on;
    end
     disp(cell_raster_file.name)
    disp (significance);
    legend(legend_arr)
    y1=get(gca,'ylim');
    plot([baseline_range_bins(1)-0.5 baseline_range_bins(1)-0.5],y1,'Color', [1 0 0]);
    plot([baseline_range_bins(end)+0.5 baseline_range_bins(end)+0.5],y1,'Color', [1 0 0]);
    plot([target_range_bins(1)-0.4 target_range_bins(1)-0.4],y1,'Color', [0 1 0]);
    plot([target_range_bins(2)+0.5 target_range_bins(2)+0.5],y1, 'Color',[0 1 0]);
    hold off;
    %[h,p] = ttest2(baseline_fr, target_fr, 'alpha', 0.05);
    
    response_type =1;% 2*mean(target_fr)>mean(baseline_fr)-1;
    
    is_responsive = [is_responsive; {cell_raster_file.name}, responsive, response_type];
    
    
    % Claculate selectivity
    % -----------------------
    if (responsive==1)
        samples = [];
        groups = [];
        pvals = [];
        
        % for each bin in target
        for i=1:size(targets{1},2)
            % for each label
            for v=1:length(filter_values)
                bin_samples = targets{v}(:,i);
                samples = [samples;bin_samples];
                groups = [groups; repmat({num2str(v)}, length(bin_samples), 1)];
            end
            % perform anova between samples values in the same bin
            [pval,tbl,stats] = anova1(samples,groups,'off' );
            pvals(i) = pval;
        end
        
        significance = pvals<alpha;
        is_selective = [is_selective; longestConsecutiveOnes(significance)>1];
    end
end

disp(is_responsive)
mean([is_responsive{:,2}])
mean(is_selective)

end


