function fitting_stats_all_neurons ()
%FITTING_STATS_ALL_NEURONS Summary of this function goes here
%   Detailed explanation goes here


% for each day and rat, create a vector with the number of models
% identified in that day including NaN. The outpur should be a matrix with
% a line for each day and rat and also a matrix of cells containing the
% name of the rows, namely, rat_day. and send to genela.

electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\rat_10\odor1_WR\rat10_mpfc_12.10';

%electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats';

results_files = dir([electro_folder,'\*_result.mat']); %look for all single units files in the stage

neurons_type = zeros(1, 27);
rat_day_models = [];
rat_day_names = [];
for i = 1:length(results_files)
    
    %load the struct
    result_file_path = [results_files(i).folder,'\',results_files(i).name];
    result_struct = load(result_file_path);
    selected_model = result_struct.selected_model;
    if (~isnan(selected_model))
        neurons_type(selected_model) = neurons_type(selected_model)+1;
    else
        neurons_type(end) = neurons_type(end)+1;
    end
    idcs   = strfind(result_file_path,'\');
    rat_day_name = result_file_path(idcs(end-1)+1:idcs(end)-1);
    
    
    
    
    
end

stem(neurons_type)

end

