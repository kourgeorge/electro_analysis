function drawCellResponse(raster_folder, event, filter_labels)
%DRAWCELLRESPONSE This script draws PSTH and rasters of neural activity
% given the raster data provided by the create raster function. It goas over
% all cells and draws the rasters and psth for a given time event and given
% filters it shows this information for each label value (or combination of labels.)
% Usage: 
%  No Fiter:    drawCellResponse('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters_test', 'NP', [])
%  With Filter: drawCellResponse('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters_test', 'NP', [{'ArmType'},{'Rewarded'}])

minimum_trials_in_condition = 4;
raster_cells_data = dir([fullfile(raster_folder, event), '\*.mat']);

combinations = getLabelsCombinations(filter_labels);

colors = [0, 0.4470, 0.7410 
        0.8500, 0.3250, 0.0980
        0.9290, 0.6940, 0.1250
        0.4940, 0.1840, 0.5560
        0.4660, 0.6740, 0.1880
        0.3010, 0.7450, 0.9330
        0.6350, 0.0780, 0.1840
        0 0 0];
    
for cell_raster_file = fliplr(raster_cells_data')
%     if ~contains( cell_raster_file.name , 'odor1_WR_rat10_mpfc_14.10_TT1_SS_6')
%         continue
%     end
        
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
    xaxis = cell_data.raster_site_info.cut_info(1)*1000:cell_data.raster_site_info.cut_info(2)*1000;
    
    if sum(sum(cell_data.raster_data.Raster))<500
        continue;
    end
    
    figure;
    subplot(2,1,1)
    num_trials = []; raster = []; legend_arr = [];

    if isempty(combinations)
        [psth_mean,~,raster] = RasterPsthUnderFilter (cell_data, filter_labels, []);
        raster = {raster};
        bar(xaxis,psth_mean,'k');
        axis tight
    else
        raster=[];
        for i=1:size(combinations,2)
            curr_combinations = combinations(:,i)';
            [psth_mean,psth_sem, tmp_raster] = RasterPsthUnderFilter (cell_data, filter_labels, curr_combinations);
            if size(tmp_raster,1)> minimum_trials_in_condition
                num_trials = [num_trials, size(tmp_raster,1)];
                options.color_line = colors(i,:);
                plot_areaerrorbar(1:size(psth_mean,2),psth_mean,psth_sem,options) 
                legend_arr = [legend_arr;{['(',num2str(curr_combinations),'): ',num2str(size(tmp_raster,1))]}];
                
                if isempty(raster)
                    raster = {tmp_raster};
                else
                    raster = [raster; {[zeros(size(raster{end},1), size(tmp_raster,2));tmp_raster]}];
                end
            end
            hold on;
        end
    legend(legend_arr)   
    end
    axis tight;
    hold off;
    
    
    axpsth = gca;
    ylim([0, Inf])
    axpsth.XAxis.Visible = 'off';
    axpsthPos = axpsth.Position;
    box off
    
    tit = title([cell_data.raster_site_info.event, ' ', cell_data.raster_site_info.stage,' ',cell_data.raster_site_info.date,'-',cell_data.raster_site_info.cell]);
    set(tit,'Interpreter', 'none');
    
    
    % Drawing the Rasters
    subplot(2,1,2)
    if isempty(combinations)
        spy(raster{1},'.k')
    else
        for k=1:length(raster)
            spy(raster{k})
            ax = gca;
            ax.Children(1).Color = colors(k,:);
            hold on
        end
        hold off
        ax.XTick = linspace(0,size(raster{1},2),4); 
    end
    axis normal
    box off
    grid off;
    ax = gca;
    cut=cell_data.raster_site_info.cut_info;
    ax.XTick = linspace(0,size(raster{1},2),4); 
    ax.XTickLabel = {num2str(cut(1)),'0','1',num2str(cut(2))};
    ddPos = ax.Position;
    ax.Position = [ddPos(1);axpsthPos(2)-ddPos(4);ddPos(3);ddPos(4)];
    ax.YAxis.Visible = 'off';
    xlabel('')
    
end
end




