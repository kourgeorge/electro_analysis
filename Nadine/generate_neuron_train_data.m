function [X,Y] = generate_neuron_train_data (ss_file, dt)
% Given a apiking and behavioural data, this function creates extracts 
% relevant input features and responses to create dataset that can be fitted
% using GLM.
%
% Syntax:  entire_trial_view ('C:\Users\GEORGEKOUR\Desktop\Rat10_data\odor1_WR')
%
% Inputs:
%    stage_folder - The folder of the stage

[filepath,~,~] = fileparts(ss_file);

folder_name = regexp(filepath,'\','split');
folder_name = folder_name{end};

events_path = [filepath,'\',folder_name,'events_g.mat'];
behave = load(events_path);

st=Nlx2MatSpike(ss_file,[1 0 0 0 0],0,1,[]);

[event_times, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave);
st = st / 1e6;

X = [];
Y = [];
for trial =1:size(event_times,1)
    start_trial_time = event_times(trial,1);
    end_trial_time = event_times(trial,end);
    num_bins = round((end_trial_time + 2 - start_trial_time)/dt); 
    time_bins = linspace(start_trial_time, end_trial_time, num_bins);
    
    for bin = 1:length(time_bins)-1
        interval = find(event_times(trial,:)<time_bins(bin+1), 1, 'last');
        event_feature = zeros(1, size(event_times,2)-1);
        event_feature(interval) = 1;
        selected_arm = selected_arms(trial);
        arm_feature = zeros(1, 4);
        arm_feature(selected_arm) = 1;
        reward1_feature = selected_arm==rewarded_arm1(trial);
        reward2_feature = selected_arm==rewarded_arm2(trial);
        rewarded_feature = reward1_feature || reward2_feature;
        
        food_arm_feature = selected_arm == 3 || selected_arm == 4;
        
        
        X = [X; [event_feature , arm_feature, rewarded_feature, food_arm_feature]];
        Y = [Y; length(find (st>time_bins(bin) & st<time_bins(bin+1)))];
    end
    
    
end

end