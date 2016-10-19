function dataStruct = extractDataStruct( rawDataPath, channels, targetFilePath )
%CREATEDATASTRUCT This function creates an dataStruct of the electro-physiological, behavioral
% and the traching information of an experiment.
% The structure defined in the specification document here:
% https://drive.google.com/open?id=1JRUhBfz3FGDYr1szr9Vn3MvOIOrdoatGs8SEaDq3hjs

%   Usage: extractDataStruct( 'D:\data_jan\004_28012016', 34, 'D:\data_jan\004_28012016.mat' )

dataStruct.lfpStruct = extractLFP( rawDataPath, channels);
%dataStruct.trackingStruct = extractTracking(rawDataPath);
dataStruct.eventsStruct = extractEvents(rawDataPath);

save(targetFilePath,'dataStruct');

end

