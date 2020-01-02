function [nspikes,blmn,blstd,AinRaster,AinLabels,AoutRaster,AoutLabels,BinRaster,BinLabels]= makeRasterFile(eventsStruct, st, binsize, cut)

if nargin == 2 % default
    binsize = 1; % 1 ms bin
    cut = [-2.5 2.5]; %+-/ 2.5 s
    plotOption = 0;
elseif nargin == 3
    cut = [-2.5 2.5]; %+-/ 2.5 s
    plotOption = 0;
end
windowSize = diff(cut)/1;   % for baseline calculations, to create z scores


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load data from the eventsStruct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[event_times, selected_arms, rewarded_arm1, rewarded_arm2] = extract_event_times(eventsStruct);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating a table containing for each trial the relevant data values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_trials = size(selected_arms,1);
trialInfo = 9 * ones(num_trials,6);  % 9 will code formissing data (usually unperformed trial)

trialInfo(:,1) = 1:num_trials;
trialInfo(:,2) = selected_arms;
trialInfo(:,[3 4]) = [rewarded_arm1, rewarded_arm2];
trialInfo(:,5) = selected_arms==rewarded_arm1 | selected_arms==rewarded_arm2;
trialInfo(:,6) = 2 - (selected_arms == 1 | selected_arms == 2);

blTimeBins = st(1):windowSize:st(end);
ns = zeros(1,length(blTimeBins));
for b = 2:length(blTimeBins)
    ns(b) = length(find(st > blTimeBins(b-1) & st <= blTimeBins(b)));
end
blmn=mean(ns/windowSize);
blstd=std(ns/windowSize);
nspikes=length(st);

[BinRaster, BinLabels]=CreateStruct(event_times(:,3), st, cut, binsize, trialInfo);
[AinRaster, AinLabels]=CreateStruct(event_times(:,2), st, cut,binsize, trialInfo);
[AoutRaster, AoutLabels]=CreateStruct(event_times(:,5), st, cut,binsize, trialInfo);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Raster, Labels]=CreateStruct(Event, st, cut, binsize, trialInfo)
binneddotd = sparse(size(Event,1),length(cut(1)*1000:binsize:cut(2)*1000)); % for psth
dotd=sparse(size(Event,1),length(cut(1)*1000:cut(2)*1000));

for r=1:size(Event,1)
    TE=Event(r);
    trange=TE+cut ;
    inxsp=st>trange(1)&st<=trange(2);
    s=st(inxsp);
    dotd(r,max(1,floor((s-trange(1))*1000)))=1;
    binneddotd(r,:) = hist(s,trange(1):binsize/1000:trange(2));
end
Raster = full(dotd);


Labels.TrialNum = trialInfo(:,1);
Labels.Chosen = trialInfo(:,2);
Labels.CorrectArm1 = trialInfo(:,3);
Labels.CorrectArm2 = trialInfo(:,4);
Labels.Rewarded = trialInfo(:,5);
Labels.ArmType = trialInfo(:,6);
binpst = sum(full(binneddotd))/size(binneddotd,1)*(1000/binsize);
binpst=filtfilt(gauss(1),1,binpst);

end

function gaussFilter = gauss(sigma)
width = round((6*sigma - 1)/2);
support = (-width:width);
gaussFilter = exp( -(support).^2 ./ (2*sigma^2) );
gaussFilter = gaussFilter/ sum(gaussFilter);
end