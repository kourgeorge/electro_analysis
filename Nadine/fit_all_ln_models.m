function [testFit,trainFit,param,numModels] = fit_all_ln_models(X,spiketrain,dt, numFolds)
%%% Description
% The model: r = exp(W*theta), where r is the predicted # of spikes, W is a
% matrix of one-hot vectors describing variable (P, H, S, or T) values, and
% theta is the learned vector of parameters.

%%% compute the position, head direction, speed, and theta phase matrices

ain_grid = dummyvar(X(:,1));
bin_grid = dummyvar(X(:,2));
aout_grid = dummyvar(X(:,3));
ain_arm_grid = dummyvar(categorical(X(:,4)));
bin_arm_grid = dummyvar(categorical(X(:,5)));
aout_arm_grid = dummyvar(categorical(X(:,6)));

ain_grid = ain_grid(:,1:end-1); 
bin_grid = bin_grid(:,1:end-1); 
aout_grid = aout_grid(:,1:end-1);
ain_arm_grid = ain_arm_grid(:,1:end-1); 
bin_arm_grid = bin_arm_grid(:,1:end-1);
aout_arm_grid = aout_arm_grid(:,1:end-1);


%%% Fit all 15 LN models

numModels = 26;
testFit = cell(numModels,1);
trainFit = cell(numModels,1);
param = cell(numModels,1);
A = cell(numModels,1);
modelType = cell(numModels,1);

% # Three Interactions
A{1} = [ ain_arm_grid bin_arm_grid aout_arm_grid]; modelType{1} = [0 0 0 1 1 1];

% Two Interaction + 1 Single 
A{2} = [ ain_grid bin_arm_grid aout_arm_grid]; modelType{2} = [1 0 0 0 1 1];
A{3} = [ bin_grid ain_arm_grid  aout_arm_grid]; modelType{3} = [0 1 0 1 0 1];
A{4} = [ aout_grid ain_arm_grid bin_arm_grid]; modelType{4} = [0 0 1 1 1 0];

% 2 Singles + 1 Interaction
A{5} = [ ain_grid bin_grid aout_arm_grid]; modelType{5} = [1 1 0 0 0 1];
A{6} = [ ain_grid aout_grid bin_arm_grid]; modelType{6} = [1 0 1 0 1 0];
A{7} = [ bin_grid aout_grid ain_arm_grid]; modelType{7} = [0 1 1 1 0 0];

% 2 Interactions
A{8} = [ ain_arm_grid bin_arm_grid]; modelType{8} = [0 0 0 1 1 0];
A{9} = [ ain_arm_grid  aout_arm_grid]; modelType{9} = [0 0 0 1 0 1];
A{10} = [ bin_arm_grid aout_arm_grid]; modelType{10 } = [0 0 0 0 1 1];


% 1 Singles + 1 Interaction
A{11} = [ ain_grid bin_arm_grid]; modelType{11} = [1 0 0 0 1 0];
A{12} = [ ain_grid aout_arm_grid]; modelType{12} = [1 0 0 0 0 1];
A{13} = [ bin_grid ain_arm_grid]; modelType{13} = [0 1 0 1 0 0];
A{14} = [ bin_grid aout_arm_grid]; modelType{14} = [0 1 0 0 0 1];
A{15} = [ aout_grid ain_arm_grid]; modelType{15} = [0 0 1 1 0 0];
A{16} = [ aout_grid bin_arm_grid]; modelType{16} = [0 0 1 0 1 0];

% 1 Interaction
A{17} = ain_arm_grid; modelType{17} = [0 0 0 1 0 0];
A{18} =  bin_arm_grid; modelType{18} = [0 0 0 0 1 0];
A{19} = aout_arm_grid; modelType{19} = [0 0 0 0 0 1];

% 3 singles
A{20} = [ ain_grid bin_grid aout_arm_grid]; modelType{20} = [1 1 1 0 0 0];

% 2 singles
A{21} = [ ain_grid bin_grid]; modelType{21} = [1 1 0 0 0 0];
A{22} = [ ain_grid aout_grid ]; modelType{22} = [1 0 1 0 0 0];
A{23} = [ bin_grid aout_grid ]; modelType{23} = [0 1 1 0 0 0];

% 1 single
A{24} = ain_grid; modelType{24} = [1 0 0 0 0 0];
A{25} = bin_grid ; modelType{25} = [0 1 0 0 0 0];
A{26} = aout_grid ; modelType{26} = [0 0 1 0 0 0];



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
