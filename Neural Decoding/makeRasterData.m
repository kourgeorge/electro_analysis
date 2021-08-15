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


for trial=1:N
    cond = '';
    cond2 = '';
    if (Labels.ArmType(trial)==1 && Labels.Chosen(trial)==1) || ...
            (Labels.ArmType(trial)==2 && Labels.Chosen(trial)==4)
        cond=[cond,'right_'];
        direction = 1;
    else
        cond=[cond,'left_'];
        direction = 2;
    end
    Labels.Direction(trial) = direction;
    
    if Labels.Rewarded(trial)
        cond=[cond,'R_'];
    else
        cond=[cond,'NR_'];
    end
    if Labels.ArmType(trial)==1
        cond=[cond,'food'];
    else
        cond=[cond,'water'];
    end    
    
   Labels.Combination(trial) = {cond};
   Labels.Combination2(trial) = {cond2}; 
   
end
%Fix the dimensions of Combination and Direction.
Labels.Combination = Labels.Combination';
Labels.Combination2 = Labels.Combination2';
Labels.Direction = Labels.Direction';

%Labels.Combination = Labels.Combination(randperm(length(Labels.Combination)));

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


