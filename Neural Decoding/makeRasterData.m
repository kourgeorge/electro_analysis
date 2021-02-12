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

for trial=1:numel(Labels.TrialNum)
    l = '';
    if (Labels.ArmType(trial)==1 && Labels.Chosen(trial)==1) || ...
            (Labels.ArmType(trial)==2 && Labels.Chosen(trial)==3)
        l=[l,'right_'];
        Labels.direction(trial) = 1;
    else
        l=[l,'left_'];
        Labels.direction(trial) = 2;
    end
    if Labels.Rewarded(trial)
        l=[l,'R_'];
    else
        l=[l,'NR_'];
    end
    if Labels.ArmType(trial)==1
        l=[l,'food'];
    else
        l=[l,'water'];
    end
    
   Labels.combination(trial) = {l}; 
end
Labels.combination = Labels.combination';
Labels.direction = Labels.direction';

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
%AllRaster.Raster = [ITIRaster.Raster,NPRaster.Raster, AinRaster.Raster];% , BinRaster.Raster, AoutRaster.Raster];
%AllRaster.BinnedRaster = [ITIRaster.BinnedRaster,NPRaster.BinnedRaster, AinRaster.BinnedRaster];% BinRaster.BinnedRaster, AoutRaster.BinnedRaster];

%AllRaster.Raster = [BinRaster.Raster, AoutRaster.Raster];
%AllRaster.BinnedRaster = [BinRaster.BinnedRaster, AoutRaster.BinnedRaster];
AllRaster = {};
end


