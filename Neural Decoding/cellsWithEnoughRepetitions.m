function [EnoughCells,EnoughCellsINX]  = cellsWithEnoughRepetitions(allPossibleValues,cellTrialsLabels,num_repetitions)
%CELLSWITHENOUGHREPETITIONS Summary of this function goes here
%   Detailed explanation goes here
EnoughCells = 0;
EnoughCellsINX = [];
for c = 1:length(cellTrialsLabels)
    labels = cellTrialsLabels{c};
    %validLabels = labels(~isnan(labels));
    %validLabels = labels(labels ~= 9); %formerly NANs
    [T,~,it] = unique(labels);
    
    if length(T) == length(allPossibleValues)
        
        for t = 1:length(T) % go over conditions
            numrep(t) = length(find(it == t));
        end
        minrep = min(numrep);
        if minrep >= num_repetitions
            EnoughCells = EnoughCells + 1;
            EnoughCellsINX = [EnoughCellsINX c];
        end
    end
end
end
