%ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_11\odor2_XFR\rat11_mpfc_18.10\TT1_SS_4.ntt';
ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\spatial_WR\rat6_mpfc_x6.7\TT1_SS_5.ntt';
dt = 0.02;
numFolds = 10;

% Extracting data
[X,y] = generate_neuron_train_data (ss_file, dt);

disp(['num samples:', num2str(length(y))])
disp(['num spikes:', num2str(sum(y))])
disp(['trial length:', num2str(sum(y))])

% Fit all models
[testFit,trainFit,param,numModels] = fit_all_ln_models(X,y,dt,numFolds);

%Select the best model
testFit_mat = cell2mat(testFit);
LLH_values = reshape(testFit_mat(:,3),numFolds,numModels);
selected_model = select_best_model(LLH_values);

%Plot the all models performance 
LLH_increase_mean = mean(LLH_values);
LLH_increase_sem = std(LLH_values)/sqrt(numFolds);

errorbar(LLH_increase_mean,LLH_increase_sem,'ok','linewidth',3)
hold on
if (~isnan(selected_model))
    plot(selected_model,LLH_increase_mean(selected_model),'.r','markersize',25)
end
plot(0.5:15.5,zeros(16,1),'--b','linewidth',2)
hold off
box off
set(gca,'fontsize',20)
set(gca,'XLim',[0 16]); set(gca,'XTick',1:15)
set(gca,'XTickLabel',{'PART','PAR','PAT','PRT','ART','PA','PR','PT','AR',...
    'AT','RT','P','A','R','T'});
legend('Model performance','Selected Model','Baseline')
title (ss_file)
ylabel(['LLH increase - #Spikes: ', num2str(sum(y))])

lim=10*max(LLH_increase_mean+LLH_increase_mean);
ylim([-lim lim])
