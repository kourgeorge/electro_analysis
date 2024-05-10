function [GapsInx, TimeStamps, Samples, SumGap]=findsamplinggapgs(datestr,LFPchannel)
chSTR=[datestr,'\CSC',num2str(LFPchannel),'.ncs'];
[TimeStamps,Samples] = Nlx2MatCSC(chSTR,[1 0 0 0 1],0,1,[]);

diffs = diff(TimeStamps);
GapsInx = find(diffs>16000);

SumGap=0;
for i=1:length(GapsInx)
   currentGap = diffs(GapsInx(i))/1e6;
   SumGap= SumGap+currentGap;
end
