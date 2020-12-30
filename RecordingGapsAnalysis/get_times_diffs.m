function diff = get_times_diffs( Samples, TimeStamps )
%GET_TIMES_DIFFS Summary of this function goes here
%   Detailed explanation goes here
SF_orig = 32000;
movingwin = [3,0.3];
params.Fs=1000;
params.tapers=[0,10];
params.fpass=[0,40];

lfp=resample(Samples(:),1000,SF_orig);
timeVector=linspace(TimeStamps(1),TimeStamps(end),length(lfp))/1e6;


[~,t,~]=mtspecgramc(lfp,movingwin,params);
        
tvd = timeVector(end)-timeVector(1);
td = t(end)-t(1);
diff = tvd - td;
end

