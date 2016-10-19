
%set environment parameters
dataFolder = 'D:\data_jan\';
outputfolder = '../output';

listing = dir('D:\data_jan\');

experiments = [];
for i=1:length(listing)
    fileName = listing(i).name;
    res = strfind(fileName,'dat.mat');
    if (~isempty(res))
        experiments = [experiments,{fileName(1:res-1)}];
    end
end

experiments ={'004_26012016'};
%Craete spectrograms for 3 events: aBbeam, bBeam, Nope poke
for i=1:length(experiments)
    generatespectrograms(dataFolder, experiments{i}, outputfolder);
end