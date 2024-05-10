function [testFit,trainFit,param,Models] = fit_model_to_neuron(X,y,dt,numFolds)
%%% Given the electrophysiological data of a single unit and the rat
%%% behaviour in a day, this function fits 

%ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor2_WR\rat6_mpfc_23.6\TT4_SS_11.ntt';

disp(['num samples:', num2str(length(y))])
disp(['num spikes:', num2str(sum(y))])
disp(['trial length:', num2str(sum(y))])

% Fit all models
[testFit,trainFit,param,Models] = fit_all_ln_models(X,y,dt,numFolds);
