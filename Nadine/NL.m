ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor1_WR\rat6_mpfc_20.6\TT1_SS_10.ntt';
dt = 0.1;
[X,y] = generate_neuron_train_data (ss_file, dt);

spiketrain = y;

[testFit,trainFit,param,numFolds,numModels] = fit_all_ln_models(X,y,dt);

selected_model = select_best_model(testFit, numFolds, numModels);

[b,dev,stats] = glmfit(X,y,'poisson')


%tunining curve for pos
