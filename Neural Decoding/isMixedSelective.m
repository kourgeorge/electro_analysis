function is_selective = isMixedSelective(  cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[combinations , ~, targets, ~ ] = getCellBaselineTargetFR( cell_data, labels , baseline_range_bins, target_range_bins );

pvals = [];
pval2 = [];
samples = [];
groups = [];
num_bins_in_target = target_range_bins(2)-target_range_bins(1);
for i=1:num_bins_in_target
    % for each label
    for v=1:length(targets)
        bin_samples = targets{v}(:,i);
        samples = [samples;bin_samples];
        groups = [groups; repmat(combinations(:,v)', length(bin_samples), 1)];
    end
    % perform anova between samples values in the same bin
    [pval,table,stats]= anovan(samples,groups,'alpha',0.05,'model','interaction','display', 'off');
    [pval2,table,stats]= anovan(samples,groups,'alpha',0.05,'model','interaction', 'sstype', 2,'display', 'off');
    pvals(:,i) = pval;
    pvals2(:,i) = pval2;
end

significance = pvals<alpha;
significance2 = pvals2<alpha;
significance(isnan(significance))=0;
significance2(isnan(significance2))=0;

if (longestConsecutiveOnes(significance(3,:))>=min_consecutive_bins)
    is_selective = 'NMS';
elseif (longestConsecutiveOnes(significance2(1,:))>=min_consecutive_bins) && ...
        (longestConsecutiveOnes(significance2(2,:))>=min_consecutive_bins)
    is_selective = 'LMS';
elseif (longestConsecutiveOnes(significance(1,:))>=min_consecutive_bins) || ...
    (longestConsecutiveOnes(significance(2,:))>=min_consecutive_bins) 
    is_selective = 'SS';
else
    is_selective = 'No';
end

disp (pvals)
end

