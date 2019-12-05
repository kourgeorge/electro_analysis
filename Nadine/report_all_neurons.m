
function report_all_neurons()

electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_8\odor1_WR\rat8_mpfc_21.6';
%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_10\odor1_WR\rat10_mpfc_10.10';
%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_11\odor1_WR\rat11_mpfc_14.10';
%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_10\odor1_WR\rat10_mpfc_12.10';

electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats';

%day_files = dir([electro_folder,'\*events_g.mat']); %look for all single units files in the stage
day_files = dir([electro_folder,'\*\*\*\*events_g.mat']); %look for all single units files in the stage

identifiable_neurons = 0;
total_neurons = 0;
neurons_type = zeros(1, 26);

for j = 1:length(day_files)
    day_folder = day_files(j).folder
    numFolds = 10;
    %f = figure('units','normalized','outerposition',[0 0 1 1]);
    % Draw the data per neuron
    SS_files = dir([day_folder,'\*_SS_*.ntt']); %look for all single units files in the stage
    
    num_neurons = length(SS_files);
    for i = 1:num_neurons
        
        total_neurons=total_neurons+1;
        neuron_filename = SS_files(i).name;
        ss_file = [SS_files(i).folder,'\',neuron_filename]
        
        %extract data to show neural activity during the day
        idcs   = strfind(ss_file,'\');
        neuron_name = ss_file(idcs(end)+1:end-4);
        stage_folder_name = ss_file(1:idcs(end-1)-1);
        rat = ss_file(idcs(end-3)+1:idcs(end-2)-1);
        stage = ss_file(idcs(end-2)+1:idcs(end-1)-1);
        day = ss_file(idcs(end-1)+1:idcs(end)-1);
        
        %Load data and extract meta information
        [behave, st] = load_spikes_and_behavioral_data (ss_file);

         [~, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave);

        %%%%%%%%%%%%%%%%%%%%%%%%%%

        
        [median_times, proportions, num_bins_per_proportion, num_bins_between_events] = analyze_behavior_in_stage(day_folder);
        
        % Allign st to events.
        [spike_count, binned_spikes_cell, events_bins_span] = ss_activity_inday (behave, st, num_bins_between_events);
        
        %subplot(num_neurons,2,(i-1)*2+1)
        
        %heatmap(bined_spikes_cell, 1:size(bined_spikes_cell,2), num2str(spike_count),[] ,'ColorBar', true)
        
%         subplot(num_neurons+1,2,(i-1)*2+1)
        w = gausswin(10);
        w=w./sum(w);
        %y = filter(w,1,bined_spikes_cell);
        psth = filtfilt(w,1,binned_spikes_cell);
%         plot(y)
%         ylim([-0.3,0.3])
%         xlim([0,length(binned_spikes_cell)+100])
%         
%         for k=1:length(events_bins_span)
%             vline(events_bins_span(k),'b')
%         end
%       
        dt = 0.02;
         
        % Extracting data
        [X, y, feature_names, interaction_feature_name] = prepare_cell_data2 (st, behave, dt, proportions);
        [testFit, trainFit, param, Models] = fit_model_to_neuron(X,y,dt,numFolds);
        
        %Select the best model
        testFit_mat = cell2mat(testFit);
        LLH_values = reshape(testFit_mat(:,3), numFolds, length(Models));
        selected_model = select_best_model(LLH_values);

        % explained_var = reshape(testFit_mat(:,1),numFolds,numModels);
        % explained_var_mean = mean(explained_var);
        % explained_var_sem = std(explained_var)/sqrt(numFolds);
        
        model_names = {'I^B^O^','IB^O^','I^BO^','I^B^O', 'IBO^','IB^O', 'I^BO', 'I^B^', ...
             'I^O^', 'B^O^', 'IB^', 'IO^', 'BI^', 'BO^', 'OI^', 'OB^' ...
             'I^', 'B^' ,'O^' ,'IBO','IB', 'IO', 'BO','I','B','O'};
         
        psth_data.vec = psth;
        psth_data.events_bins_span = events_bins_span;
        psth_data.spike_count=spike_count;
        
        save_analysis_results(ss_file, rat, stage, day, neuron_name, st, behave, 0.02, ...
            proportions, X, y, feature_names, interaction_feature_name, model_names, numFolds, testFit, trainFit, param, selected_model, ...
            selected_arms, rewarded_arm1, rewarded_arm2, psth_data)
                              
        selected_model
        
        LLH_increase_mean = mean(LLH_values);
        LLH_increase_sem = std(LLH_values)/sqrt(numFolds);
        
%         subplot(num_neurons+1,2,(i-1)*2+2)
%         hold on
%         plot(0.5:26,zeros(26,1),'--b','linewidth',2)
%         errorbar(LLH_increase_mean,LLH_increase_sem,'ok','linewidth',3)
%         if (~isnan(selected_model))
%             plot(selected_model,LLH_increase_mean(selected_model),'.r','markersize',25)
%             identifiable_neurons = identifiable_neurons+1;
%             neurons_type(selected_model) = neurons_type(selected_model)+1;
%         
%         end
%         hold off
%         %box off
%         %set(gca,'fontsize',20)
%         set(gca,'XLim',[0 26]); set(gca,'XTick',1:26)
%         set(gca,'XTickLabel',{'I^B^O^','IB^O^','I^BO^','I^B^O', 'IBO^','IB^O', 'I^BO', 'I^B^', ...
%             'I^O^', 'B^O^', 'IB^', 'IO^', 'BI^', 'BO^', 'OI^', 'OB^' ...
%             'I^', 'B^' ,'O^' ,'IBO','IB', 'IO', 'BO','I','B','O'});
%         %legend('Model performance','Selected Model','Baseline')
%         suptitle (day_folder)
%         %ylabel('LLH increase')
%         ylabel([num2str(spike_count), '[S]',])
%         
%         ylim([-1 1])

        
    end
    
%     [~, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave);
%     
%     subplot(num_neurons+1,2,(num_neurons+1)*2-1)
%     hist(selected_arms)
%     title(['Arm Dist - Num trials: ', num2str(length(selected_arms))])
%     
%     subplot(num_neurons+1,2,(num_neurons+1)*2)
%     rewards = (selected_arms==rewarded_arm1)+2*(selected_arms==rewarded_arm2);
%     hist(rewards, [0,1,2])
%     title('rewards Dist')
%     
%     saveas(f, fullfile(day_folder,'mmodels_3_11.jpg'))
%     %Print the heatmap for the entire day
%     close(f)
%     %alligned_heatmap_view (day_folder)
%     savefig(fullfile(day_folder,'aactivity'))
%     
end

figure
stem(neurons_type, 'filled')        
set(gca,'XLim',[0 26]); set(gca,'XTick',1:26)
        set(gca,'XTickLabel',{'I^B^O^','IB^O^','I^BO^','I^B^O', 'IBO^','IB^O', 'I^BO', 'I^B^', ...
            'I^O^', 'B^O^', 'IB^', 'IO^', 'BI^', 'BO^', 'OI^', 'OB^' ...
            'I^', 'B^' ,'O^' ,'IBO','IB', 'IO', 'BO','I','B','O'});
title(['Neurons models distribution. Total:', num2str(total_neurons), '. Identified: ', num2str(sum(neurons_type))]);

end

function save_analysis_results(ss_file, rat, stage, day, neuron_name, st, behave, dt, ...
    proportions, X, y, feature_names, interaction_feature_name, model_names, numFolds, testFit, trainFit, param, ...
    selected_model, selected_arm, rewarded_arm1, rewarded_arm2, psth_data)

modeling_metadata.dt = dt;
modeling_metadata.feature_names = feature_names;
modeling_metadata.tfe_bin = 0.5;
modeling_metadata.proportions=proportions;
modeling_metadata.model_names = model_names;
modeling_metadata.numFolds = numFolds;

modeling_data.X = X;
modeling_data.Y = y;
modeling_data.arm = selected_arm;
modeling_data.reward = selected_arm==rewarded_arm1 | selected_arm==rewarded_arm2;
modeling_data.arm_type = 2 - (selected_arm == 1 | selected_arm == 2);

fitting.param = param;
fitting.testFit = testFit;
fitting.trainFit= trainFit;
fitting.selected_model = selected_model;

result.rat = rat;
result.stage = stage;
result.day = day;
result.neuron_name = neuron_name;
result.spikestime = st;
result.behave = behave;
result.modeling_data = modeling_data;
result.fitting = fitting;

result.modeling_metadata = modeling_metadata;
result.modeling_data = modeling_data;
result.psth_data = psth_data;


save([ss_file,'_', interaction_feature_name,'_result.mat'], '-struct', 'result')
end