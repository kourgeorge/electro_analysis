function trackingStruct = extractTracking( trackingRawDataPath )
%EXTRACTTRACKING Summary of this function goes here
%   Detailed explanation goes here

trackingFilePath = fullfile(trackingRawDataPath,'VT1.nvt');
[timeStamp, posx, posy,Header] = Nlx2MatVT(trackingFilePath,[1 1 1 0 0 0],1,1,[]);
timeStamp=timeStamp/1e6;

[~,frameRateStr]=strtok(Header{27},' ');
frameRate=str2num(frameRateStr);
mistracked=find(diff(timeStamp)>2/frameRate);

for m=1:length(mistracked)
    [~,closestLFPb(m)]=min(abs(timeVector-timeStamp(mistracked(m))));
    [~,closestLFPa(m)]=min(abs(timeVector-timeStamp(mistracked(m)+1)));
end

if ~isempty(mistracked)
    
    within=[];
    segINXstart=[1 closestLFPa];
    segINXend=[closestLFPb length(timeVector)];
    for s=1:length(segINXstart)
        within=[within segINXstart(s):segINXend(s)];
    end
    timeVector=setdiff(timeVector,timeVector(within));
    %lfp(:,within)=[];
    
end

trackingStruct.frameRate = frameRate;
trackingStruct.timeStamp=timeStamp;
trackingStruct.posx=posx;
trackingStruct.posy=posy;
trackingStruct.mistracked = mistracked;

end

