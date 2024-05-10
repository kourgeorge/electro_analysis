%Plot the power spectrum of rat 2 during 5 experiment days.

%set environment parameters
datafolder = '../data/';
outputfolder = '../output';
params.Fs=1000;
params.tapers=[0,10];
params.fpass=[0,60];
movingwindow = [1,0.1];

experimentsdays =[{'rat2_1104'},{'rat2_1204'},{'rat2_2504'},{'rat2_2604'},{'rat2_2704'}];
suptitle('Frequency in Hz vs. Power spectrum (dBW)');
num_days = length(experimentsdays);
for i=1:num_days
    experiment = experimentsdays(i);
    %load data
    electro_data_file = fullfile(datafolder,[experimentsdays{i},'dat.mat']);
    eval(['load ',electro_data_file]);
    
    Fs = 1000; 
    [P,f] = periodogram(lfp,[],length(lfp),Fs,'power');
    subplot(num_days,1,i)
    plot(f,10*log10(P))
    xlim([0 60])
    
end
