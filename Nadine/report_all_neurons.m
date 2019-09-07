
electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats';
day_files = dir([electro_folder,'\*\*\*\*events_g.mat']); %look for all single units files in the stage

identifiable_neurons = 0;
total_neurons = 0;
neurons_type = zeros(1, 15);

for i = 1:length(day_files)
    day_folder = day_files(i).folder
    %day_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor1_WR\rat6_mpfc_20.6';
    numFolds = 10;
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    % Draw the data per neuron
    SS_files = dir([day_folder,'\*_SS_*.ntt']); %look for all single units files in the stage
    num_neurons = length(SS_files);
    
    for i = 1:num_neurons
        
        total_neurons=total_neurons+1;
        
        ss_file = [SS_files(i).folder,'\',SS_files(i).name];
        
        %extract data to show neural activity during the day
        idcs   = strfind(ss_file,'\');
        stage_folder_name = ss_file(1:idcs(end-1)-1);
        
        %Load data and extract meta information
        [behave, st] = load_spikes_and_behavioral_data (ss_file);
        [median_times, proportions, num_bins_per_proportion, num_bins_between_events] = analyze_behavior_in_stage(day_folder);
        
        % Allign st to events.
        [spike_count, bined_spikes_cell, events_bins_span] = ss_activity_inday (behave, st, num_bins_between_events);
        
        %subplot(num_neurons,2,(i-1)*2+1)
        
        %heatmap(bined_spikes_cell, 1:size(bined_spikes_cell,2), num2str(spike_count),[] ,'ColorBar', true)
        
        subplot(num_neurons+1,2,(i-1)*2+1)
        w = gausswin(30);
        w=w./sum(w);
        %y = filter(w,1,bined_spikes_cell);
        y = filtfilt(w,1,bined_spikes_cell);
        plot(y)
        ylim([-0.3,0.3])
        
        for j=1:length(events_bins_span)
            vline(events_bins_span(j),'b')
        end
        
        [LLH_values, selected_model] = fit_model_to_neuron(st, behave, numFolds);
        
        LLH_increase_mean = mean(LLH_values);
        LLH_increase_sem = std(LLH_values)/sqrt(numFolds);
        
        subplot(num_neurons+1,2,(i-1)*2+2)
        hold on
        plot(0.5:15.5,zeros(16,1),'--b','linewidth',2)
        errorbar(LLH_increase_mean,LLH_increase_sem,'ok','linewidth',3)
        if (~isnan(selected_model))
            plot(selected_model,LLH_increase_mean(selected_model),'.r','markersize',25)
            identifiable_neurons = identifiable_neurons+1;
            neurons_type(selected_model) = neurons_type(selected_model)+1;
        end
        hold off
        %box off
        %set(gca,'fontsize',20)
        set(gca,'XLim',[0 16]); set(gca,'XTick',1:15)
        set(gca,'XTickLabel',{'PART','PAR','PAT','PRT','ART','PA','PR','PT','AR',...
            'AT','RT','P','A','R','T'});
        %legend('Model performance','Selected Model','Baseline')
        suptitle (day_folder)
        %ylabel('LLH increase')
        ylabel(['Spikes - ', num2str(spike_count)])
        
        ylim([-1 1])
        
        % lim=10*max(LLH_increase_mean+LLH_increase_mean);
        % ylim([-lim lim])
        
    end
    
    [~, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave);
    
    subplot(num_neurons+1,2,(num_neurons+1)*2-1)
    hist(selected_arms)
    title(['Arm Dist - Num trials: ', num2str(length(selected_arms))])
    
    subplot(num_neurons+1,2,(num_neurons+1)*2)
    rewards = (selected_arms==rewarded_arm1)+2*(selected_arms==rewarded_arm2);
    hist(rewards, [0,1,2])
    title('rewards Dist')
    
    saveas(f, fullfile(day_folder,'mmodels.jpg'))
    %Print the heatmap for the entire day
    close(f)
    %alligned_heatmap_view (day_folder)
    %savefig(fullfile(day_folder,'aactivity'))
    
end

stem(neurons_type, 'filled')
set(gca,'XLim',[0 16]); set(gca,'XTick',1:15)
        set(gca,'XTickLabel',{'PART','PAR','PAT','PRT','ART','PA','PR','PT','AR',...
            'AT','RT','P','A','R','T'});
title(['Neurons models distribution - Total neurons:', num2str(total_neurons)]);