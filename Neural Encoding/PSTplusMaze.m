%function PSTplusMaze(SpikeClust,EventDate)
function [nspikes,st, StartPsth,NPPsth,AentrancePsth,BentrancePsth,RewardPsth,BexitPsth,AexitPsth]= PSTplusMaze(rat,stage,EventDate, SpikeClust)
%global PROJECTS_DIR;

plotoption = [0 0 0 0 0 0 0];
%1 - Reward
%2 - Nose-Poke
%3 - B Entrance
%4 - B Exit
%5 - A Entrance
%6 - A Exit
%7 - Trial Start
eventfolder=fullfile('D:\Electrophysiology recordings',rat,stage,EventDate);
eventfile=fullfile(eventfolder,[EventDate,'events_g.mat']);
% if exist([eventfile 'events.mat'],'file')
%     eval(['load ',eventfile,'events.mat']);
%if exist(eventfile,'file')
load(eventfile);
%else
%    [ITI, Rewards, CorrectArm, IncorrectArm,NPstart,NPend, Bbeam_entrance, Abeam_entrance, Abeam_exit, Bbeam_exit, NP_divided_to_trials] = extractEvents(eventfile);
%end

st=Nlx2MatSpike(fullfile(eventfolder,SpikeClust),[1 0 0 0 0],0,1,[]);
% for r=1:size(dataStruct.eventsStruct.rewards,1)

nspikes=length(st); %new

%%%%%% Uncomment lines: Ctrl+T; Comment lines: Ctrl+R
%%%% Change st:
%%remove first part of st:
% % load(fullfile(eventfolder, 'stabs.mat'));
% % remove = (1: stabT1S1(1,1));
% % [st PS] = removerows(st', 'ind', remove);
% % st = st';
%%remove middle part of st:
% load(fullfile(eventfolder, 'stabs.mat'));
% remove = (stabT1S2(1,1):stabT1S2(2,1));
% [st PS] = removerows(st', 'ind', remove);
% st = st';
% %%remove last part of st:
% load(fullfile(eventfolder, 'stabs.mat'));
% remove2 = (stabT3S5(2,1):nspikes);
% [st PS] = removerows(st', 'ind', remove);
% st = st';
%%remove two parts of st:
% remove = [remove1 remove2];
% [st PS] = removerows(st', 'ind', remove);
% st = st';

st=st/1e6;

dotd=sparse(size(Rewards,1),5000);
pst=[];%new
sigma=20;
win=gauss(sigma);


for r=1:size(Rewards,1)
    TE=Rewards(r,2);
    trange=[TE-2.5 TE+2.5] ;
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);
if plotoption(1)
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    box off
    grid off;
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['Reward ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end

RewardPsth=psth; %new

dotd=sparse(size(NP_new,1),5000);
pst=[];%new
sigma=20;
win=gauss(sigma);


for r=1:size(NP_new,1)
    TE=NP_new(r,2);
    trange=[TE-2.5 TE+2.5] ;
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);

if plotoption(2)
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    box off
    grid off;
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['NP ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end

NPPsth=psth; %new


pst=[];%new
dotd=sparse(size(Bbeam_entrance,1),5000);

for r=1:size(Bbeam_entrance,1)
    TE=Bbeam_entrance(r,2);
    trange=[TE-2.5 TE+2.5] ;
    
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);

if plotoption(3)
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    grid off;
    box off
    
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['B entrance ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end

BentrancePsth=psth; %new
dotd=sparse(size(Bbeam_exit,1),5000);
pst=[];%new

for r=1:size(Bbeam_exit,1)
    TE=Bbeam_exit(r,2);
    trange=[TE-2.5 TE+2.5] ;
    
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);

if plotoption(4)
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    box off
    grid off;
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['B Exit ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end
BexitPsth=psth;%new

dotd=sparse(size(Abeam_entrance,1),5000);
pst=[];%new

for r=1:size(Abeam_entrance,1)
    TE=Abeam_entrance(r,2);
    trange=[TE-2.5 TE+2.5] ;
    
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
    
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);
if plotoption(5)
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    box off
    grid off;
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['A Entrance ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end
AentrancePsth=psth;%new

dotd=sparse(size(Abeam_exit,1),5000);
pst=[];%new

for r=1:size(Abeam_exit,1)
    TE=Abeam_exit(r,2);
    trange=[TE-2.5 TE+2.5] ;
    
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);
if plotoption(6)
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    box off
    grid off;
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['A Exit ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end
AexitPsth=psth;%new

dotd=sparse(size(ITI,1),5000);

pst=[];%new

for r=1:size(ITI,1)
    TE=ITI(r,2);
    trange=[TE-2.5 TE+2.5] ;
    
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
end
pst=sum(full(dotd))/size(dotd,1)*1000;
psth=filter(win,1,pst);
if plotoption(7)
    
    figure;
    subplot(2,1,1)
    bar(linspace(-2.5,2.5,5000),psth,'k');
    axis tight
    box off
    grid off;
    subplot(2,1,2)
    spy(dotd,'k.')
    set(gca,'XTick', 0:500:5000,'XTickLabel',{'','-2','','-1','','0','','1','','2',''});
    
    axis normal
    
    Plot_title = suptitle(['Trial start ',EventDate,', ',SpikeClust] );
    set(Plot_title,'Interpreter', 'none');
end
StartPsth=psth;%new


function gaussFilter = gauss(sigma)
width = round((6*sigma - 1)/2);
support = (-width:width);
gaussFilter = exp( -(support).^2 ./ (2*sigma^2) );
gaussFilter = gaussFilter/ sum(gaussFilter);

