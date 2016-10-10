function [ lfpStruct ] = extractLFP( lfpRawDataPath, LFPchannels )
%EXTRACTLFP Summary of this function goes here
%   Detailed explanation goes here

samplingRateTarget = 1000;
for i=1:length(LFPchannels)
    % extract full CSC vector and timestamps and some useful information,
    % and downsample the vector to 1000 Hz for saving.
    chSTR=['CSC',num2str(LFPchannels(i)),'.ncs']; % get the filename corresponding to the channel.
    channelFilePath = fullfile(lfpRawDataPath,chSTR);
    [timeStamps,samples] = Nlx2MatCSC(channelFilePath,[1 0 0 0 1],0,1,[]); % read the samples and timestamps.
    headerInfo=Nlx2MatCSC(channelFilePath,[0 0 0 0 0],1,3,0);   %read the CSC header info
    [~,conv2VoltStr]=strtok(headerInfo{16},' '); 
    conv2microV=str2double(conv2VoltStr)*1e6;
    [~,sfStr]=strtok(headerInfo{14},' ');
    samplingRateOrig=str2double(sfStr);
    tickInt = (512/samplingRateOrig)*1e6;
    samples = SamplesPadding(samples, timeStamps, tickInt);
    lfp(i,:)=resample(samples(:)*conv2microV,samplingRateTarget,samplingRateOrig);
    

end
% we assume unified timevector for all channels.
timeVector=linspace(timeStamps(1),timeStamps(end)+tickInt,length(lfp))/1e6;
    
lfpStruct.lfp=lfp;
lfpStruct.samplingRate = samplingRateTarget;
lfpStruct.channels = LFPchannels;
lfpStruct.timeVector = timeVector;
    
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
