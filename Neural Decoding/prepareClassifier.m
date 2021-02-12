function [EnoughCells,EnoughCellsINX] = prepareClassifier(rastersDir, event,toDecode,binSize, sampleWindow, stage)


%[EnoughCells,EnoughCellsINX] = prepareClassifier('/Users/gkour/Box/phd/Electro_Rats/Rasters_100_simple', 'Ain','Chosen',150,50)

if nargin > 5
	rastersFolder = fullfile(rastersDir,event,['*', stage,'*']);
    binnedName = fullfile(rastersDir,[event,'_Binned']);
else
	rastersFolder = fullfile(rastersDir,event);
    binnedName = fullfile(rastersDir,[event,'_Binned']);
end

maxSplits = 40;
%%%%%%%%%%%%%%%
% create binned vectors from the rasters in the folder 'event', by binning
% binSize (ms) bins (suggested default 150), and averaging every sampleWindow
% (suggested default 50) ms


saved_binned_data_file_name = create_binned_data_from_raster_data(rastersFolder,binnedName,binSize,sampleWindow);

%%%%%%%%%%%%%
% determine how many cross validation splits to use
% find how many cells with at least k repetitions of each condition (according to the labels)
% exists for a particular decoding variable binned_label.stimulusID
l = load(saved_binned_data_file_name,'binned_labels');
labelToDecode = l.binned_labels.(toDecode);
allPossibleValues = getLabelValues(toDecode);

EnoughCells = zeros(maxSplits,1);

for k = 1:maxSplits
    [EnoughCells(k),EnoughCellsINX{k}] = cellsWithEnoughRepetitions(allPossibleValues,labelToDecode,k);
end
end
