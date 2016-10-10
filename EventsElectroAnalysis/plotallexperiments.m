
%set environment parameters
datafolder = '../data';
outputfolder = '../output';

listing = dir('../data');

experiments = [];
for i=1:length(listing)
    fileName = listing(i).name;
    res = strfind(fileName,'dat.mat');
    if (~isempty(res))
        experiments = [experiments,{fileName(1:res-1)}];
    end
end

experiments ={'rat1_1404'};
%Craete spectrograms for 3 events: aBbeam, bBeam, Nope poke
for i=1:length(experiments)
    generatespectrograms(datafolder, experiments{i}, outputfolder);
end