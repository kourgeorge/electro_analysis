function [LLH_values, selected_model] = fit_model_to_neuron(st, behave, numFolds)
%%% Given the electrophysiological data of a single unit and the rat
%%% behaviour in a day, this function fits 

%ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor2_WR\rat6_mpfc_23.6\TT4_SS_11.ntt';

dt = 0.02;


% Extracting data
[X,y] = generate_neuron_train_data (st, behave, dt);

disp(['num samples:', num2str(length(y))])
disp(['num spikes:', num2str(sum(y))])
disp(['trial length:', num2str(sum(y))])

% Fit all models
[testFit,trainFit,param,numModels] = fit_all_ln_models(X,y,dt,numFolds);

%Select the best model
testFit_mat = cell2mat(testFit);
LLH_values = reshape(testFit_mat(:,3),numFolds,numModels);
selected_model = select_best_model(LLH_values);

explained_var = reshape(testFit_mat(:,1),numFolds,numModels);
explained_var_mean = mean(explained_var);
explained_var_sem = std(explained_var)/sqrt(numFolds);