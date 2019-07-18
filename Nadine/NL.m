ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor1_WR\rat6_mpfc_20.6\TT1_SS_10.ntt';
dt = 0.02;
[X,y] = generate_neuron_train_data (ss_file, dt);
[b,dev,stats] = glmfit(X,y,'poisson')


% create tuninng curves and model based tuning curves.

% Check the degree of the model fit.

%


X