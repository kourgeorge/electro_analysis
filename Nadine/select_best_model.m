function selected_model = select_best_model(testFit, numFolds, numModels)
%% Description
% This code will implement forward feature selection in order to determine
% the simplest model that best describes neural spiking. First, the
% highest-performing single-variable model is identified. Then, the
% highest-perfmoring double-variable model that includes the
% single-variable model is identified. This continues until the full model
% is identified. Next, statistical tests are applied to see if including
% extra variables significantly improves model performance. The first time
% that including variable does NOT signficantly improve performance, the
% procedure is stopped and the model at that point is recorded as the
% selected model.

% the model indexing scheme:
% PAst, PAs, PAT, PRt, ARt, PA, PR, pt, AR, ht, st, p,  h,  s,  t
% 1      2    3    4    5    6  7   8   9   10  11  12  13  14  15



testFit_mat = cell2mat(testFit);
LLH_values = reshape(testFit_mat(:,3),numFolds,numModels);



% find the best single model
singleModels = 12:15;
[max1LLH,top1] = max(nanmean(LLH_values(:,singleModels))); 
top1 = top1 + singleModels(1)-1;

% find the best double model that includes the single model
if top1 == 12 % P -> PA, PR, PT
    [~,top2] = max(nanmean(LLH_values(:,[6 7 8])));
    vec = [6 7 8]; 
    top2 = vec(top2);
elseif top1 == 13 % A -> PA, HR, AT
    [~,top2] = max(nanmean(LLH_values(:,[6 9 10])));
    vec = [6 9 10]; top2 = vec(top2);
elseif top1 == 14 % R -> PR, AR, RT
    [~,top2] = max(nanmean(LLH_values(:,[7 9 11])));
    vec = [7 9 11]; top2 = vec(top2);
else % T -> PT, AT, RT
    [~,top2] = max(nanmean(LLH_values(:,[8 10 11])));
    vec = [8 10 11]; top2 = vec(top2);
end

% find the best triple model that includes the double model
if top2 == 6 % PA-> PAS, PAT
    [~,top3] = max(nanmean(LLH_values(:,[2 3])));
    vec = [2 3]; top3 = vec(top3);
elseif top2 == 7 % PR -> PAS, PRT
    [~,top3] = max(nanmean(LLH_values(:,[2 4])));
    vec = [2 4]; top3 = vec(top3);
elseif top2 == 8 % PT -> PAT, PRT
    [~,top3] = max(nanmean(LLH_values(:,[3 4])));
    vec = [3 4]; top3 = vec(top3);
elseif top2 == 9 % AR -> PAS, ART
    [~,top3] = max(nanmean(LLH_values(:,[2 5])));
    vec = [2 5]; top3 = vec(top3);
elseif top2 == 10 % HT -> PAT, ART
    [~,top3] = max(nanmean(LLH_values(:,[3 5])));
    vec = [3 5]; top3 = vec(top3);
elseif top2 == 11 % ST -> PRT, ART
    [~,top3] = max(nanmean(LLH_values(:,[4 5])));
    vec = [4 5]; top3 = vec(top3);
end

top4 = 1;
LLH1 = LLH_values(:,top1); LLH2 = LLH_values(:,top2);
LLH3 = LLH_values(:,top3); LLH4 = LLH_values(:,top4);

[p_llh_12,~] = signrank(LLH2,LLH1,'tail','right');
[p_llh_23,~] = signrank(LLH3,LLH2,'tail','right');
[p_llh_34,~] = signrank(LLH4,LLH3,'tail','right');


if p_llh_12 < 0.05 % double model is sig. better
    if p_llh_23 < 0.05  % triple model is sig. better
        if p_llh_34 < 0.05 % full model is sig. better
            selected_model = 1; % full model
        else
            selected_model = top3; %triple model
        end
    else
        selected_model = top2; %double model
    end
else
    selected_model = top1; %single model
end

% re-set if selected model is not above baseline
pval_baseline = signrank(LLH_values(:,selected_model),[],'tail','right');

% if pval_baseline > 0.05
%     selected_model = NaN;
% end
