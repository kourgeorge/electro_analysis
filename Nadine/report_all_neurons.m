
%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_8\odor1_WR\rat8_mpfc_21.6';
%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_10\odor1_WR\rat10_mpfc_14.10';
electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_11\odor1_WR\rat11_mpfc_14.10';

%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats';

day_files = dir([electro_folder,'\*events_g.mat']); %look for all single units files in the stage
%day_files = dir([electro_folder,'\*\*\*\*events_g.mat']); %look for all single units files in the stage

identifiable_neurons = 0;
total_neurons = 0;
neurons_type = zeros(1, 15);

for j = 1:length(day_files)
    day_folder = day_files(j).folder
    %day_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_6\odor1_WR\rat6_mpfc_20.6';
    numFolds = 10;
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    % Draw the data per neuron
    SS_files = dir([day_folder,'\*_SS_*.ntt']); %look for all single units files in the stage
    
    num_neurons = length(SS_files);
    for i = 1:num_neurons
        
        total_neurons=total_neurons+1;
        neuron_filename = SS_files(i).name;
        ss_file = [SS_files(i).folder,'\',neuron_filename]
        
        %extract data to show neural activity during the day
        idcs   = strfind(ss_file,'\');
        stage_folder_name = ss_file(1:idcs(end-1)-1);
        
        %Load data and extract meta information
        [behave, st] = load_spikes_and_behavioral_data (ss_file);
        
        
%         %%%% Manipulate st to check the model validity %%%%%%
%         
%         [event_times, ~, ~, ~] = extract_event_times(behave);
%         
%         old_st = st;
%         %old_fr = length(st)/(st(end)-st(1));
%         diff_st = diff(st);
%         perm = randperm(length(st)-1);
%         diff_st = diff_st(perm);
%         st = cumsum([st(1) diff_st]);
% 
%         ain_times = event_times(:,2);
%         %add spikes in the area
%         for k=1:length(ain_times)            
%             a_spikes = randn([1,1])*0.2+0.1+ain_times(k);
%             st = [st, a_spikes];
%         end
% 
%         st = sort(st);
        %%%%%%%%%%%%%%%%%%%%%%%%%%

        
        [median_times, proportions, num_bins_per_proportion, num_bins_between_events] = analyze_behavior_in_stage(day_folder);
        
        % Allign st to events.
        [spike_count, binned_spikes_cell, events_bins_span] = ss_activity_inday (behave, st, num_bins_between_events);
        
        %subplot(num_neurons,2,(i-1)*2+1)
        
        %heatmap(bined_spikes_cell, 1:size(bined_spikes_cell,2), num2str(spike_count),[] ,'ColorBar', true)
        
        subplot(num_neurons+1,2,(i-1)*2+1)
        w = gausswin(10);
        w=w./sum(w);
        %y = filter(w,1,bined_spikes_cell);
        y = filtfilt(w,1,binned_spikes_cell);
        plot(y)
        ylim([-0.3,0.3])
        xlim([0,length(binned_spikes_cell)+100])
        
        for k=1:length(events_bins_span)
            vline(events_bins_span(k),'b')
        end
        
        [LLH_values, selected_model] = fit_model_to_neuron(st, behave, numFolds, proportions);
        
        selected_model
        
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
        ylabel([num2str(spike_count), '[S]',])
        
        ylim([-1 1])

        
    end
    
    [~, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(behave);
    
    subplot(num_neurons+1,2,(num_neurons+1)*2-1)
    hist(selected_arms)
    title(['Arm Dist - Num trials: ', num2str(length(selected_arms))])
    
    subplot(num_neurons+1,2,(num_neurons+1)*2)
    rewards = (selected_arms==rewarded_arm1)+2*(selected_arms==rewarded_arm2);
    hist(rewards, [0,1,2])
    title('rewards Dist')
    
    saveas(f, fullfile(day_folder,'mmodels_17_10.jpg'))
    %Print the heatmap for the entire day
    %close(f)
    %alligned_heatmap_view (day_folder)
    %savefig(fullfile(day_folder,'aactivity'))
    
end

figure
stem(neurons_type, 'filled')
set(gca,'XLim',[0 16]); set(gca,'XTick',1:15)
        set(gca,'XTickLabel',{'PART','PAR','PAT','PRT','ART','PA','PR','PT','AR',...
            'AT','RT','P','A','R','T'});
title(['Neurons models distribution. Total:', num2str(total_neurons), '. Identified: ', num2str(sum(neurons_type))]);