function is_selective = isCellSelective( cell_data, labels , baseline_range_bins, target_range_bins, alpha, min_consecutive_bins)
%IS Summary of this function goes here
%   Detailed explanation goes here

[~ , ~, targets, ~ ] = getCellBaselineTargetFR( cell_data, labels , baseline_range_bins, target_range_bins );

is_selective = [];
samples = [];
groups = [];
pvals = [];

% for each bin in target
num_bins_in_target = target_range_bins(2)-target_range_bins(1);
for i=1:num_bins_in_target
    % for each label
    for v=1:length(targets)
        bin_samples = targets{v}(:,i);
        samples = [samples;bin_samples];
        groups = [groups; repmat({num2str(v)}, length(bin_samples), 1)];
    end
    % perform anova between samples values in the same bin
    pval= anova1(samples,groups,'off');
    pvals(i) = pval;
end


significance = pvals<alpha;
significance(isnan(significance))=0;
is_selective = [is_selective; longestConsecutiveOnes(significance)>=min_consecutive_bins];

disp(labels)
disp(pvals)


end

