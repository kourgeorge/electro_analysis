function [all_XTr_reduced, all_XTe_reduced] = dimensionality_reduce_ds(all_XTr, all_XTe, all_YTr, all_YTe)
method = 'PCA';
[all_XTr_reduced, all_XTe_reduced] = DR_ds_rec(all_XTr, all_XTe, all_YTr, all_YTe, 1, 1, [], [],  method);

end