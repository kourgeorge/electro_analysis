function CellStats()

% 1. Load the cell data (for a given event under s apecific filering by the label) for instace
% 2. get the firing rate from the PSTH data in the time bins in interst.
% 3. Calcuate statistics such as determine responsiveness and selectivity.

raster_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters2';
event = 'Aout';
labels = [{'Chosen'},{'Rewarded'}];
addplot = false;

% PARAMS
baseline_range_bins = [-7,-1];
target_range_bins = [0,12];
alpha = 0.05;
min_consecutive_bins=2;

stats = [];
i=1;
raster_cells_data = dir([fullfile(raster_folder, event), '\*.mat']);
for cell_raster_file = fliplr(raster_cells_data')

    
%     if ~strcmp(cell_raster_file.name,'spatial_WR_rat11_mpfc_22.10_TT3_SS_6.mat')
%         continue
%     end
    

    disp (cell_raster_file.name)
    disp(i/length(raster_cells_data)*100)
    
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
    if sum(sum(cell_data.raster_data.Raster))<150
        continue;
    end
    i=i+1;
    is_responsive_1 = isCellResponsive( cell_data, labels(1) , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins);
    is_selective_1 = isCellSelective( cell_data, labels(1) , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
    is_responsive_2 = isCellResponsive( cell_data, labels(2) , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins);
    is_selective_2 = isCellSelective( cell_data, labels(2) , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins);
    is_mixed_selective = isMixedSelective(cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins );
    
    stats = [stats; {cell_raster_file.name}, is_responsive_1, is_selective_1, is_responsive_2, is_selective_2, is_mixed_selective];
    if addplot 
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

selective_per1 = sum(responsive1==1 & selective1==1)/sum(responsive1==1);
selective_per2 = sum(responsive2==1 & selective2==1)/sum(responsive2==1);

no_per = sum(strcmp(stats(:,6),'No'));
ss_per = sum(strcmp(stats(:,6),'SS'));
lms_per = sum(strcmp(stats(:,6),'LMS'));
nms_per = sum(strcmp(stats(:,6),'NMS'));

responsive_to_either = (responsive1==1 | responsive2==1);
no_per_rel = sum(strcmp(stats(:,6),'No') & responsive_to_either);
ss_per_rel = sum(strcmp(stats(:,6),'SS')& responsive_to_either);
lms_per_rel = sum(strcmp(stats(:,6),'LMS')& responsive_to_either);
nms_per_rel = sum(strcmp(stats(:,6),'NMS')& responsive_to_either);


figure;
subplot(2,3,1)
X = [1-responsive_per1 responsive_per1];
pie(X)
legend([{'Non Responsive'},{'Responsive'}])
title(['Responsive Cells: ',labels{1}])


subplot(2,3,2)
X = [1-responsive_per2 responsive_per2];
pie(X)
legend([{'Non Responsive'},{'Responsive'}])
title(['Responsive Cells: ',labels{2}])

subplot(2,3,4)
X = [1-selective_per1 selective_per1];
pie(X)
legend([{'Non Selective'},{'Selective'}])
title(['Selective Cells From Responsive: ',labels{1}])

subplot(2,3,5)
X = [1-selective_per2 selective_per2];
pie(X)
legend([{'Non Selective'},{'Selective'}])
title(['Selective Cells From Responsive: ',labels{2}])


subplot(2,3,3)
X = [no_per ss_per lms_per nms_per];
pie(X)
legend([{'Non Selective'},{'SS'},{'LMS'},{'NMS'}])
title('Mixed Selectivity Type over all Cells')


subplot(2,3,6)
X = [no_per_rel ss_per_rel lms_per_rel nms_per_rel];
pie(X)
legend([{'Non Selective'},{'SS'},{'LMS'},{'NMS'}])
title('Mixed Selectivity Type from responsive Cells')

suptitle(['Selectivity Analysis: ', event, ' ', labels{1},'+', labels{2}])


disp(stats)
% mean(stats(:,2))
% mean(stats(:,3))

end


