function entire_trial_view (stage_folder)
% Returns a heat-map of all neural activity in a single stage. Every line
% is the avrage activity of a single neuron during the entire day - averaged over different trials. 
% It gives a holistic view of the entire trial, rather than the classical view of the activity around event.
% Depending on the rat behavior in the stage, this function determine how
% it should partition the trial into bins - longer intervals recieves more
% bins. Using these binning, the function claculates the spike rates in
% each cell.
%
% Syntax:  entire_trial_view ('C:\Users\GEORGEKOUR\Desktop\Rat10_data\odor1_WR')
%
% Inputs:
%    stage_folder - The folder of the stage


[median_times, proportions, num_bins_per_proportion, num_bins_between_events] = analyze_behavior_in_stage(stage_folder);


SS_files = dir([stage_folder,'*\*_SS_*.ntt']); %look for all single units files in the stage
bined_spikes_all_SS = [];
spike_counts = [];
for i = 1:length(SS_files)
   
    [behave, st] = load_spikes_and_behavioral_data ([SS_files(i).folder,'\',SS_files(i).name]);
    [spike_count, bined_spikes_cell, events_bins_span] = ss_activity_inday (behave, st, num_bins_between_events);
    bined_spikes_all_SS = [bined_spikes_all_SS; bined_spikes_cell];
    spike_counts = [spike_counts, spike_count];
end

figure('units','normalized','outerposition',[0 0 1 1])
heatmap(bined_spikes_all_SS, 1:size(bined_spikes_all_SS,2), spike_counts, [] ,'Colorbar', true)

for i=1:length(events_bins_span)
    vline(events_bins_span(i),'r')
end

w = gausswin(30);
y = filter(w,1,mean(bined_spikes_all_SS));
yyaxis right
%pause(1);
hold on;
plot(1:size(bined_spikes_all_SS,2), y, 'black')
title(stage_folder(42:end), 'Interpreter', 'none')
xlabel(['Median:',mat2str(median_times),'[s]      bpp:', num2str(num_bins_per_proportion),'    Props:',mat2str(proportions)])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

