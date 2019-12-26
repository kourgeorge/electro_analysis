function [EnoughCells,EnoughCellsINX] = prepareClassifier(event,toDecode,binSize,sampleWindow)

%[EnoughCells,EnoughCellsINX] = prepareClassifier('Ain','Chosen',150,50)

maxSplits = 40;
%%%%%%%%%%%%%%%
% create binned vectors from the rasters in the folder 'event', by binning
% binSize (ms) bins (suggested default 150), and averageing every sampleWindow
% (suggested default 50) ms
rastersFolder = fullfile('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Decoding',event);
binnedName = fullfile('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Decoding',[event,'_Binned']);
create_binned_data_from_raster_data(rastersFolder,binnedName,binSize,sampleWindow);

%%%%%%%%%%%%%
% determine how many cross validation splits to use
% find how many cells with at least k repetitions of each condition (according to the labels)
% exists for a particular decoding variable binned_label.stimulusID

binnedDataName = fullfile('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Decoding',[event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat']);
l = load(binnedDataName,'binned_labels');
eval(['labelToDecode = l.binned_labels.',toDecode,';']);
% labelToDecode = {['binned_labels.',toDecode]};
EnoughCells = zeros(maxSplits,1);
for k = 1:maxSplits
    [EnoughCells(k),EnoughCellsINX{k}] = whichCellsHaveEnough(toDecode,labelToDecode,k);
end
end




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