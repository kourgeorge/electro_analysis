%set environment parameters
datafolder = '../data/';
outputfolder = '../output';
params.Fs=1000;
params.tapers=[0,10];
params.fpass=[0,60];
movingwindow = [1,0.1];

experimentsdays =[{'rat2_1104'},{'rat2_1204'},{'rat2_2504'},{'rat2_2604'},{'rat2_2704'}];

num_expriments = length(experimentsdays);
betaband = zeros(1,num_expriments);
thetaband = zeros(1,num_expriments);
deltaband = zeros(1,num_expriments);
%fig = figure('Name', 'Results');
num_days = length(experimentsdays);
for i=1:num_expriments
    experiment = experimentsdays(i);
    %load data
    electro_data_file = fullfile(datafolder,[experimentsdays{i},'dat.mat']);
    event_dat_file = fullfile(datafolder,[experimentsdays{i},'Events.nevevents.mat']);
    eval(['load ',electro_data_file]);
    eval(['load ',event_dat_file]);
    
    [S,t,f]=mtspecgramc(lfp,movingwindow,params);
    
    Fs = 1000;
    nfft = 2^nextpow2(length(lfp));
    Pxx = abs(fft(lfp,nfft)).^2/length(lfp)/Fs;
    
    Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);  
    plot(Hpsd)
    
    t = t+timeVector(1);
    event_times = Abeam_entrance(:,2);
    
    [S_event, time]=getavgfrequenciesaroundevent(S,t,2000, event_times);
    
    %calulate the power of each band.
    beta_min_index = 13; beta_max_index = 32;  %12-30 Hz
    theta_min_index = 6; theta_max_index = 12;  %5-12 Hz
    delta_min_index = 1; delta_max_index = 5;  %1-4 Hz
    betaband(i) = caluclatebandpower(S_event,beta_min_index, beta_max_index)/caluclatebandpower(S,beta_min_index,beta_max_index);
    thetaband(i) = caluclatebandpower(S_event,theta_min_index, theta_max_index)/caluclatebandpower(S,theta_min_index,theta_max_index);
    deltaband(i) = caluclatebandpower(S_event,delta_min_index, delta_max_index)/caluclatebandpower(S,delta_min_index,delta_max_index);
end

plot(1:5,[betaband;thetaband;deltaband]');
legend('beta', 'theta', 'delta');
title('Power band for beta, theta and delta of rat 2 during 5 experiment days');
xlabel('Days');
ylabel('Band Power');