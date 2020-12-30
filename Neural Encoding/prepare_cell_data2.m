function [X, Y, feature_names, interaction_feature_name] = prepare_cell_data2 (st, behave, dt, proportions)
% Given a apiking and behavioural data, this function creates extracts
% relevant input features and responses to create dataset that can be fitted
% using GLM.
%
% Syntax:  entire_trial_view ('C:\Users\GEORGEKOUR\Desktop\Rat10_data\odor1_WR')
%
% Inputs:
%    stage_folder - The folder of the stage

[event_times, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave);


%Initilize a huge matrix to avoid increasing it size iteratively.
i=1;
X = zeros(1e6,9);
Y = zeros(1e6,1);


% for each dt
% find the time distance for each event in the suitable trial
% based on the time distance,
num_trials = size(event_times,1);
for trial=1:num_trials
    % derive the DTs on the trial
    start_trial_time = event_times(trial,1);
    end_trial_time = event_times(trial,end);
    num_time_bins_in_trial = floor((end_trial_time - start_trial_time)/dt);
    end_trial_time = end_trial_time - mod(end_trial_time - start_trial_time,dt);
    trial_time_bins = linspace(start_trial_time, end_trial_time, num_time_bins_in_trial);
    %for each bin (dt) in the trial, calaculate the distance from each event
    for bin = 1:length(trial_time_bins)-1
        
        time = trial_time_bins(bin);
        time_from_events = event_times(trial,:)-time;
        position = convert(time_from_events);
        ITI = 1; AIN = 2; BIN = 3; BOUT = 4; AOUT=5;
        
        
        selected_arm = selected_arms(trial);
        is_rewarded = 2 - (selected_arm==rewarded_arm1(trial) || selected_arm==rewarded_arm2(trial));
        arm_type = 2 - (selected_arm == 1 || selected_arm == 2);
        %X(i,:) = [position, selected_arm, is_rewarded, water_arm_feature];
        
        interaction_feature = selected_arm;
        X(i,:)=[position(AIN), position(BIN), position(AOUT), ...
            position(AIN)*interaction_feature, position(BIN)*interaction_feature, ...
            position(AOUT)*interaction_feature, selected_arm, selected_arm, is_rewarded];
        
        
        Y(i,:) = length(find (st>trial_time_bins(bin) & st<trial_time_bins(bin+1)));
        i=i+1;
        
    end    
end

X=X(1:i-1,:);
Y=Y(1:i-1,:);
interaction_feature_name = 'selected_arm';
feature_names = [{'Ain'},{'Bin'}, {'Aout'}, {['Ain',interaction_feature_name]}, ...
    {['Bin', interaction_feature_name]}, ...
    {['Aout', interaction_feature_name]}, 'arm', 'armtype', 'reward'];
end

function res = convert(dists)
res = floor(2*dists); %Why we multipky by 2.
res = min(res,3);
res = max(res,-4);
res = res+5;
end