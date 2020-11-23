function showStatsBars(event, means, sems)

%Create responsivity and selectivity bars:
%load C:\Users\MyPC\Documents\MATLAB\RecordingAnalysis\recording_analysis\RecordingAnalysis\MeanSEM_for_Bars.mat
% This includes a Table of the mean and SEM (for errorbars) in each event 
% in each stage in the different selectivity and responsivity

% The X axis is the name of the stage:
stages = categorical({'Odor1 Motivation1','Odor2 Motivation1','Odor2 Motivation2'});

% Now create a grouped figure to each event
figure;
hold on
bar(1:3,means,'LineWidth',1.5);
ylim([0 1.2])
% Use the function below to add errorbars to the correct locations on the
% grouped bar graph:
AddSEMtoBar(means,sems);
box off
title([event , " Rats=[6,8,10,11]"])
legend({'Responsivity','ArmType','NPRewarded','Rewarded','Chosen','ArmType*NPRewarded'...
    ,'ArmType*Rewarded','Chosen*Rewarded'})



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that creates error bars in the correct place:
function AddSEMtoBar(MeanMatrix,SEMMatrix)
% Find the number of groups and the number of bars in each group
ngroups = size(MeanMatrix, 1);
nbars = size(MeanMatrix, 2);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, MeanMatrix(:,i), SEMMatrix(:,i), 'k', 'linestyle', 'none');
end
end

end