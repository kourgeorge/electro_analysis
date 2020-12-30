function [spike_count, spikes_rate, event_border] = ss_activity_inday (behave, st, num_bins_in_event)
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
        spikes(trial, bin) = length(find (electrode>=startbin & electrode<endbin));
        spikes_rate(trial, bin) = spikes(trial, bin) /binlength;
        
    end
end

spike_count = nansum(nansum(spikes));
spikes_rate = zscore(spikes_rate')';
spikes_rate = mean(spikes_rate,1);%/sum(nanmean(spikes,1));

end

