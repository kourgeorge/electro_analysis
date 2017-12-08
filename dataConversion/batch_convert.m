function batch_convert()
% read the tsv as a table
% for each rat (line) read the name of the folder and the lfp channels
% send results to extractDataStruct

pmazeTable = readtable('pmaze_exp_info.dat', 'Delimiter','\t');
load('files.mat');

channels_table = getTableLFPChannels(pmazeTable);
data_folder = 'E:\experiment\RecordingData';

for i=1:length(files)
    file_name = files{i};
    row = channels_table(strcmp(channels_table.Var2, file_name),:);
    disp(['Extracting data for ',row.Var2{:}])
    extractDataStruct(fullfile(data_folder,row.Var2{:}), row.channels_cell_arr{:}', fullfile(data_folder,row.Var2{:}))
end

end

function channels_table = getTableLFPChannels(pmazeTable)

channels_cell_arr = [];
for i=1:height(pmazeTable)
    channels_row_d1 = str2num(pmazeTable.d1_lfp_channels{i});
    channels_row_d2 = str2num(pmazeTable.d2_lfp_channels{i});
    channels_cell_arr = [channels_cell_arr; {union(channels_row_d1, channels_row_d2)}];
    
end
channels_table = table(pmazeTable.rat_id, pmazeTable.file_ref, channels_cell_arr);
end
