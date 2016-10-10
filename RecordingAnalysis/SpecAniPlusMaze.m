function SpecAniPlusMaze(daystr)


eval(['cd ',daystr]);
eval(['load ',daystr,'dat.mat']);

params.Fs=1000;
params.tapers=[5,7];
params.fpass=[0,40];
movingwin=[10,1];


[S,t,f]=mtspecgramc(lfp,movingwin,params);
%[S,t,f]=mtspecgramc(lfp(1:1624015),movingwin,params);

logS=log(S);


clear range;
% aviName=[daystr,'S',num2str(session),'.avi'];
mp4name=[daystr,'.mp4'];
% mp4name=[daystr,'S',num2str(session),'.avi'];
% aviobj = avifile(aviName,'FPS',50,'Compression','None');  % perhaps try a different codec because not all machines play cinepak very nicely
% aviobj = avifile('Pth4movie.avi','FPS',10,'Compression','Cinepak');  % perhaps try a different codec because not all machines play cinepak very nicely
writerObj=VideoWriter(mp4name,'MPEG-4');
% writerObj=VideoWriter(mp4name);

writerObj.FrameRate=frameRate/3;
open(writerObj);
h=figure;
set(h,'color','k');
subplot(2,1,2)
hold on;
PlotColorMap(logS,1,'x',t,'y',f);%,'cutoffs',[10 16]);
colormap('jet');
% axis image
grid off;
set(gca,'FontSize',6,'LineWidth',0.5,'ycolor','w','xcolor','w');
clear S logS;

% axis xy; axis tight;view(0,90);
subplot(2,1,1)
hold on;

axis([min(posx) max(posx) min(posy) max(posy)]);
axis equal;
axis off;
post=linspace(1,timeVector(end)-timeVector(1),length(posx));
plot(posx(1),posy(1),'w');
j=1;
frames(j) = getframe(h);
%     aviobj = addframe(aviobj,frames(j));
unplot;
% for i=17:16:size(posx,1)  % downsample
% for i=13:12:size(posx,2)  % downsample, for non-problem days
% for i=9:8:size(posx,2)  % downsample
for i=21:20:size(posx,2)  % downsample for memory problem days
    j=j+1;
    % for i=1:size(posx,1)    %don't down sample
    %     j=i;

    title (num2str(post(i)), 'Color', [1 1 1 ]);
    subplot(2,1,1)
    %     plot([posx(i-16) posx(i)],[posy(i-16) posy(i)],'k','linewidth',2)
%         plot([posx(i-12) posx(i)],[posy(i-12) posy(i)],'k','linewidth',2)
    %     plot([posx(i-8) posx(i)],[posy(i-8) posy(i)],'.w','linewidth',1)
    plot(posx(i),posy(i),'.w','linewidth',1)
    plot(posx(i),posy(i),'or','markersize',15)

    subplot(2,1,2)
    
    hh=line([post(i) post(i)],[0 40]);%,[92 92]);
    set(hh,'LineWidth',3,'Color',[1 1 1]);
    frames(j) = getframe(h);
    %     aviobj = addframe(aviobj,frames(j));
    writeVideo(writerObj,frames(j))
    unplot;
    subplot(2,1,1)
    unplot;
    
    
    
    
end

close(h)
% aviobj = close(aviobj);
close(writerObj);
clear mex

cd ..

% Save the movie as AVI for powerpoint:

%  framesPerSec = 10;
% framesPerSec = 50;

% aviName = 'Pth1movie.avi';

% movie2avi(frames,aviName,'FPS',framesPerSec,'Compression','None');
