function compareBehavioralData()

%Load the med file
%Load the neuralynx events file

medFolder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\MedData';
extractAllTrials(medFolder,eventDate)


end


function [AllTrials,datTable] = extractAllTrials(medFolder,eventDate)
medFile = fullfile(medFolder,[eventDate,'.csv']);
if exist(medFile,'file')
    datTable = csvread(medFile,1,0);
    AllTrials = datTable(:,1:3); % trial number|correct arm|incorrect arm
else
    datTable = [];
    AllTrials = [];
end
end