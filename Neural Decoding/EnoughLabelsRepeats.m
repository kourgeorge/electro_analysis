
function rows_indx = EnoughLabelsRepeats(cells, label, trials_per_value)
%%% numTrialsToCells is a table [M,N,CellsM].
%%% M - Number of trials.
%%% N - number of cells having at least N trials per .
%%% CellsM - the indices of the cells having at least N trials. 

label_values = getLabelValues(label);
label_count_cell = [];
    for i=1:length(cells)
        celli = cells(i);
        counts = histc(int8(celli.raster_labels.(label)), label_values);
        label_count_cell = [label_count_cell;counts'];
        %cell_num_trials=[cell_num_trials,size(cells(i).raster_data.BinnedRaster,1)];    
    end
    
    rows_indx = rows_larger(label_count_cell,trials_per_value);
    
end

function indx = rows_larger(mat, n)
indx = [];
for i=1:size(mat,1)
    if all(mat(i,:)>n)
        indx = [indx;i];
    end
end
end
