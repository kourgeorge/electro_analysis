function [testFit,trainFit,param,numModels] = fit_all_ln_models(X,spiketrain,dt, numFolds)
%%% Description
% The model: r = exp(W*theta), where r is the predicted # of spikes, W is a
% matrix of one-hot vectors describing variable (P, H, S, or T) values, and
% theta is the learned vector of parameters.

%%% compute the position, head direction, speed, and theta phase matrices


n_arm_bins = 8;
n_rew_bins = 8;
n_armtype_bins = 4;
num_pos_bins = size(X,2)-n_arm_bins-n_rew_bins-n_armtype_bins;

posgrid = X(:,1:num_pos_bins);
armsgrid = X(:,num_pos_bins+1:num_pos_bins+n_arm_bins);
rewardgrid = X(:,num_pos_bins+n_arm_bins+1:num_pos_bins+n_arm_bins+n_rew_bins);
armtypegrid=X(:,num_pos_bins+n_arm_bins+n_rew_bins+1:num_pos_bins+n_arm_bins+n_rew_bins+n_armtype_bins);

%%% Fit all 15 LN models

numModels = 15;
testFit = cell(numModels,1);
trainFit = cell(numModels,1);
param = cell(numModels,1);
A = cell(numModels,1);
modelType = cell(numModels,1);

% ALL VARIABLES
A{1} = [ posgrid armsgrid rewardgrid armtypegrid]; modelType{1} = [1 1 1 1];
% THREE VARIABLES
A{2} = [ posgrid armsgrid rewardgrid ]; modelType{2} = [1 1 1 0];
A{3} = [ posgrid armsgrid  armtypegrid]; modelType{3} = [1 1 0 1];
A{4} = [ posgrid  rewardgrid armtypegrid]; modelType{4} = [1 0 1 1];
A{5} = [  armsgrid rewardgrid armtypegrid]; modelType{5} = [0 1 1 1];
% TWO VARIABLES
A{6} = [ posgrid armsgrid]; modelType{6} = [1 1 0 0];
A{7} = [ posgrid  rewardgrid ]; modelType{7} = [1 0 1 0];
A{8} = [ posgrid   armtypegrid]; modelType{8} = [1 0 0 1];
A{9} = [  armsgrid rewardgrid ]; modelType{9} = [0 1 1 0];
A{10} = [  armsgrid  armtypegrid]; modelType{10} = [0 1 0 1];
A{11} = [  rewardgrid armtypegrid]; modelType{11} = [0 0 1 1];
% ONE VARIABLE
A{12} = posgrid; modelType{12} = [1 0 0 0];
A{13} = armsgrid; modelType{13} = [0 1 0 0];
A{14} = rewardgrid; modelType{14} = [0 0 1 0];
A{15} = armtypegrid; modelType{15} = [0 0 0 1];

% compute a filter, which will be used to smooth the firing rate
filter = gaussmf(-4:4,[2 0]); filter = filter/sum(filter); 
%dt = post(3)-post(2); 
fr = spiketrain/dt;
smooth_fr = conv(fr,filter,'same');

% compute the number of folds we would like to do
for n = 1:numModels
    fprintf('\t- Fitting model %d of %d\n', n, numModels);
    [testFit{n},trainFit{n},param{n}] = fit_model(A{n},dt,spiketrain,filter,modelType{n},numFolds);
end
