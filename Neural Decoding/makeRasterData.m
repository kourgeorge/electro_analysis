function [nspikes, blmn, blstd, Labels, ITIRaster, AinRaster, AoutRaster, ...
    BinRaster, NPRaster, AllRaster] =  makeRasterData(behaveStruct, st, binsize, cut_info)
% Given the behavioural data and spiketimes of a cell, this function
% returns the rasters and labels for the different events for each day. 

basic_cut = [-2.5, 2.5];
windowSize = diff(basic_cut)/1;   % for baseline calculations, to create z scores

num_trials = size(behaveStruct.selected_arms,1);

Labels.TrialNum = 1:num_trials;
Labels.Chosen = behaveStruct.selected_arms;
Labels.NPChosen = behaveStruct.selected_np;
Labels.CorrectArm1 = behaveStruct.rewarded_arm1;
Labels.CorrectArm2 = behaveStruct.rewarded_arm2;
Labels.Rewarded = behaveStruct.selected_arms==behaveStruct.rewarded_arm1 | ...
    behaveStruct.selected_arms==behaveStruct.rewarded_arm2;
Labels.ArmType = 2 - (behaveStruct.selected_arms == 1 | behaveStruct.selected_arms == 2);
Labels.NPRewarded = behaveStruct.selected_np==behaveStruct.rewarded_arm1 | ...
    behaveStruct.selected_np==behaveStruct.rewarded_arm2;
Labels.CorrectArm = [behaveStruct.rewarded_arm1, behaveStruct.rewarded_arm1];
N = numel(Labels.TrialNum);

Labels.Direction = 2-(Labels.Chosen==2 | Labels.Chosen==4);
Labels.AllocentericDirection = 2-(Labels.Chosen==2 | Labels.Chosen==3);  

relevant_direction=Labels.AllocentericDirection;

for trial=1:N
    cond = '';
    condRA = '';
    condDR = '';
    condDA = '';
    if relevant_direction(trial)==1 
        cond=[cond,'right_'];
        condDR = [condDR,'right_'];
        condDA = [condDA,'right_'];
    else
        cond=[cond,'left_'];
        condDR = [condDR,'left_'];
        condDA = [condDA,'left_'];
    end
    if Labels.Rewarded(trial) 
        cond=[cond,'R_'];
        condRA=[condRA,'R_'];
        condDR = [condDR,'R'];
    else
        cond=[cond,'NR_'];
        condRA=[condRA,'NR_'];
        condDR = [condDR,'NR'];
    end
    if Labels.ArmType(trial)==1
        cond=[cond,'food'];
        condRA=[condRA,'food'];
        condDA = [condDA,'food'];
    else
        cond=[cond,'water'];
        condRA=[condRA,'water'];
        condDA = [condDA,'water'];
    end    
    
   Labels.Combination(trial) = {cond};
   Labels.RewardedArmType(trial) = {condRA};
   Labels.DirectionArmType(trial) = {condDA};
   Labels.DirectionRewarded(trial) = {condDR};
   
end

Labels.Combination = Labels.Combination'; %Fix the dimensions of Combination.
Labels.RewardedArmType = Labels.RewardedArmType';
Labels.DirectionArmType = Labels.DirectionArmType';
Labels.DirectionRewarded = Labels.DirectionRewarded';

% Duplicate to support any order of labels
Labels.ArmTypeRewarded = Labels.RewardedArmType;
Labels.ArmTypeDirection = Labels.DirectionArmType;
Labels.RewardedDirection = Labels.DirectionRewarded;

blTimeBins = st(1):windowSize:st(end);
ns = zeros(1,length(blTimeBins));
for b = 2:length(blTimeBins)
    ns(b) = length(find(st > blTimeBins(b-1) & st <= blTimeBins(b)));
end
blmn=mean(ns/windowSize);
blstd=std(ns/windowSize);
nspikes=length(st);

ITIRaster=getRasterAroundEvent(behaveStruct.event_times(:,1), st, cut_info.ITI, binsize);  
NPRaster=getRasterAroundEvent(behaveStruct.event_times(:,2), st, cut_info.NP, binsize);
AinRaster=getRasterAroundEvent(behaveStruct.event_times(:,3), st, cut_info.Ain, binsize);
BinRaster=getRasterAroundEvent(behaveStruct.event_times(:,4), st, cut_info.Bin, binsize);
AoutRaster=getRasterAroundEvent(behaveStruct.event_times(:,6), st,cut_info.Aout , binsize);
AllRaster = [ITIRaster,NPRaster, AinRaster, BinRaster, AoutRaster];

end


