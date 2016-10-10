function dataStruct = extractDataStruct( rawDataPath, channels, targetFilePath )
%CREATEDATASTRUCT Summary of this function goes here
%   extractDataStruct( 'D:\data_jan\004_26012016', 1:17, 'D:\data_jan\004_26012016\a.mat' )

dataStruct.lfpStruct = extractLFP( rawDataPath, channels);
dataStruct.trackingStruct = extractTracking(rawDataPath);
dataStruct.eventsStruct = extractEvents(rawDataPath);

save(targetFilePath,'dataStruct');

end

