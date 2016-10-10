function plotLFPnSpecs(datestr)
cd(datestr);
eval(['load ',datestr,'dat.mat']);
params.Fs=1000;
params.tapers=[5,7];
params.fpass=[2,40];
movingwin=[10,1];
%[S,t,f]=mtspecgramc(lfp,movingwin,params);
[S,t,f]=mtspecgramc(lfp(1:12792),movingwin,params);
logS=log(S');
figure;
subplot(2,1,1)
PlotColorMap(logS,1,'x',t,'y',f)
colormap('jet')
subplot(2,1,2)
plot(timeVector-timeVector(1),lfp);
set(gca,'Xlim',[0 timeVector(end)-timeVector(1)]);
cd ..