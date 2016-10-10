function [timeVector,lfp,ts,posx,posy]=XtractLFP(datestr,LFPchannels)
% [lfp,posx,pos]=XtractLFP(datestr,LFPchannels)
% extracts LFP and tracker positions for the recording day and saves in a
% datfile, along with some information regarding the recording settings
current_directory = pwd;
cd (datestr)
for ch=1:length(LFPchannels)
    % extract full CSC vector and timestamps and some useful information,
    % and downsample the vector to 1000 Hz for saving.
    chSTR=['CSC',num2str(LFPchannels(ch)),'.ncs'];
    %     [TimeStamps,Samples]=Nlx2MatCSC(chSTR,[1 0 0 0 1],0,1,[]);
    [TimeStamps,Samples] = Nlx2MatCSC(chSTR,[1 0 0 0 1],0,1,[]);
    headerInfo=Nlx2MatCSC(chSTR,[0 0 0 0 0],1,3,0);
    [~,chStr]=strtok(headerInfo{20},' ');
    channel(ch)=str2num(chStr);
    [~,conv2VoltStr]=strtok(headerInfo{16},' ');
    conv2microV=str2num(conv2VoltStr)*1e6;
    [~,sfStr]=strtok(headerInfo{14},' ');
    SF_orig=str2num(sfStr);
    tickInt = (512/SF_orig)*1e6;
    Samples = SamplesPadding(Samples, TimeStamps, tickInt);
    lfp(ch,:)=resample(Samples(:)*conv2microV,1000,SF_orig);
    timeVector=linspace(TimeStamps(1),TimeStamps(end)+tickInt,length(lfp))/1e6;
    clear Samples
    
end
SF=1000;
[ts, posx, posy,Header] = Nlx2MatVT('VT1.nvt',[1 1 1 0 0 0],1,1,[]);
ts=ts/1e6;

[~,frameRateStr]=strtok(Header{27},' ');
frameRate=str2num(frameRateStr);
mistracked=find(diff(ts)>2/frameRate);

for m=1:length(mistracked)
    [~,closestLFPb(m)]=min(abs(timeVector-ts(mistracked(m))));
    [~,closestLFPa(m)]=min(abs(timeVector-ts(mistracked(m)+1)));
end

%keep the full version, i.e., including the mistracked slopts
lfpFull = lfp;
timeVectorFull = timeVector;

if ~isempty(mistracked)
    
    within=[];
    segINXstart=[1 closestLFPa];
    segINXend=[closestLFPb length(timeVector)];
    for s=1:length(segINXstart)
        within=[within segINXstart(s):segINXend(s)];
    end
    timeVector=setdiff(timeVector,timeVector(within));
    lfp(:,within)=[];
    
end

%       closestLFP=min(timeVector-ts(mistracked(m)-1));

saveStr=[datestr,'dat.mat'];
save(saveStr,'ts','posx','posy','frameRate','lfp','channel','SF_orig','SF','timeVector','mistracked', 'lfpFull', 'timeVectorFull');
cd (current_directory)

end

function Samples = SamplesPadding(Samples, TimeStamps, tickInt)
diffs = diff(TimeStamps);
GapsIndxs = find(diffs>tickInt);
if (~isempty(GapsIndxs))
    for i=length(GapsIndxs):1
        currentGapLength = diffs(GapsIndxs(i));
        numOfMissingColumns = floor(currentGapLength/tickInt);
        padding = NaN (512,numOfMissingColumns);
        Samples = [Samples(:,1:GapsIndxs) padding Samples(:,GapsIndxs+1:end)];
    end
end
end