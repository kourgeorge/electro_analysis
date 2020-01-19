function [EnoughCells,EnoughCellsINX] = prepareClassifier(rastersDir, event,toDecode,binSize, sampleWindow, stage)


%[EnoughCells,EnoughCellsINX] = prepareClassifier('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters', 'Ain','Chosen',150,50)

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

EnoughCells = zeros(maxSplits,1);
for k = 1:maxSplits
    [EnoughCells(k),EnoughCellsINX{k}] = whichCellsHaveEnough(toDecode,labelToDecode,k);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [EnoughCells,EnoughCellsINX] = whichCellsHaveEnough(toDecode,labelToDecode,k)
EnoughCells = 0;
EnoughCellsINX = [];
switch toDecode
    case 'Chosen'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm1'
        allPossibilities = [1 2 3 4];
    case 'CorrectArm2'
        allPossibilities = [1 2 3 4];
    case 'Rewarded'
        allPossibilities = [0 1];
    case 'ArmType'
        allPossibilities = [1 2];
end
for c = 1:length(labelToDecode)
    labels = labelToDecode{c};
    %     validLabels = labels(~isnan(labels));
    validLabels = labels(labels ~= 9); %formerly NANs
    [T,~,it] = unique(validLabels);
    if length(T) == length(allPossibilities)
        
        for t = 1:length(T) % go over conditions
            numrep(t) = length(find(it == t));
        end
        minrep = min(numrep);
        if minrep >= k
            EnoughCells = EnoughCells + 1;
            EnoughCellsINX = [EnoughCellsINX c];
        end
    end
end
end