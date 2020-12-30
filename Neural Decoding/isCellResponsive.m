function is_responsive = isCellResponsive( event_cell_data, label , baseline_range_bins, target_range_bins , alpha, min_consecutive_bins,correction)
%ISCELLRESPONSIVE Given cell data checks if the cell is responsive for a
%given label.

if nargin < 7
    correction = 'bonferroni';
end
% colors = [0, 0.4470, 0.7410
%     0.8500, 0.3250, 0.0980
%     0.9290, 0.6940, 0.1250
%     0.4940, 0.1840, 0.5560
%     0.4660, 0.6740, 0.1880
%     0.3010, 0.7450, 0.9330
%     0.6350, 0.0780, 0.1840
%     0 0 0];

%figure;

label_values = getLabelValues(label{1});

significance = [];
pvals = [];
is_responsive = false;
legend_arr = [];
num_pairs = target_range_bins(2) - target_range_bins(1) - min_consecutive_bins +2;
num_bins = target_range_bins(2) - target_range_bins(1)+1;
% alpha_selectivity = (alpha/num_pairs)^(1/min_consecutive_bins);
% alpha_selectivity = (1-(1-alpha)^(1/num_pairs))^(1/min_consecutive_bins);
% alpha_selectivity = 0.105; % for tl=6;
% alpha_selectivity = 0.078; % tl = 10;
alpha_selectivity = solve_probability_bernouli_runs(min_consecutive_bins,num_bins,alpha);
switch correction
    case 'independent'
alpha_responsivity = alpha_selectivity/((length(label_values))^(1/min_consecutive_bins)); % correction for multiple conditions, assuming independence between conditions
    case 'bonferroni'
        alpha_responsivity = alpha_selectivity/length(label_values); % correction for multiple conditions using bonferroni correction
    otherwise
        error('missing correction type')
end
[label_values, baseline, targets, binned_raster ]  = getCellBaselineTargetFR( event_cell_data, label , baseline_range_bins, target_range_bins );

values_responsive = [];
for v=1:length(label_values)
    baseline_fr = baseline{v};
    target_fr = targets{v};
    for i=1:size(target_fr,2)
        [~ , pval] = ttest2(baseline_fr(:), target_fr(:,i), 'alpha', alpha, 'Vartype','unequal');
        %         significance(v,i) = sig;
        pvals(v,i)=pval;
    end
    
    %     significance(isnan(significance))=0;
    significance = pvals < alpha_responsivity;
    value_responsive = longestConsecutiveOnes(significance(end,:))>min_consecutive_bins;
    is_responsive = is_responsive || longestConsecutiveOnes(significance(end,:))>=min_consecutive_bins;
    values_responsive = [values_responsive, value_responsive];
    %    [psth_mean, ~, psth_sem ] = binedRasterToPSTH( binned_raster{v} );
    
    %     options.color_line = colors(v,:);
    %     event_cell_data.raster_site_info.binsize;
    %     bin_size = event_cell_data.raster_site_info.binsize;
    %     binned_xaxis = event_cell_data.raster_site_info.cut_info(1)*1000/bin_size:event_cell_data.raster_site_info.cut_info(2)*1000/bin_size;
    %     plot_areaerrorbar(binned_xaxis,psth_mean,psth_sem, options)
    %     legend_arr = [legend_arr;{num2str(v)}];
    %     hold on;
    
end
% info = event_cell_data.raster_site_info;
% tit = title([info.event, ' ' ,info.date, ' ',  info.cell, ' ', info.stage  ]);
% set(tit,'Interpreter', 'none');
% legend(legend_arr)
% y1=get(gca,'ylim');
% plot([baseline_range_bins(1)-0.5 baseline_range_bins(1)-0.5],y1,'Color', [1 0 0]);
% plot([baseline_range_bins(end)+0.5 baseline_range_bins(end)+0.5],y1,'Color', [1 0 0]);
% plot([target_range_bins(1)-0.4 target_range_bins(1)-0.4],y1,'Color', [0 1 0]);
% plot([target_range_bins(2)+0.5 target_range_bins(2)+0.5],y1, 'Color',[0 1 0]);
% hold off;
end

