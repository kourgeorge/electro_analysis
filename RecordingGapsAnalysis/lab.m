
function lab ()
clc;
experiment = 'rat2_2104';
calculate_diff_gap_spectro(experiment);
% experiment = 'rat1_0504';
% calculate_diff_gap_spectro(experiment);
% experiment = 'rat1_0404';
% calculate_diff_gap_spectro(experiment);
% experiment = 'rat1_0205';
% calculate_diff_gap_spectro(experiment);

end

function calculate_diff_gap_spectro(experiment)
disp(experiment)
datestr=fullfile(['C:\Users\kour\OneDrive - University of Haifa\events_analysis\data\',experiment]);
[~,TimeStamps,Samples,sumGaps] = findsamplinggapgs(datestr,29);
diff = get_times_diffs(Samples, TimeStamps);
disp([sumGaps,diff, diff-sumGaps])
end