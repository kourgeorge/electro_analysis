function generatespectrogramsforexperiment(datafolder, experiment_name, outputfolder)
%ploting events graph grids for experiment experiment_name.
%%usage: generatespectrogramsforexperiment('D:\data_jan', '004_26012016', 'D:\data_jan\output')

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


fig = figure('Name', 'Results');
subplot(3,3,1)
ploteventspectrogram (Abeam_entrance, timeVector, lfp, [1,0.1], 2000);
subplot(3,3,2)
ploteventspectrogram (Abeam_entrance, timeVector, lfp, [1,0.1], 5000);
subplot(3,3,3)
ploteventspectrogram (Abeam_entrance, timeVector, lfp, [5,0.5], 5000);

subplot(3,3,4)
ploteventspectrogram (Bbeam_entrance, timeVector, lfp, [1,0.1], 2000);
subplot(3,3,5)
ploteventspectrogram (Bbeam_entrance, timeVector, lfp, [1,0.1], 5000);
subplot(3,3,6)
ploteventspectrogram (Bbeam_entrance, timeVector, lfp, [5,0.5], 5000);

subplot(3,3,7)
ploteventspectrogram (Abeam_exit, timeVector, lfp, [1,0.1], 2000);
subplot(3,3,8)
ploteventspectrogram (Abeam_exit, timeVector, lfp, [1,0.1], 5000);
subplot(3,3,9)
ploteventspectrogram (Abeam_exit, timeVector, lfp, [5,0.5], 5000);

savefig(fig,fullfile(outputfolder, experiment_name));
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