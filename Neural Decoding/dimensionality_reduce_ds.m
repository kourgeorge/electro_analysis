function [all_XTr_reduced, all_XTe_reduced] = dimensionality_reduce_ds(ds)

[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;
timebins = length(all_XTr);
splits = length(all_XTr{1});

%collect all data points of all timebins from both train and test
allX = [];
for timebin=1:timebins
    for split = 1:splits
        allX = [allX;all_XTr{timebin}{split}';all_XTe{timebin}{split}'];
    end
end

method = 'PCA';
[~, mapping] = compute_mapping(allX, method, 2);

all_XTr_reduced = [];
all_XTe_reduced = [];

for timebin=1:timebins
    for split = 1:splits
        XTr_reduced_timebin = [];
        for j=1:length(all_XTr{timebin}{1})
            sample = all_XTr{timebin}{1}(:,j)';
            XTr_reduced_timebin = [XTr_reduced_timebin; out_of_sample(sample, mapping)];
        end
        all_XTr_reduced{timebin,split} = {XTr_reduced_timebin'};
        
        XTe_reduced_timebin = [];
        for j=1:length(all_XTe{timebin}{1})
            sample = all_XTe{timebin}{1}(:,j)';
            XTe_reduced_timebin = [XTe_reduced_timebin; out_of_sample(sample, mapping)];
        end
        all_XTe_reduced{timebin,split} = {XTe_reduced_timebin'};
    end
end

end

