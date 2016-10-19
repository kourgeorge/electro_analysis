function batch_convert()
% read the tsv as a table
% for each rat (line) read the name of the folder and the lfp channels
% send results to extractDataStruct

pmazeTable = readtable('pmaze_exp_info.dat', 'Delimiter','\t');
channels_table = getTableLFPChannels(pmazeTable);

data_folder = 'D:\data_jan';

for i=1:height(channels_table)
    extractDataStruct(fullfile('D:\data_jan',channels_table.Var2(i)), channels_table.Var3(i), fullfile('D:\data_jan',channels_table.Var2(i)))
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
