function [S_event, time] = getavglfpactivityaroundevent(lfp,t,interval_len, event_times)



dt = (t(2)-t(1))*1000; %in ms
interval_bins = floor(interval_len/(dt));
num_events = length(event_times);
for n=1:num_events
    interval_indx = getclosestindex(t, event_times(n));
    %check that the interval needed do not overflow at the beginning or at
    %the end.
    if (interval_indx-interval_bins < 1 || interval_indx+interval_bins > length(lfp))
        continue;
    end
    %rows: the time azis around the event.
    %columns: the frequesncies axis
    %layers: the different events spectrogram.
    tmp(:,n) = lfp(interval_indx-interval_bins:interval_indx+interval_bins);
end
S_event = mean(tmp,2);
S_event = [S_event,std(tmp,1,2)/sqrt(num_events)];
time = linspace(-interval_len,interval_len,interval_bins*2+1);

end 

function index = getclosestindex(array, val)
[~,index] = min(abs(array-val));

end