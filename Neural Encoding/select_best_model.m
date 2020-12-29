function selected_model = select_best_model(LLH_values)
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


% To choose the best model explaining the data in the setup were we consider interaction variables
% we will perform hierarchical model selections as follows:.
% First, we select the best model which is statistically significant without interaction variables.
% Then based on the selected model we will perform model selection with interactions as follows:
% Assummig the model ABC was selected then we wicccll check 1 interaction model: A'BC, AB'C and ABC'.
% Namely, models containing 1 interaction variable but containing all the other variables.
% Interaction variables denoted by "'".
% In the next level, assuming that A'BC is the maximal model, we will check.?
% all models with two interactions that containing the interaction A', namely, A'B'C and A'BC'.
% Assume that A'B'C is maximal at this level.
% Eventually, we perform a significance test between ABC, A'BC, A'B'C and A'B'C'.
% However, if for instance, AB was selected in the first model selection process,
% in the second model selection we will investigate A'B and AB'.
% Assuming AB' is a maximal likelihood model, eventually, we will perform significance test between:
% AB, AB' and A'B'.

% The model indexing scheme:
% 1. I'B'O'
% 2. IB'O', 3. I'BO', 4. I'B'O,
% 5. IBO', 6.IB'O, 7. I'BO,
% 8. I'B', 9.I'O', 10. B'O',
% 11. IB', 12. IO' , 13.B'I , 14.B'O, 15.OI', 16. OB',
% 17. I', 18.O', 19. B',

% 20.IBO,
% 21. IB, 22.IO, 23.BO,
% 24. I, 25.B, 26. O,


% find the best single model
singleModels = 24:26;
[~,top1S] = max(nanmean(LLH_values(:,singleModels)));
top1S = top1S + singleModels(1)-1;

% find the best double model that includes the single model
if top1S == 24 % I -> IB, IO
    [~,top2S] = max(nanmean(LLH_values(:,[21 22])));
    vec = [21 22];  top2S = vec(top2S);
elseif top1S == 25 % B -> IB, BO
    [~,top2S] = max(nanmean(LLH_values(:,[21, 23])));
    vec = [21, 23]; top2S = vec(top2S);
elseif top1S == 26 % O -> IO, IB
    [~,top2S] = max(nanmean(LLH_values(:,[22 23])));
    vec = [22 23]; top2S = vec(top2S);
end

top3S = 20;

LLH1 = LLH_values(:,top1S);
LLH2 = LLH_values(:,top2S);
LLH3 = LLH_values(:,top3S);

[p_llh_12,~] = signrank(LLH2,LLH1,'tail','right');
[p_llh_23,~] = signrank(LLH3,LLH2,'tail','right');

if p_llh_12 < 0.05 % double model is sig. better
    if p_llh_23 < 0.05  % triple model is sig. better
        singles_selected_model = 20; %triple model
    else
        singles_selected_model = top2S; %double model
    end
else
    singles_selected_model = top1S; %single model
end

% % re-set if selected model is not above baseline
% pval_baseline = signrank(LLH_values(:,singles_selected_model),[],'tail','right');
% 
% if pval_baseline > 0.05
%     selected_model = NaN;
%     return
% end

%%% Selecting the model with interations

if ismember(singles_selected_model,[24,25,26])
    if singles_selected_model == 24
        top2S = 17;
    end
    if singles_selected_model == 25
        top2S = 18;
    end
    if singles_selected_model == 26
        top2S = 19;
    end
    
    LLHS = LLH_values(:,singles_selected_model);
    LLH1S1I = LLH_values(:,top2S);
    [p_llh_S_1S1I,~] = signrank(LLHS,LLH1S1I,'tail','right');
    
    if p_llh_S_1S1I< 0.05
        selected_model = top2S;
    else
        selected_model = singles_selected_model;
    end
end

if ismember(singles_selected_model,[21,22,23]) % 21. IB, 22.IO, 23.BO
    
    if singles_selected_model == 21 % IB -> I'B, IB' ->I'B'
        [~,top1S1I] = max(nanmean(LLH_values(:,[11 13])));
        vec = [11 13];
        top1S1I = vec(top1S1I); top2I = 8;
    elseif singles_selected_model == 22 % IO -> I'O, IO' ->I'O'
        [~,top1S1I] = max(nanmean(LLH_values(:,[12 15])));
        vec = [12 15];
        top1S1I = vec(top1S1I); top2I = 9;
    elseif singles_selected_model == 23 % O -> IO, IB
        [~,top1S1I] = max(nanmean(LLH_values(:,[14 16])));
        vec = [14 16];
        top1S1I = vec(top1S1I); top2I = 10;
    end
    
    LLH1 = LLH_values(:,singles_selected_model);
    LLH2 = LLH_values(:,top1S1I);
    LLH3 = LLH_values(:,top2I);
    
    [p_llh_12,~] = signrank(LLH2,LLH1,'tail','right');
    [p_llh_23,~] = signrank(LLH3,LLH2,'tail','right');
    
    if p_llh_12 < 0.05
        if p_llh_23 < 0.05
            selected_model = top2I; % 2 Interactions
        else
            selected_model = top1S1I; %1 Single 1 Interaction
        end
    else
        selected_model = singles_selected_model; %singles model
    end
    
end


if singles_selected_model==20 % 20. IBO
    [~,top2S1I] = max(nanmean(LLH_values(:,[5 6 7]))); 
    vec = [5 6 7]; %IBO', IB'O, I'BO,
    top2S1I = vec(top2S1I);
    
    [~,top1S2I] = max(nanmean(LLH_values(:,[2 3 4])));
    vec = [2 3 4]; % IB'O', I'BO', I'B'O,
    top1S2I = vec(top1S2I);
    
    LLH1 = LLH_values(:,singles_selected_model);
    LLH2 = LLH_values(:,top2S1I);
    LLH3 = LLH_values(:,top1S2I);
    
    [p_llh_12,~] = signrank(LLH2,LLH1,'tail','right');
    [p_llh_23,~] = signrank(LLH3,LLH2,'tail','right');
    
    if p_llh_12 < 0.05
        if p_llh_23 < 0.05
            selected_model = top2S1I; % 2 Singles 1 Interactions
        else
            selected_model = top1S2I; %1 Single 2 Interaction
        end
    else
        selected_model = singles_selected_model; %singles model
    end
end

% re-set if selected model is not above baseline
pval_baseline = signrank(LLH_values(:,selected_model),[],'tail','right');

if pval_baseline > 0.05
    selected_model = NaN;
    return
end

    
end
