function plotSpecs_Flavia2
batch='march2016';
rat{1}='RAT1';
rat{2}='RAT2';
rat{3}='RAT3';
rat{4}='RAT4';
rat{5}='RAT5';
for r=1:length(rat)
    clear dates numCh;
    
    dr=fullfile('C:/users/user/desktop/flavia/experiment',batch,'recording',rat{r});
    
    eval(['cd ',dr]);
    switch rat{r}
        case 'RAT1'
            dates{1}='rat1_0605';
            numCh{1}=2;
           
        case 'RAT2'
            dates{1}='rat2_0605';
            numCh{1}=1;
            dates{2}='rat2_0905';
            numCh{2}=1;
            dates{3}='rat2_0805';
            numCh{3}=1;
            dates{4}='rat2_0605(2)';
            numCh{4}=1;
           
        case 'RAT3'
            dates{1}='rat3_0605';
            numCh{1}=1;
            dates{2}='rat3_0905';
            numCh{2}=1;
            dates{3}='rat3_0805';
            numCh{3}=1;
            
        case 'RAT4'
            dates{1}='rat4_0605';
            numCh{1}=1;
            dates{2}='rat4_0905';
            numCh{2}=1;
            dates{3}='rat4_0805';
            numCh{3}=3;
            
        case 'RAT5'
            dates{1}='rat5_0605';
            numCh{1}=1;
            dates{2}='rat5_0805';
            numCh{2}=1;
            dates{3}='rat5_0905(2)';
            numCh{3}=1;
            dates{4}='rat5_0905';
            numCh{4}=1;
            
            
            
            
            
            
    end
    params.Fs=1000;
    %params.tapers=[5,7];
    params.tapers=[0,10];
    %params.fpass=[3,45];
    params.fpass=[0,40];
    movingwin=[3,0.3];
    % eval(['cd ',rat,'dat']);
    
    for d=1:length(dates)
        disp(['day ',num2str(d),'of ',num2str(length(dates))]);
        for ch=1:numCh{d}
            fh(ch)=figure;
        end
        dirnm=dates{d};
        
        %         eval (['cd ','c:\users\user\desktop\flavia\experiment\march2016\recording\RAT5']);
        %
        %         eval (['cd ',dirnm]);
        eval(['cd ',dr]);
        datflnm=[dates{d},'dat.mat'];
        eval(['load ',datflnm]);
        %numseg=ceil(length(timeVector)/(180*params.Fs));
        numseg=ceil(length(timeVector)/(1200*params.Fs));
        frst=1;
        
        for ch=1:size(lfp,1)
            figure(fh(ch))
            for s=1:numseg
                disp(['segment ',num2str(s),'of ',(num2str(numseg))]);
                % lst=min(frst+180*params.Fs-1,length(timeVector));
                lst=min(frst+720*params.Fs-1,length(timeVector));
                sublfp=lfp(ch,frst:lst);
                if length(sublfp)>60*params.Fs
                    [S,t,f]=mtspecgramc(sublfp,movingwin,params);
                    logS=log(S');
                    %bands=SpectrogramBands(S',f,'lowGamma',[15 18]);first version
                    bands=SpectrogramBands(S',f,'lowGamma',[15 18],'theta',[4 10]);
                    %             [counts,edges]=histcounts(bands.lowGamma,70); this is for
                    %             matlab 2014. histcounts doesn't exist in matlab 2012
                    %             halfdiffs=diff(edges)/2;
                    %             centers=edges(1:end-1)+halfdiffs;
                    [counts,edges]=histcounts(bands.lowGamma,70);
                    [counts,centers]=hist(bands.lowGamma,70);
                    
                    [~,highestbin]=max(counts);
                    % counts=counts/sum(counts);
                    %             leftbranch=counts(edges<=edges(highestbin)+1);
                    leftbranch=counts(centers<=centers(highestbin)+1);
                    rightbranch=fliplr(leftbranch(1:end-1));
                    simcounts=[leftbranch rightbranch];
                    simedges=centers(1:min(length(simcounts),length(centers)));
                    simdata=[];
                    for i=1:numel(simedges)
                        thissim=repmat(simedges(i),1,simcounts(i));
                        simdata=[simdata thissim];
                    end
                    [munoise,sigmanoise]=normfit(simdata);
                    % [munoise,sigmanoise]=normfit(counts);
                    %             noisepdf=normpdf(edges,munoise,sigmanoise);
                    noisepdf=normpdf(centers,munoise,sigmanoise);
                    noisepdf=noisepdf/sum(noisepdf);
                    %threshold=munoise+4*sigmanoise;first version
                    threshold=munoise+3*sigmanoise;
                    
                    %% do the same for theta
                    %              [counts,edges]=histcounts(bands.lowGamma,70);
                    [counts,centers]=hist(bands.theta,70);
                    
                    [~,highestbin]=max(counts);
                    % counts=counts/sum(counts);
                    %             leftbranch=counts(edges<=edges(highestbin)+1);
                    leftbranch=counts(centers<=centers(highestbin)+1);
                    rightbranch=fliplr(leftbranch(1:end-1));
                    simcounts=[leftbranch rightbranch];
                    simedges=centers(1:min(length(simcounts),length(centers)));
                    simdata=[];
                    for i=1:numel(simedges)
                        thissim=repmat(simedges(i),1,simcounts(i));
                        simdata=[simdata thissim];
                    end
                    [munoise,sigmanoise]=normfit(simdata);
                    % [munoise,sigmanoise]=normfit(counts);
                    %             noisepdf=normpdf(edges,munoise,sigmanoise);
                    noisepdf=normpdf(centers,munoise,sigmanoise);
                    noisepdf=noisepdf/sum(noisepdf);
                    %threshold=munoise+4*sigmanoise;first version
                    threshold_theta=munoise+3*sigmanoise;
                    %%
                    
                    inbouts=find(bands.lowGamma>threshold)
                    bouts=runs(inbouts);
                    if ~isempty(bouts)
                        nbouts=numel(find(bouts(2,:)>2));
                        tbouts=sum(bouts(2,:));
                    else
                        nbouts=0;
                        tbouts=0;
                    end
                    
                    %             subplot(ceil(numseg/3)*2,3,(ceil(s/3)-1)*3+s);
                    numplot=0;
                    if mod(s,3)
                        numplot=ceil((s/3)-1)*9+mod(s,3);
                    else
                        numplot=ceil((s/3)-1)*9+3;
                    end
                    subplot(ceil(numseg/3)*3,3,numplot);
                    
                    PlotColorMap(logS,1,'x',linspace(timeVector(frst),timeVector(lst),length(t))-timeVector(1),'y',f)
                    %             PlotColorMap(logS,1,'x',linspace(timeVector(frst),timeVector(lst),length(t))-timeVector(1),'y',f,'cutoffs',[8 16])
                    colormap('jet');
                    %             axis image
                    grid off;
                    %             subplot(ceil(numseg/3)*2,3,ceil(s/3)*3+s);
                    numplotbeta=0;
                    if mod(s,3)
                        numplotbeta=(ceil(s/3)-1)*9+mod(s,3)+3;
                    else
                        numplotbeta=(ceil(s/3)-1)*9+6;
                    end
                    subplot(ceil(numseg/3)*3,3,numplotbeta);
                    plot(linspace(timeVector(frst),timeVector(lst),length(t))-timeVector(1),bands.lowGamma,'k');
                    hold on;
                    line([timeVector(frst)-timeVector(1) timeVector(lst)-timeVector(1)],[threshold threshold],'Color',[0.5 0.5 0.5]);
                    set(gca,'FontSize',6,'LineWidth',0.5);
                    axis tight;
                    
                    %             subplot(ceil(numseg/3)*2,3,ceil(s/3)*3+s);
                    numplottheta=0;
                    if mod(s,3)
                        numplottheta=(ceil(s/3)-1)*9+mod(s,3)+6;
                    else
                        numplottheta=(ceil(s/3)-1)*9+9;
                    end
                    subplot(ceil(numseg/3)*3,3,numplottheta);
                    plot(linspace(timeVector(frst),timeVector(lst),length(t))-timeVector(1),bands.theta,'k');
                    hold on;
                    line([timeVector(frst)-timeVector(1) timeVector(lst)-timeVector(1)],[threshold_theta threshold_theta],'Color',[0.5 0.5 0.5]);
                    set(gca,'FontSize',6,'LineWidth',0.5);
                    axis tight;
                    frst=lst+1;
                end
                
            end
            suptitle([rat{r},' ',dates{d}]);
            flnm=fullfile('C:/users/user/desktop/flavia/experiment',batch,'recording',rat{r},[dates{d},'_',num2str(ch)]);
            savefig(flnm);
            
        end
    end
    cd ..
end
