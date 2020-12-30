function [is_selective,pvals,values_selective] = isCellSelective( cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins)
%IS Summary of this function goes here
%   Detailed explanation goes here

[~ , baseline, targets, ~ ] = getCellBaselineTargetFR( cell_data, labels , baseline_range_bins, target_range_bins );

pvals = [];
num_pairs = target_range_bins(2)-target_range_bins(1)-min_consecutive_bins+2;
num_bins = target_range_bins(2) - target_range_bins(1);
% alpha_selectivity = (alpha/num_pairs)^(1/min_consecutive_bins);
% alpha_selectivity = (1-(1-alpha)^(1/num_pairs))^(1/min_consecutive_bins);
% alpha_selectivity = 0.105; % for tl=6;
% alpha_selectivity = 0.078; % tl = 10;
alpha_selectivity = solve_probability_bernouli_runs(min_consecutive_bins,num_bins,alpha);

type = 0;
values_selective = [];
% for each bin in target
num_bins_in_target = target_range_bins(2)-target_range_bins(1)+1;
for i=1:num_bins_in_target
    samples = [];
    groups = [];
    % for each label
    for v=1:length(targets)
        switch type
            case 0
                bin_samples = targets{v}(:,i);
            case 1
                bin_samples = targets{v}(:,i)-baseline{v};
            otherwise
                sigma = std(cell2mat(baseline));
                mu = mean(cell2mat(baseline));
                bin_samples = (targets{v}(:,i)-mu)/sigma;
        end
        samples = [samples;bin_samples];
        groups = [groups; repmat({num2str(v)}, length(bin_samples), 1)];
    end
    % perform anova between samples values in the same bin
    %     if (length(targets)==2)
    %         [~ , pval] = ttest2(samples([groups{:}]=='1'), samples([groups{:}]=='2'), 'alpha', alpha, 'Vartype','unequal');
    %     else
    %         pval= anova1(samples,groups,'off');
    %
    %     end
    pval= anova1(samples,groups,'off');
    pvals(i) = pval;
    
end


significance = pvals<alpha_selectivity;
significance(isnan(significance))=0;
is_selective = longestConsecutiveOnes(significance)>=min_consecutive_bins;

% disp(labels)
% disp(pvals)


end