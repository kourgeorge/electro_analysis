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


SS_files = dir([stage_folder,'\*\*_SS_*.ntt']); %look for all single units files in the stage
bined_spikes_all_SS = [];
spike_counts = [];
for i = 1:length(SS_files)
    
    [behave, st] = load_spikes_and_behavioral_data (SS_files(i));
    [spike_count, bined_spikes_cell, events_bins_span] = entire_trial_view_inday (behave, st, num_bins_between_events);
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
%hold on;
plot(1:size(bined_spikes_all_SS,2), y, 'black')
title(stage_folder(42:end), 'Interpreter', 'none')
xlabel(['Median:',mat2str(median_times),'[s]      bpp:', num2str(num_bins_per_proportion),'    Props:',mat2str(proportions)])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [spike_count, spikes_rate, event_border] = entire_trial_view_inday (behave, st, num_bins_in_event)
% The function returns single vector containing the average spike rate of a specific neuron during the trial.
% All trials on that day are averaged and the average is z-scored. 
% The event interval is the time between milstone events such as ITI, Ain, Bin, Bout, etc.
% Inputs:
%    SS_file - The single unite file on a specific day
%    num_bins_in_event - The number of bins that should be used in each interval
%
% Outputs:
%    behave - A struct of the behavioural information in a day
%    st - spike timesS
%    event_border - A vector indicating the border of each interval in bins terms

[event_times, ~, ~, ~] = extract_event_times(behave);

times = [];
for trial=1:size(event_times,1)
    
    % create the trial bins vector
    trial_times = [];
    event_border = [];
    for event = 1:size(event_times,2)-1
        if event == 1
            trial_times = [trial_times, linspace(event_times(trial, event), event_times(trial, event+1), num_bins_in_event(event))];
        else
            event_border = [event_border, length(trial_times)];
            trial_times = [trial_times(1:end-1), linspace(event_times(trial, event), event_times(trial, event+1), num_bins_in_event(event))];
        end
        
    end
    
    times = [times; trial_times];
end

electrode = st;

spikes = [];
spikes_rate = [];
for trial=1:size(times,1)
    
    % find num spikes between the intervals,
    for bin=1:size(times,2)-1
        startbin = times(trial, bin);
        endbin = times(trial, bin+1);
        binlength = endbin-startbin;
        spikes(trial, bin) = length(find (electrode>startbin & electrode<endbin));
        spikes_rate(trial, bin) = spikes(trial, bin) /binlength;
        
    end
end

spike_count = nansum(nansum(spikes));
spikes_rate = zscore(spikes_rate')';
spikes_rate = mean(spikes_rate,1);%/sum(nanmean(spikes,1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [median_times, proportions, num_bins_per_proportion, num_bins_between_events] = analyze_behavior_in_stage(stage_folder)
% Analyses the behavior of a given rat in a single stage - which may contain several days of behavior.
%The analysis mainly looks at the events intervals in the stage and
%provides information on how to perform the vbinning for the the time-space
%axis.
% Inputs:
%    input1 - The folder of the stage
%
% Outputs:
%    median_times - The median time the rat spends in each event interval in the stage
%    proportions - The proportions to be used when binning the intervals
%    num_bins_per_proportion - The number of bins for each unite of proportion
%    num_bins_between_events - The actual number of bins wach interval should be divided to

bin_size = 20; %ms

BHV_files = dir([stage_folder,'\*\rat*_mpfc_*.*events_g*.mat']);

all_days_events_times = [];
for i=1:length(BHV_files)
    behave = load([BHV_files(i).folder,'\',BHV_files(i).name]);
    event_times = extract_event_times(behave);
    all_days_events_times = [all_days_events_times; event_times];
end

time_between_events = event_times(:,2:end)-event_times(:,1:end-1);

% bar(1:size(a,2), mean(a));
% hold on
% er = errorbar(1:size(a,2),mean(a),std(a),std(a));
% er.Color = [0 0 0];                            
% er.LineStyle = 'none';
% 
% x=repmat(1:5,size(a,1),1);
% figure
% scatter(x(:),a(:));

median_times = round(median(time_between_events),1);
proportions = ceil((median_times)/sum(median_times+1) *10);
%proportions = round(softmax(median(a)+1, 0.1)*10);


num_bins_per_proportion = round(sum(median_times)*1000/bin_size/sum(proportions));
%num_bins_per_proportion = 100;

num_bins_between_events = proportions*num_bins_per_proportion;

end