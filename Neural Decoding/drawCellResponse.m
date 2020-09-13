
function drawCellResponse(raster_folder, event, filter_labels)
%DRAWCELLRESPONSE Summary of this function goes here
%   Detailed explanation goes here

minimum_trials_in_condition = 4;
raster_cells_data = dir([fullfile(raster_folder, event), '\*.mat']);

combinations = get_all_combinations(filter_labels);

for cell_raster_file = fliplr(raster_cells_data')
%     if ~contains( cell_raster_file.name , 'odor1_WR_rat10_mpfc_14.10_TT1_SS_6')
%         continue
%     end
        
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
    xaxis = cell_data.raster_site_info.cut_info(1)*1000:cell_data.raster_site_info.cut_info(2)*1000;
    
    if sum(sum(cell_data.raster_data))<500
        continue;
    end
    figure;
    subplot(2,1,1)
    num_trials = []; raster = []; legend_arr = [];
    for i=1:size(combinations,2)
        curr_combinations = combinations(:,i)';
        [psth,tmp_raster] = PsthUnderFilter (cell_data, filter_labels, curr_combinations);
        if size(tmp_raster,1)> minimum_trials_in_condition
            num_trials = [num_trials, size(tmp_raster,1)];
            plot(xaxis, psth)
            legend_arr = [legend_arr;{['(',num2str(curr_combinations),'): ',num2str(size(tmp_raster,1))]}];
            raster = [raster; tmp_raster];
        end
        hold on;
    end
    
    legend(legend_arr)

    %legend( ['Rewarded(N) ArmType(1) : ', num2str(num_trials(1))] , ['Rewarded(N) ArmType(2) : ', num2str(num_trials(2))], ['Rewarded(Y) ArmType(1) : ', num2str(num_trials(3)) ],['Rewarded(Y) ArmType(2) : ', num2str(num_trials(4))]);
    %text(xaxis(ind),psth(ind), ['\leftarrow' , cell_data.raster_site_info.cell]);
    tit = title([cell_data.raster_site_info.event, ' ', cell_data.raster_site_info.stage,' ',cell_data.raster_site_info.date,'-',cell_data.raster_site_info.cell]);
    set(tit,'Interpreter', 'none');
    hold off;
    
    subplot(2,1,2)
    spy(raster,'.k')
    axis normal
    %set(gca,'XTick', xaxis,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    y_lines = cumsum(num_trials);
    colors = [0, 0.4470, 0.7410 
        0.8500, 0.3250, 0.0980
        0.9290, 0.6940, 0.1250
        0.4940, 0.1840, 0.5560
        0.4660, 0.6740, 0.1880
        0.3010, 0.7450, 0.9330
        0.6350, 0.0780, 0.1840
        0 0 0];
        
    for i=1:length(y_lines)
        line([0,3000],[y_lines(i),y_lines(i)], 'Color', colors(i,:));
    end
    
    %line([0,3000],[y_lines(2),y_lines(2)], 'Color',[]);
    %line([0,3000],[y_lines(3),y_lines(3)], 'Color',[]);
    %line([0,3000],[y_lines(4),y_lines(4)], 'Color', []);
end


% spy(raster, '.k')
% pbaspect([3000 2000 1])
 
% figure;
% subplot(2,1,1)
% %bar(size(psth,2),psth,'k');
% 
% axis tight
% box off
% grid off;
% subplot(2,1,2)
% spy(raster,'k.')
% %set(gca,'XTick', xaxis,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
% 
% axis normal
% 
% %Plot_title = suptitle(['Reward ',EventDate,', ',SpikeClust] );
% set(Plot_title,'Interpreter', 'none');

end


function combinations = get_all_combinations(filter_labels)
combinations = label_values(filter_labels{1});
for i=2:length(filter_labels)
    combinations = combvec(combinations, label_values(filter_labels{i}));
end
end

function allPossibilities = label_values(label)

switch label
    case 'Chosen'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm1'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm2'
        allPossibilities = [1 2 3 4];
    case 'Rewarded'
        allPossibilities = [0 1];
    case 'ArmType'
        allPossibilities = [1 2];
end

end
function [psth,raster] = PsthUnderFilter (cell_data, filter_labels, filter_values)
    win = gausswin(50)/sum(gausswin(50));
    relevant_trial = filter_trials(cell_data, filter_labels, filter_values);
    raster = cell_data.raster_data(relevant_trial,:);
    %raster = raster(any(raster ~= 0,2),:);
    psth=filter(win,1,mean(raster)*1000);
end

function relevant_trials = filter_trials(cell_data, filter_labels, filter_values)
relevant_trials=1:1000;
    for i=1:length(filter_labels)
        filter_label = filter_labels{i};
        filter_value = filter_values(i);
        tmp = find(cell_data.raster_labels.(filter_label)==filter_value);
        relevant_trials = intersect(tmp,relevant_trials);
    end
end


function gaussFilter = gauss(sigma)
width = round((6*sigma - 1)/2);
support = (-width:width);
gaussFilter = exp( -(support).^2 ./ (2*sigma^2) );
gaussFilter = gaussFilter/ sum(gaussFilter);
end

