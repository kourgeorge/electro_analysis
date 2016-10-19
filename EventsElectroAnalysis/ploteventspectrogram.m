function ploteventspectrogram (event, timeVector, lfp, movingwin, interval_len)

params.Fs=1000;
params.tapers=[0,10];
params.fpass=[0,60];


for ch=1:1%size(lfp,1)
    %if length(sublfp)>60*params.Fs
        [S,t,f]=mtspecgramc(lfp(ch,:),movingwin,params);

        %allign t to timeVector because t start from 0
        t = t+timeVector(1);
        event_times = event(:,2);

        [S_event, time]=getavgfrequenciesaroundevent(S,t,interval_len, event_times);

        logS=log(S_event');

        PlotColorMap(logS,1,'x',time,'y',f);
        colormap('jet');
    
    %end
end



