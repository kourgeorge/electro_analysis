% learningStage = rHbt, rOD1, rOD2, rLG
% cellType =
PROJECTS_DIR;
saveFolder = fullfile(PROJECTS_DIR,'FlaviasRats','Classifier');
medFolder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\MedData';

clear rHbt rOD1 rOD2 rLG

stage={'odor1_WR','odor1_WR','odor1_WR','rLG'};


load(fullfile(PROJECTS_DIR,'FlaviasRats','Recording','CellList'));


% cd(fullfile(PROJECTS_DIR,'flaviasRats','recording','hbt','PlusMaze_Flavia'));
% cd(fullfile('I:','My Drive','PlusMaze_Flavia'));
mis = 0;
nofile = 0;
tot = 0;
for s=2:length(stage) % there's no point of doing this with HBT
    %  for s = 1
    eval(['stgdata = ',stage{s},';']);
    
    for h=1:length(stgdata)
        tot = tot+1;
        clear event*
        %         if h == 7
        %             disp('stop for debugging')
        %         end
        disp([num2str(h),' ',stgdata{h}.date]);
        eventfile=fullfile(PROJECTS_DIR,'flaviasRats','recording',[stgdata{h}.date,'events_g.mat']);
        eventDate = stgdata{h}.date(1:12);
        eventobj = matfile(eventfile);
        trialsInFile = [eventobj.correctArm eventobj.incorrectArm];
        if ~isfield(eventobj,'irrelevant1')
            [allTrials,fullTable] = extractAllTrials(medFolder,eventDate); % these are all trials in MED files
            medTrials = fullTable;
            if ~isempty(allTrials)
                [firstTrial,lastTrial,flag] = findTrialSequence(allTrials,trialsInFile);
                if ~flag
                    [irrelevant1,irrelevant2] = addirrelevant(medFolder,eventDate,firstTrial,lastTrial);
                    irrelevant1 = [trialsInFile(:,1) irrelevant1];
                    irrelevant2 = [trialsInFile(:,1) irrelevant2];
                    if isfield(eventobj,'eventsStruct')
                        eventobj.eventsStruct.irrelevant1 = irrelevant1;
                        eventobj.eventsStruct.irrelevant2 = irrelevant2;
                        save(eventfile,'eventsStruct','-append');
                    end
                    save(eventfile,'irrelevant1','irrelevant2','-append');
                else
                    warning(['mismatch between event file ',eventfile,' and Med file ',eventDate]);
                    mis = mis+1;
                    save(eventfile,'medTrials','-append');
                end
            else
                warning(['missing Med file ',eventDate]);
                nofile = nofile+1;
                
            end
        end
    end
    disp(['number of mismatches = ',num2str(mis)]);
    disp(['number of missing files = ',num2str(nofile)]);
    disp(['number of total files = ',num2str(tot)]);
end



function [firstTrial,lastTrial,flag] = findTrialSequence(allTrials,trialsInFile)
firstTrial = 0;
lastTrial = 0;
flag = 0;
for t = 1:max(1,size(allTrials,1)- size(trialsInFile,1))
    candidate = allTrials(t:t+size(trialsInFile,1)-1,[2 3]) - trialsInFile(:,[2 4]);
    if isempty(find(candidate, 1))
        firstTrial = t;
        lastTrial = t+size(trialsInFile,1)-1;
        break
    end
end
if firstTrial == lastTrial
    flag = 1;
end
end

function [irrelevant1All,irrelevant2All] = addirrelevant(medFolder,eventDate,firstTrial,lastTrial)
medFile = fullfile(medFolder,[eventDate,'.csv']);
datTable = csvread(medFile,1,0);
irrelevant1All = datTable(firstTrial:lastTrial,7);
irrelevant2All = datTable(firstTrial:lastTrial,8);
end







