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