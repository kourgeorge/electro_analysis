%set environment parameters
datafolder = '../data';
outputfolder = '../output';

experimentsdays =[{'rat2_1104'},{'rat2_1204'},{'rat2_2504'},{'rat2_2604'},{'rat2_2704'}];


suptitle('Spectrogram around events. Rows: Days and Columns different resolutions');
num_days = length(experimentsdays);
for i=1:length(experimentsdays)
    experiment = experimentsdays(i);
    %load data
    electro_data_file = fullfile(datafolder,[experimentsdays{i},'dat.mat']);
    event_dat_file = fullfile(datafolder,[experimentsdays{i},'Events.nevevents.mat']);
    eval(['load ',electro_data_file]);
    eval(['load ',event_dat_file]);
    
    subplot(num_days,3,3*(i-1)+1);
    ploteventspectrogram (Abeam_entrance, timeVector, lfp , [1,0.1], 1000);
    subplot(num_days,3,3*(i-1)+2)
    ploteventspectrogram (Abeam_entrance, timeVector, lfp , [3,0.3], 2000);
    subplot(num_days,3,3*(i-1)+3)
    ploteventspectrogram (Abeam_entrance, timeVector, lfp , [5,0.5], 5000);
end