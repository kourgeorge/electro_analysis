function [X,Y] = prepare_cell_data (st, behave, dt, proportions)
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
X = zeros(1e6,4);
Y = zeros(1e6,1);
dropped = [];

bin_bout_bins = sum(proportions(1:2))+1:sum(proportions(1:3));

for trial =1:size(event_times,1)
    start_trial_index = i;
    
    start_trial_time = event_times(trial,1);
    end_trial_time = event_times(trial,end);
    num_time_bins_in_trial = floor((end_trial_time - start_trial_time)/dt); 
    end_trial_time = end_trial_time - mod(end_trial_time - start_trial_time,dt);
    trial_time_bins = linspace(start_trial_time, end_trial_time, num_time_bins_in_trial);
    
    for bin = 1:length(trial_time_bins)-1
        
        time = trial_time_bins(bin);
        event = find(event_times(trial,:)<=time, 1, 'last');
        num_bins_in_event = proportions(event);
        start_event_time = event_times(trial,event);
        end_event_time = event_times(trial,event+1);
        time_bins_in_event = linspace(start_event_time,end_event_time, num_bins_in_event+1);
        bin_in_event = find(time_bins_in_event<=time, 1, 'last');
        %disp([num2str(event),' ',num2str(bin_in_event)])
        position = sum(proportions(1:event-1))+bin_in_event;
        
        %event_feature = zeros(1, sum(proportions));
        %event_feature(position) = 1;
        
        if event==3
            if (time-start_event_time)> 1 && (end_event_time-time)>1
                dropped = [dropped, bin_in_event ];
                continue
            end
        end
        
        %event_feature((event-1)*num_bins_in_event+bin_in_event) = 1;
        selected_arm = selected_arms(trial);
        %arm_feature = zeros(1, 4);
        %arm_feature(selected_arm) = 1;

        is_rewarded = 2 - (selected_arm==rewarded_arm1(trial) || selected_arm==rewarded_arm2(trial));
        
        %rewarded_feature = zeros(1, 2);
        %rewarded_feature(is_rewarded+1)=1;
   
        water_arm_feature = 2 - (selected_arm == 1 || selected_arm == 2);
        
        %food_arm_feature = log(length(st)/(st(end)-st(1)));
        %food_arm_feature = length(find (st>trial_time_bins(bin) & st<trial_time_bins(bin+1)));
        
        %X(i,:) = [event_feature , arm_feature , rewarded_feature, water_arm_feature];
        
        X(i,:) = [position, selected_arm, is_rewarded, water_arm_feature];
%         if find(event_feature==1)==1 || find(event_feature==1)==1
%             Y(i,:) = poissrnd(.5);
%         else
%             Y(i,:) = poissrnd(.1);
%         end
        %Y(i,:) = find(event_feature==1) * 2 + find(arm_feature==1) * 1 + randi([-3,3]);
        Y(i,:) = length(find (st>trial_time_bins(bin) & st<trial_time_bins(bin+1)));
        i=i+1;
        
    end
    
%     indices = find(sum(X(start_trial_index:i,bin_bout_bins),2));
%     if isempty(indices)
%         continue
%     end
%     
    %redistribute the BIN-BOUT bins
%     len_ind = size(indices,1);
%     alt = zeros(len_ind,proportions(3));
%     borders = int64(linspace(1,len_ind,proportions(3)+1));
%     for k=2:length(borders)
%         alt(borders(k-1):borders(k), k-1) = 1;
%     end
%     %[X(indices,bin_bout_bins),alt]
%     X(indices+start_trial_index-1,bin_bout_bins) = alt;
    
end



X=X(1:i-1,:);
Y=Y(1:i-1,:);

X = dummyvar(X);

% r=[];
% z=[];
% for i=1:sum(proportions)
%     indices_i = find(X(:,i)==1);
%     x = [x; i*ones(length(indices_i),1)];
%     bar_y = mean(Y(X(:,i)==1))
%     z = [z; Y(X(:,i)==1)];
% end
% 
% stem(x,y)
% 
% x = x + randn(length(r),1)*0.25;
% z = z + randn(length(z),1)*0.25;
% plot(r,z, '.')

% p = randperm(length(Y));
% Y=Y(p);
% 
% positions = X(:,20)==1;
% 
% Y=max(0,Y + 20*positions);

% make samples balanced with respect to the position.
% find the number of samples in each position

% filter_ind = find(X(:,6)==1 | X(:,7)==1 | X(:,8)==1 | X(:,9)==1);
% remain_ind = setdiff(1:numel(Y),filter_ind);
% X = X(remain_ind,:);
% X(:,[6,7,8,9]) = [];
% Y = Y(remain_ind);

end