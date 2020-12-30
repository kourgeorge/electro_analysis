function [time_vec,resp1,resp2,resptot,sel1,sel2,NMS] = CellsSelectivityStatsTimeLine(event,labels,baseline_length,target_length,correction,stage,from_responsive,plotOption)
%%% [resp1,resp2,resptot,sel1,sel2,NMS] = CellsSelectivityStatsTimeLine(event,labels,baseline_length,target_length,correction)
%%% Presents cells selectivity information as a continuous time function. For each Cell it finds the
%%% responsiveness and selectivity type given the event and labels.
%%% inputs:event ('ITI','NP','Ain','Bin','Aout') - type of cut to use
%%%        labels
%%%        ({'ArmType,'Rewarded'},({'ArmType','NPRewarded'},{'Chosen','Rewarded'},{'Chosen','NPRewarded'})
%%%        - labels to check selectivity to
%%%        baseline_length: number of bins (of 50ms) to use for baseline
%%%        target_length: number of bins to use as the moving target
%%%        correction: ('bonferroni','independent') - type of correction
%%%        to avoid alpha inflation. Bonferroni does not assume independent
%%%        responses to different conditions and is more conservative than indepednednt
%%%        stage indicates stage (could be 'all')
%%%        from_responsive (0,1) indicates whether to check selectivity
%%%        only among responsive neurons from same time bin, or from all

global PROJECTS_DIR

if nargin < 8
    plotOption = 1;
end
alpha = 0.05;
min_consecutive_bins=2;
min_spike_num = 100;%150;
bin_size = 50;
cut = [-1,2];

raster_folder = fullfile(PROJECTS_DIR, 'plusMazeMotivationExpt','Rasters');

stats = [];
i=0;
raster_cells_data = dir([fullfile(raster_folder, event), filesep,'*.mat']);
for cell_raster_file = fliplr(raster_cells_data')
    if ~strcmp(stage,'All')
        if ~contains(cell_raster_file.name,stage)
            continue
        end
    end
    disp (cell_raster_file.name)
    disp([num2str(i/length(raster_cells_data)*100),'%'])
    
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
    if sum(sum(cell_data.raster_data.Raster))<min_spike_num
        continue;
    end
    cut_length = size(cell_data.raster_data.Raster,2);
    binned_xaxis = cut(1)*1000/bin_size:cut(2)*1000/bin_size;
    i=i+1;
    for t = baseline_length+1:length(binned_xaxis) -  target_length
        b = t-baseline_length;
        baseline_range_bins = [binned_xaxis(1),binned_xaxis(1)+baseline_length-1];
        target_range_bins = [binned_xaxis(t),binned_xaxis(t)+target_length-1];
        [is_responsive1,pvals_responsive1, values_responsive1] = isCellResponsive( cell_data, labels(1) , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins,correction);
        [is_selective_1,pvals_selective1, values_selective1] = isCellSelective( cell_data, labels(1) , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
        [is_responsive2,pvals_responsive2, values_responsive2] = isCellResponsive( cell_data, labels(2) , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins,correction);
        [is_selective_2,pvals_selective2, values_selective2] = isCellSelective( cell_data, labels(2) , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
        [NMS,pvals_NMS, values_NMS] = isMixedSelective(cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
        
        stats = [stats; {cell_raster_file.name}, is_responsive_1, is_selective_1, is_responsive_2, is_selective_2, is_mixed_selective];
        resp1(i,b) = is_responsive_1;
        resp2(i,b) = is_responsive_2;
        resptot(i,b) = is_responsive_1 || is_responsive_2;
        if from_responsive
            sel1(i,b) = is_selective_1 && is_responsive_1;
            sel2(i,b) = is_selective_2 && is_responsive_2;
            NMS(i,b) = strcmp(is_mixed_selective,'NMS') && (is_responsive_1 || is_responsive_2);
        else
            sel1(i,b) = is_selective_1;
            sel2(i,b) = is_selective_2;
            NMS(i,b) = strcmp(is_mixed_selective,'NMS');
        end
    end
end
time_vec = (binned_xaxis(1) + baseline_length :binned_xaxis(end) - target_length );
time_vec = time_vec - (target_length - min_consecutive_bins)/2; % correct shift
time_vec = time_vec*bin_size/1000; % convert bins to time (s)
if plotOption
    plot_selectivity_figure(event,labels,baseline_length,target_length,time_vec,resp1,resp2,resptot,sel1,sel2,NMS,correction,stage);
end
end



