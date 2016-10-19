function generatespectrograms(datafolder, experiment_name, outputfolder)
%loting events graph grids for experiment experiment_name.
%%usage: generatespectrograms('C:\Users\kour\Dropbox\Ph.D\matlab_events\dat_events', 'rat1_1204', 'C:\Users\kour\Dropbox\Ph.D\matlab_events\output')

disp (['ploting events graph grids for experiment: ',experiment_name]);

%Initialize and load data
dataStructFile = fullfile(datafolder,[experiment_name,'.mat']);
dataStruct = importdata(dataStructFile);

if ~exist(fullfile(outputfolder), 'dir')
    mkdir(fullfile(outputfolder));
end

timeVector = dataStruct.lfpStruct.timeVector;
lfp = dataStruct.lfpStruct.lfp(1,:);

if(timeVector(end)-timeVector(1)<60*5)
    disp(['experiment time is too short: ',num2str((timeVector(end)-timeVector(1))/60,2) ,' only minutes!']);
    return;
end

Abeam_entrance = dataStruct.eventsStruct.aBeamEnter;
Bbeam_entrance = dataStruct.eventsStruct.bBeamEnter;
Abeam_exit = dataStruct.eventsStruct.aBeamExit;
NP = dataStruct.eventsStruct.NP;
% generate a plot grid for each event
disp('Generating Abeam grid...')
ploteventspectrogramgrid(Abeam_entrance, timeVector, lfp, experiment_name, outputfolder)
disp('Generating Bbeam grid...')
ploteventspectrogramgrid(Bbeam_entrance, timeVector, lfp, experiment_name, outputfolder)
disp('Generating NP grid...')
np_event = get_np_times(NP(:,2), Abeam_entrance(:,2), Abeam_exit(:,2));
ploteventspectrogramgrid(np_event,timeVector, lfp, experiment_name, outputfolder)

end

function ploteventspectrogramgrid(event, timeVector, lfp, experiment_name, outputfolder)
fig = figure('Name', 'Results');

subplot(3,3,1)
ploteventspectrogram (event, timeVector, lfp , [1,0.1], 500);
subplot(3,3,2)
ploteventspectrogram (event, timeVector, lfp, [3,0.3], 500);
subplot(3,3,3)
ploteventspectrogram (event, timeVector, lfp, [5,0.5], 500);

subplot(3,3,4)
ploteventspectrogram (event, timeVector, lfp, [1,0.1], 2000);
subplot(3,3,5)
ploteventspectrogram (event, timeVector, lfp, [3,0.3], 2000);
subplot(3,3,6)
ploteventspectrogram (event, timeVector, lfp, [5,0.5], 2000);


subplot(3,3,7)
ploteventspectrogram (event, timeVector, lfp, [1,0.1], 5000);
subplot(3,3,8)
ploteventspectrogram (event, timeVector, lfp, [3,0.3], 5000);
subplot(3,3,9)
ploteventspectrogram (event, timeVector, lfp, [5,0.5], 5000);

saveas(fig, fullfile(outputfolder,[experiment_name,'_',inputname(1)]), 'jpg');
saveas(fig, fullfile(outputfolder,[experiment_name,'_',inputname(1)]), 'pdf');
close (fig)
end


function NP_norm = get_np_times(orig_NP,aBeamIn, aBeamOut)
%%%%NP_norm = get_np_times(NP(:,2),Abeam_entrance(:,2), Abeam_exit(:,2))

num_trials = min(size(aBeamIn,1),size(aBeamOut,1));

%first NP
frst_poke = orig_NP(find(orig_NP<aBeamIn(1)));
NP_norm = [min(frst_poke)];

for n=2:num_trials
    pokes_before_trial = find(orig_NP<aBeamIn(n) & orig_NP>aBeamOut(n-1));
    frst_poke = min(orig_NP(pokes_before_trial));
    NP_norm = [NP_norm,frst_poke];
end
%NP_norm(NP_norm==0) = [];

end