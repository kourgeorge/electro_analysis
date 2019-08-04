function [X,Y] = generate_neuron_train_data (st, behave, dt)
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
X = zeros(1e6,23);
Y = zeros(1e6,1);
num_bins_in_event = 3;


for trial =1:size(event_times,1)
    start_trial_time = event_times(trial,1);
    end_trial_time = event_times(trial,end);
    num_time_bins_in_trial = round((end_trial_time - start_trial_time)/dt); 
    trial_time_bins = linspace(start_trial_time, end_trial_time, num_time_bins_in_trial);
    
    
    for bin = 1:length(trial_time_bins)-1
        time = trial_time_bins(bin);
        event = find(event_times(trial,:)<=time, 1, 'last');
        start_event_time = event_times(trial,event);
        end_event_time = event_times(trial,event+1);
        time_bins_in_event = linspace(start_event_time,end_event_time, num_bins_in_event+1);
        bin_in_event = find(time_bins_in_event<=time, 1, 'last');
        %disp([num2str(event),' ',num2str(bin_in_event)])
        event_feature = zeros(1, (size(event_times,2)-1)*num_bins_in_event);
        
        event_feature((event-1)*num_bins_in_event+bin_in_event) = 1;
        selected_arm = selected_arms(trial);
        arm_feature = zeros(1, 4);
        arm_feature(selected_arm) = 1;
        reward1_feature = selected_arm==rewarded_arm1(trial);
        reward2_feature = selected_arm==rewarded_arm2(trial);
        is_rewarded = reward1_feature || reward2_feature;
        rewarded_feature = zeros(1, 2);
        rewarded_feature(is_rewarded+1)=1;
   
        water_arm_feature = selected_arm == 1 || selected_arm == 2;
        food_arm_feature = selected_arm == 3 || selected_arm == 4;
        
        %food_arm_feature = log(length(st)/(st(end)-st(1)));
        %food_arm_feature = length(find (st>trial_time_bins(bin) & st<trial_time_bins(bin+1)));
        
        X(i,:) = [event_feature , arm_feature , rewarded_feature, food_arm_feature, water_arm_feature];
        Y(i,:) = length(find (st>trial_time_bins(bin) & st<trial_time_bins(bin+1)));
        i=i+1;
        
    end
      
end
X=X(1:i,:);
Y=Y(1:i,:);

% p = randperm(length(Y));
% Y=Y(p);
% 
% positions = X(:,20)==1;
% 
% Y=max(0,Y + 20*positions);


end