ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor3_WR\rat6_mpfc_x5.7\TT4_SS_5.ntt';
ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\spatial_WR\rat6_mpfc_x6.7\TT1_SS_5.ntt';
dt = 0.1;

% Extracting data
[X,y] = generate_neuron_train_data (ss_file, dt);

disp(['num samples:', num2str(length(y))])
% Fit all models
[testFit,trainFit,param,numFolds,numModels] = fit_all_ln_models(X,y,dt);

%Select the best model
selected_model = select_best_model(testFit, numFolds, numModels);



%Plot the all models performance 
testFit_mat = cell2mat(testFit);
LLH_values = reshape(testFit_mat(:,3),numFolds,numModels);

LLH_increase_mean = mean(LLH_values);
LLH_increase_sem = std(LLH_values)/sqrt(numFolds);

errorbar(LLH_increase_mean,LLH_increase_sem,'ok','linewidth',3)
hold on
plot(selected_model,LLH_increase_mean(selected_model),'.r','markersize',25)
plot(0.5:15.5,zeros(16,1),'--b','linewidth',2)
hold off
box off
set(gca,'fontsize',20)
set(gca,'XLim',[0 16]); set(gca,'XTick',1:15)
set(gca,'XTickLabel',{'PHST','PAR','PAT','PRT','ART','PA','PR','PT','AS',...
    'AT','RT','P','A','R','T'});
legend('Model performance','Selected Model','Baseline')




%[b,dev,stats] = glmfit(X,y,'poisson')


%tunining curve for pos
