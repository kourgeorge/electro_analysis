function [all_XTr_reduced, all_XTe_reduced, XDr] = DR_ds_rec(all_XTr, all_XTe, all_YTr, all_YTe, timebin, split, allX, allY, method)
%a recursive function that reduce the dimensionality of the neural population of all splits and
%timebins.

timebins = length(all_XTr);
splits = length(all_XTr{1});

if timebin>timebins    
    XDr = compute_mapping(allX, method, 2);
 %  [B,V,U,se2,Sf] = SupPCA(allY-mean(allY,1),allX-mean(allX,1),2)
    %rank(allX)
    %XDr = gda(allX(1,:)',allX',allY',2);
    all_XTr_reduced = {};
    all_XTe_reduced = {};
    return;
end

train_size =  size(all_XTr{timebin}{split},2);
test_size = size(all_XTe{timebin}{split},2);

allX = [allX;all_XTr{timebin}{split}';all_XTe{timebin}{split}'];
allY = [allY;all_YTr;all_YTe];

if split==splits
    [all_XTr_reduced, all_XTe_reduced, XDr] = DR_ds_rec(all_XTr, all_XTe, all_YTr, all_YTe, timebin+1, 1, allX, allY, method);    
else
    [all_XTr_reduced, all_XTe_reduced, XDr] = DR_ds_rec(all_XTr, all_XTe, all_YTr, all_YTe, timebin, split+1, allX, allY, method);  
end


XTr_reduced_timebin = XDr(end-train_size-test_size+1:end-test_size,:);
XTe_reduced_timebin = XDr(end-test_size+1:end,:);
all_XTr_reduced{timebin}{split}=XTr_reduced_timebin';
all_XTe_reduced{timebin}{split}=XTe_reduced_timebin';

XDr(end-train_size-test_size+1:end,:)=[];

end