function [all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = augment_ds(ds, factor)
%AUGMENT_DS Summary of this function goes here
%   Detailed explanation goes here


[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;
timebins = length(all_XTr);
splits = length(all_XTr{1});

all_XTr_aug=cell(1,timebins);
all_XTe_aug=cell(1,timebins);

for timebin=1:timebins
    for split = 1:splits
        [Xt_aug, all_YTr_aug] = augment_pseudo_population(all_XTr{timebin}{split}', all_YTr, factor);
        all_XTr_aug{timebin}{split} = Xt_aug';
        [Xe_aug, all_YTe_aug] = augment_pseudo_population(all_XTe{timebin}{split}', all_YTe, factor);
        all_XTe_aug{timebin}{split} = Xe_aug';
    end
end

end


