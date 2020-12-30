function [is_selective,pvals,pvals2] = isMixedSelective(cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[combinations , baseline, targets, ~ ] = getCellBaselineTargetFR( cell_data, labels , baseline_range_bins, target_range_bins );

pvals = [];
pval2 = [];
num_bins_in_target = target_range_bins(2)-target_range_bins(1)+1;
num_pairs = num_bins_in_target+1;
num_bins = target_range_bins(2) - target_range_bins(1);
% alpha_selectivity = (alpha/num_pairs)^(1/min_consecutive_bins);
% alpha_selectivity = (1-(1-alpha)^(1/num_pairs))^(1/min_consecutive_bins);
% alpha_selectivity = 0.105; % for tl=6;
% alpha_selectivity = 0.078; % tl = 10;
alpha_selectivity = solve_probability_bernouli_runs(min_consecutive_bins,num_bins,alpha);

test = [];
for i=1:num_bins_in_target
    % for each label
    samples = [];
    groups = [];
    
    for v=1:length(targets)
        bin_samples = targets{v}(:,i);%-baseline{v};
        samples = [samples;bin_samples];
        groups = [groups; repmat(combinations(:,v)', length(bin_samples), 1)];
        test(v,i) = mean(bin_samples);
    end
    % perform anova between samples values in the same bin
    [pval,table,stats]= anovan(samples,groups,'model','interaction','display', 'off');
    [pval2,table,stats]= anovan(samples,groups, 'sstype', 2,'display', 'off');
    pvals(:,i) = pval;
    pvals2(:,i) = pval2;
end

significance = pvals<alpha_selectivity;
significance2 = pvals2<alpha_selectivity;
significance(isnan(significance))=0;
significance2(isnan(significance2))=0;

if (longestConsecutiveOnes(significance(3,:))>=min_consecutive_bins)
    is_selective = 'NMS';
elseif (longestConsecutiveOnes(significance2(1,:))>=min_consecutive_bins) && ...
        (longestConsecutiveOnes(significance2(2,:))>=min_consecutive_bins)
    is_selective = 'LMS';
elseif (longestConsecutiveOnes(significance2(1,:))>=min_consecutive_bins) || ...
        (longestConsecutiveOnes(significance2(2,:))>=min_consecutive_bins)
    is_selective = 'SS';
else
    is_selective = 'No';
end

% disp (pvals)
end