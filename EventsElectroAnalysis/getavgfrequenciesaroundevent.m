function [S_event, time] = getavgfrequenciesaroundevent(S,t,interval_len, event_times)
%GETAVGFREQUENCIESAROUNDEVENT given the spectrogram (time vs, frequence) and event times, calculates
% the average frequency for each bin in the time interval around the event

dt = (t(2)-t(1))*1000; %in ms
interval_bins = floor(interval_len/(dt));
num_events = length(event_times);
for n=1:num_events
    interval_indx = getclosestindex(t, event_times(n));
    %check that the interval needed do not overflow at the beginning or at
    %the end.
    if (interval_indx-interval_bins < 1 || interval_indx+interval_bins > size(S,1))
        continue;
    end
    nan_cells = isfinite(S(interval_indx-interval_bins:interval_indx+interval_bins,:));
     if (~all(nan_cells))
        continue;
     end
    %rows: the time azis around the event.
    %columns: the frequesncies axis
    %layers: the different events spectrogram.
    tmp_3d(:,:,n) = S(interval_indx-interval_bins:interval_indx+interval_bins,:);
end
S_event = mean(tmp_3d,3);
time = linspace(-interval_len,interval_len,interval_bins*2+1);

end 

function index = getclosestindex(array, val)
[~,index] = min(abs(array-val));

end