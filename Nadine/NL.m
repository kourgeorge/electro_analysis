%ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_11\odor2_XFR\rat11_mpfc_18.10\TT1_SS_4.ntt';
ss_file = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor2_WR\rat6_mpfc_23.6\TT4_SS_11.ntt';
dt = 0.02;
numFolds = 10;


%extract data to show neural activity during the day
 idcs   = strfind(ss_file,'\');
 stage_folder_name = ss_file(1:idcs(end-1)-1);

[median_times, proportions, num_bins_per_proportion, num_bins_between_events] = analyze_behavior_in_stage(stage_folder_name);
[behave, st] = load_spikes_and_behavioral_data (ss_file);
[spike_count, bined_spikes_cell, events_bins_span] = ss_activity_inday (behave, st, num_bins_between_events);

subplot(3,1,1)
heatmap(bined_spikes_cell, 1:size(bined_spikes_cell,2), num2str(spike_count),[] ,'Colorbar', 0)

subplot(3,1,2)
w = gausswin(30);
y = filter(w,1,bined_spikes_cell);
plot(y)
for i=1:length(events_bins_span)
    vline(events_bins_span(i),'b')
end

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


explained_var = reshape(testFit_mat(:,1),numFolds,numModels);
explained_var_mean = mean(explained_var);
explained_var_sem = std(explained_var)/sqrt(numFolds);

%Plot the all models performance 
LLH_increase_mean = mean(LLH_values);
LLH_increase_sem = std(LLH_values)/sqrt(numFolds);

subplot(3,1,3)
errorbar(LLH_increase_mean,LLH_increase_sem,'ok','linewidth',3)
hold on
if (~isnan(selected_model))
    plot(selected_model,LLH_increase_mean(selected_model),'.r','markersize',25)
end
plot(0.5:15.5,zeros(16,1),'--b','linewidth',2)
hold off
box off
%set(gca,'fontsize',20)
set(gca,'XLim',[0 16]); set(gca,'XTick',1:15)
set(gca,'XTickLabel',{'PART','PAR','PAT','PRT','ART','PA','PR','PT','AR',...
    'AT','RT','P','A','R','T'});
legend('Model performance','Selected Model','Baseline')
suptitle (ss_file)
ylabel('LLH increase')

% lim=10*max(LLH_increase_mean+LLH_increase_mean);
% ylim([-lim lim])
