function [stats, agg_results] = CellsSelectivityStats(event, labels, stage, rat)
%%% Presents cells selectivity information. For each Cell it finds the
%%% responsiveness and selectivity type given the event and labels.
global PROJECTS_DIR

% raster_folder = '/Users/gkour/Box/phd/Electro_Rats/Rasters_test';
raster_folder = fullfile(PROJECTS_DIR, 'plusMazeMotivationExpt','Rasters');

% event = 'ITI';
% labels = [{'ArmType'},{'NPRewarded'}];
show_cell_plot = false;
baseline_range_bins = [-7,-1];
target_range_bins = [0,12];
%baseline_range_bins = [-19,-13];
%target_range_bins = [-12,0];
alpha = 0.05;

min_consecutive_bins=2;

stats = [];
i=1;
% stage = 'odor1';
% rat = 'rat11';
num_cells = 0;
raster_cells_data = dir([fullfile(raster_folder, event), '/*.mat']);

cells_values_responsive_1 = [];
cells_values_responsive_2 = [];

for cell_raster_file = fliplr(raster_cells_data')
    
%     if ~strcmp(cell_raster_file.name,'odor1_WR_rat11_mpfc_14.10_TT4_SS_27.mat') %spatial_WR_rat11_mpfc_22.10_TT4_SS_4.mat
%         continue
%     end

    if ~(contains(cell_raster_file.name,stage) &&  contains(cell_raster_file.name,rat))
        continue
    end

    disp (cell_raster_file.name)
    disp(i/length(raster_cells_data)*100)
    
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
%     if sum(sum(cell_data.raster_data.Raster))<200
%         continue;
%     end
    num_cells = num_cells+1;
    i=i+1;
    [is_responsive_1,responsive_pvals_1, values_responsive_1] = isCellResponsive( cell_data, labels(1) , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins);
    [is_selective_1,selective_pvals_1] = isCellSelective( cell_data, labels(1) , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
    [is_responsive_2,responsive_pvals_2, values_responsive_2] = isCellResponsive( cell_data, labels(2) , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins);
    [is_selective_2,selective_pvals_2] = isCellSelective( cell_data, labels(2) , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
    [is_mixed_selective,mixed_pvals_1,mixed_pvals_2] = isMixedSelective(cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins );
    cells_values_responsive_1 = [cells_values_responsive_1; values_responsive_1];
    cells_values_responsive_2 = [cells_values_responsive_2; values_responsive_2];
    stats = [stats; {cell_raster_file.name}, is_responsive_1, is_selective_1, is_responsive_2, is_selective_2, is_mixed_selective];
    
    if show_cell_plot 
        psth_plot = drawCellResponse(cell_data, labels);
        binsize = cell_data.raster_site_info.binsize;
        binned_xaxis = cell_data.raster_site_info.cut_info(1)*1000/binsize:cell_data.raster_site_info.cut_info(2)*1000/binsize;
        event_bin = find(binned_xaxis==0);
        y1=get(psth_plot,'ylim');
        hold(psth_plot,'on')
        plot(psth_plot, [event_bin+baseline_range_bins(1)-0.5 event_bin+baseline_range_bins(1)-0.5],y1,'Color', [1 0 0]);
        plot(psth_plot, [event_bin+baseline_range_bins(end)+0.5 event_bin+baseline_range_bins(end)+0.5],y1,'Color', [1 0 0]);
        plot(psth_plot, [event_bin+target_range_bins(1)-0.4 event_bin+target_range_bins(1)-0.4],y1,'Color', [0 1 0]);
        plot(psth_plot, [event_bin+target_range_bins(2)+0.5 event_bin+target_range_bins(2)+0.5],y1, 'Color',[0 1 0]);
        hold(psth_plot,'off')
    end
end


responsive1 = cell2mat(stats(:,2));
selective1 = cell2mat(stats(:,3));
responsive2 = cell2mat(stats(:,4));
selective2 = cell2mat(stats(:,5));

responsive_per1 = mean(responsive1);
responsive_per2 = mean(responsive2);

if sum(responsive1==1)>0
    selective_per1 = sum(responsive1==1 & selective1==1)/sum(responsive1==1);
else
    selective_per1 = 0;
end

if sum(responsive2==1) >0
    selective_per2 = sum(responsive2==1 & selective2==1)/sum(responsive2==1);
else
    selective_per2 = 0;
end

no_per = sum(strcmp(stats(:,6),'No'));
ss_per = sum(strcmp(stats(:,6),'SS'));
lms_per = sum(strcmp(stats(:,6),'LMS'));
nms_per = sum(strcmp(stats(:,6),'NMS'));

responsive_to_either = (responsive1==1 | responsive2==1);
no_per_rel = sum(strcmp(stats(:,6),'No') & responsive_to_either);
ss_per_rel = sum(strcmp(stats(:,6),'SS')& responsive_to_either);
lms_per_rel = sum(strcmp(stats(:,6),'LMS')& responsive_to_either);
nms_per_rel = sum(strcmp(stats(:,6),'NMS')& responsive_to_either);

%disp(stats)

eps = 0.0001;

agg_results = [responsive_per1, responsive_per2, selective_per1, selective_per2...
    ss_per_rel/sum(responsive_to_either) lms_per_rel/sum(responsive_to_either)...
    nms_per_rel/sum(responsive_to_either), num_cells];

% f = figure;
% subplot(2,3,1)
% X = [1-responsive_per1+eps responsive_per1];
% pie(X)
% legend([{'Non Responsive'},{'Responsive'}])
% title(['Responsive Cells: ',labels{1}])
% 
% 
% subplot(2,3,2)
% X = [1-responsive_per2+eps responsive_per2];
% pie(X)
% legend([{'Non Responsive'},{'Responsive'}])
% title(['Responsive Cells: ',labels{2}])
% 
% subplot(2,3,4)
% X = [1-selective_per1+eps selective_per1];
% pie(X)
% legend([{'Non Selective'},{'Selective'}])
% title(['Selective Cells From Responsive: ',labels{1}])
% 
% subplot(2,3,5)
% X = [1-selective_per2+eps selective_per2];
% pie(X)
% legend([{'Non Selective'},{'Selective'}])
% title(['Selective Cells From Responsive: ',labels{2}])
% 
% 
% subplot(2,3,3)
% X = [no_per+eps ss_per+eps lms_per+eps nms_per+eps];
% pie(X)
% legend([{'Non Selective'},{'SS'},{'LMS'},{'NMS'}])
% title('Mixed Selectivity Type over all Cells')
% 
% 
% subplot(2,3,6)
% X = [no_per_rel+eps ss_per_rel+eps lms_per_rel+eps nms_per_rel+eps];
% pie(X)
% legend([{'Non Selective'},{'SS'},{'LMS'},{'NMS'}])
% title('Mixed Selectivity Type from responsive Cells')
% 
% suptitle(['Selectivity: ', event,' ',stage, ' ', labels{1},'+', labels{2}, ...
%     ' minbins:',num2str(min_consecutive_bins), ' cells:', num2str(num_cells), rat])

%saveas(f, fullfile(pwd,[event,'_',labels{1},'-' ,labels{2},'_',stage,'_', rat]))

%save('stats-res.mat','stats')
end


