function [event_times, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave)

all_trials = size(behave.ITI,1);
event_times = [];
selected_arms = [];
rewarded_arm1 = [];
rewarded_arm2 = [];
removed_trails = 0;

for trial = 1:all_trials
    iti_time = behave.ITI(trial, 2);
    ain_time = behave.Abeam_entrance(find(behave.Abeam_entrance(:,4)==trial,1,'first'),2);
    bin_time = behave.Bbeam_entrance(find(behave.Bbeam_entrance(:,4)==trial,1,'first'),2);
    bout_time = behave.Bbeam_exit(find(behave.Bbeam_exit(:,4)==trial,1,'last'),2);
    aout_time = behave.Abeam_exit(find(behave.Abeam_exit(:,4)==trial,1,'last'),2);
    np_time = behave.NP_new(find(behave.NP_new(:,4)==trial,1,'last'),2);
    
    
    
    if isempty(ain_time) || isempty(np_time) || isempty(bin_time) || isempty(bout_time)|| isempty(aout_time)
        removed_trails = removed_trails + 1;
        continue;
    end
    
    if ~(iti_time <np_time && np_time <ain_time && ain_time<bin_time && bin_time<bout_time && bout_time<aout_time)
        removed_trails = removed_trails + 1;
        continue;
    end
    
    temp = [iti_time, np_time, ain_time, bin_time, bout_time, aout_time, aout_time + 2];

    %check trial length sanity
    if (temp(end)-temp(1))< 2
        continue
    end
    selected_arm = behave.Abeam_exit(find(behave.Abeam_exit(:,4)==trial,1,'last'),3);
    rewarded_arm1 = [rewarded_arm1;behave.CorrectArm1(trial,2)];
    rewarded_arm2 = [rewarded_arm2; behave.CorrectArm2(trial,2)];
    event_times = [event_times; temp];
    selected_arms = [selected_arms; selected_arm]; 
    
end
disp(['Removed ', num2str(removed_trails), ' trials from total ', num2str(all_trials)])
end
