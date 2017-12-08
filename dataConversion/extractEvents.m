function eventsStruct = extractEvents(eventsDataPath)
%EXTRACTEVENTS Summary of this function goes here
%   Detailed explanation goes here

eventsFilePath = fullfile(eventsDataPath,'Events.nev');

[timeStamps, ~, TTLs, ~, EventStrings, ~] = Nlx2MatEV(eventsFilePath, [1 1 1 1 1], 1, 1, [] );

binaryTTLs=[];
for i=1:length(TTLs)
    binaryTTLs{i,1}=dec2bin(TTLs(i),8);
end

%extract port for each event:
ports= NaN(length(EventStrings),1);  %first define all entries as NaNs
for i=1:length(EventStrings)
    str=EventStrings{i};
    if ~isempty( strfind(str, 'port'))
        port_num= str(strfind(str, 'port')+5);
        ports(i,1)=str2double(port_num);
    end
end

timeStamps=(timeStamps/1e6)';  %convert to sec

%first search for ITIs.
ITI = getITI(ports, binaryTTLs, timeStamps);

%after each ITI, search for stimuli presented, and NPs+IR movements.
rewards = getRewards(ports, binaryTTLs, timeStamps, ITI);
[correctArm,incorrectArm] = getArmsInfo(ports, binaryTTLs, ITI, timeStamps);
NP = getNPInfo(ports, binaryTTLs, timeStamps);
NP = devideNPsToTrials(NP, [correctArm(:,2), incorrectArm(:,2)], ITI);
[Abeam_entrance, Abeam_exit, Bbeam_entrance, Bbeam_exit] = getABBeams(ports, binaryTTLs, timeStamps, ITI, rewards);


eventsStruct.ITI = ITI;
eventsStruct.rewards = rewards;
eventsStruct.correctArm = correctArm;
eventsStruct.incorrectArm = incorrectArm;
eventsStruct.NP = NP;
eventsStruct.aBeamEnter = Abeam_entrance;
eventsStruct.aBeamExit = Abeam_exit;
eventsStruct.bBeamEnter = Bbeam_entrance;
eventsStruct.bBeamExit = Bbeam_exit;

end

function ITI = getITI(ports, binaryTTLs, timeStamps)
% NOTE: in the current paradigm ITI=0, thus the signal of Z^ITI actually represents
% the start of trial
ITI=[];
for i=1:length(binaryTTLs)
    if ports(i)==1 && binaryTTLs{i,1}(1,5)=='0'
        ITI(end+1,1)=i;  %index
        ITI(end,2)=timeStamps(i); %timestamp
    end
end
%clean ITI from un-explained repetition of the same value over several
%Timestamps:
intervalBetweeenITIs= ITI(2:end,2)-ITI(1:end-1,2);
indices_to_delete = find(intervalBetweeenITIs <0.01);
ITI(indices_to_delete,:)=[];

end

function rewards = getRewards(ports, binaryTTLs, timeStamps, ITI)

allRewards=[];
rewards=[];
%collect all reward events
for i=1:length(binaryTTLs)
    if ports(i)==1 && binaryTTLs{i,1}(1,6)=='0'
        allRewards = [allRewards; i, timeStamps(i)];
    end
end
%choose only the first event in each trial (there can be only 1 reward event in a trial)
if ~isempty(allRewards)
    for j=1:length(ITI)-1
        % find the rewards in timestamps between ITI_i and iTI_{i+1}
        minIndex= min( find(allRewards(:,2) > ITI(j,2) & allRewards(:,2) < ITI(j+1,2)));
        if (~isempty(minIndex))
            rewards = [rewards; [allRewards(minIndex,:), j]];
        end
    end
    j=length(ITI); %for the last trial: there's no ITI after it
    minIndex= min( find(allRewards(:,2) > ITI(j,2)));
    if (~isempty(minIndex))
        rewards = [rewards; [allRewards(minIndex,:), j]];
    end
end
end

function [correctArm, incorrectArm] = getArmsInfo(ports, binaryTTLs, ITI, timeStamps)
All_CorrectArm=[];
All_IncorrectArm=[];
for i=1:length(binaryTTLs)
    if ports(i)==0
        switch(binaryTTLs{i,1}(1,6:8))
            case '110' %this is arm 001 = arm 1
                All_CorrectArm = [All_CorrectArm; i, 1, timeStamps(i)];
            case '101' %this is arm 010 = arm 2
                All_CorrectArm = [All_CorrectArm; i, 2, timeStamps(i)];
            case'100' %this is arm 011 = arm 3
                All_CorrectArm = [All_CorrectArm; i, 3, timeStamps(i)];
            case '011' %this is arm 100 = arm 4
                All_CorrectArm = [All_CorrectArm; i, 4, timeStamps(i)];
        end
        
        switch binaryTTLs{i,1}(1,3:5)
            case '110' %this is arm 001 = arm 1
                All_IncorrectArm = [All_IncorrectArm; i, 1, timeStamps(i)];
            case '101' %this is arm 010 = arm 2
                All_IncorrectArm = [All_IncorrectArm; i, 2, timeStamps(i)];
            case '100' %this is arm 011 = arm 3
                All_IncorrectArm = [All_IncorrectArm; i, 3, timeStamps(i)];
            case '011' %this is arm 100 = arm 4
                All_IncorrectArm = [All_IncorrectArm; i, 4, timeStamps(i)];
        end
    end
end

%choose only the first event in each trial
correctArm=[];
incorrectArm=[];
if ~isempty(All_CorrectArm)
    for j=1:length(ITI)-1
        min_index= min( find(All_CorrectArm(:,end) > ITI(j,2) & All_CorrectArm(:,2) < ITI(j+1,2)));
        correctArm = [correctArm; All_CorrectArm(min_index,1:end-1)]; %Do not add the timestamp field
    end
    j=length(ITI); %for the last trial: there's no ITI after it
    min_index= min( find(All_CorrectArm(:,end) > ITI(j,2)));
    correctArm = [correctArm; All_CorrectArm(min_index,1:end-1)];
end

if ~isempty(All_IncorrectArm)
    for j=1:length(ITI)-1
        min_index= min( find(All_IncorrectArm(:,end) > ITI(j,2) & All_IncorrectArm(:,2) < ITI(j+1,2)));
        incorrectArm = [incorrectArm; All_IncorrectArm(min_index,1:end-1)];
    end
    j=length(ITI); %for the last trial: there's no ITI after it
    min_index= min( find(All_IncorrectArm(:,end) > ITI(j,2)));
    incorrectArm = [incorrectArm; All_IncorrectArm(min_index,1:end-1)];
end
end

function NP = getNPInfo(ports, binaryTTLs, timeStamps)
%a new NP event may be defined only after the previous event was closed
%with a '1' bit

NP=[];
for i=1:length(binaryTTLs)
    if i==1
        if ports(i)==0
            if(binaryTTLs{i}(2)=='0')
                NP = [NP; [i, timeStamps(i), 1]];
            elseif  binaryTTLs{i}(1)=='0'
                NP = [NP; [i, timeStamps(i), 2]];
            end
        elseif ports(i)==1
            if(binaryTTLs{i}(8)=='0')
                NP = [NP; [i, timeStamps(i), 3]];
            elseif  binaryTTLs{i}(7)=='0'
                NP = [NP; [i, timeStamps(i), 4]];
            end
        end
    else
        if ports(i)==0
            if(binaryTTLs{i}(2)=='0') && ((binaryTTLs{i-1}(2)=='1' && ports(i-1)==0) || ports(i-1)==1 )
                NP = [NP; [i, timeStamps(i), 1]];
            elseif binaryTTLs{i}(1)=='0' && ((binaryTTLs{i-1}(1)=='1' && ports(i-1)==0) || ports(i-1)==1 )
                NP = [NP; [i, timeStamps(i), 2]];
            end
        elseif ports(i)==1
            if(binaryTTLs{i}(8)=='0')&& ((binaryTTLs{i-1}(8)=='1' && ports(i-1)==1) || ports(i-1)==0 )
                NP = [NP; [i, timeStamps(i), 3]];
            elseif  binaryTTLs{i}(7)=='0'&& ((binaryTTLs{i-1}(7)=='1' && ports(i-1)==1) || ports(i-1)==0 )
                NP = [NP; [i, timeStamps(i), 4]];
            end
        end
    end
end
end

function NPDevidedToTrials = devideNPsToTrials(NP, Arms, ITI)
%now filter consecutive appearances of the same NP events:
%when such cosecutive sequence is found, its first element is defined as
%NPstart and its last element as NPend. when there's no sequence, only
%single element, it's defined as both NPstart and NPend:
NPintervals=NP(2:end,2)-NP(1:end-1,2);

NPintervals(:,2)=(NPintervals(:,1)<0.5); %mark all intervals that are smaller than 500msec
x=find( NPintervals(:,2)==0); %x contains intervals bigger than500msec
NPstart=NP(1,:);
for i=x'
    NPstart=[NPstart; NP(i+1,:)];  %the end point of an interval>0.5 is actually the NPstart we're looking for
end


% ascribe NP to trials:
NPDevidedToTrials=[];
numTrials = size(ITI, 1);
for i=1:numTrials
    if i==numTrials   %for the last trial:
        IndicesofNPsInTrial=find(NPstart(:,2)>=ITI(i,2));
    else
        IndicesofNPsInTrial=find(NPstart(:,2)>=ITI(i,2) & NPstart(:,2)<ITI(i+1,2));
    end
    % fields in NP_trial:  Np time | Arm | was this correct arm(=1) or
    % incorrect(=0) or other(=2) | trial number
    for j=IndicesofNPsInTrial'
        arm=NPstart(j,3);
        if arm == Arms(i,1)
            arm_type=1;
        elseif arm == Arms(i,2)
            arm_type=0;
        else
            arm_type=2;
        end
        NPDevidedToTrials=[NPDevidedToTrials; [NPstart(j,1) NPstart(j,2) NPstart(j,3) arm_type i]];
    end
end
end

function [Abeam_entrance, Abeam_exit, Bbeam_entrance, Bbeam_exit] = getABBeams(ports, binaryTTLs, timeStamps, ITI, rewards)

Abeam=[];
Bbeam=[];
AandB=[];
AandBwithITI=[];
%first collect all IR beams events:
for i=1:length(binaryTTLs)
    if ports(i)==1
        switch(binaryTTLs{i,1}(1,1:4))
            case'1110' %this is arm 0001 = arm 1, A beam
                Abeam = [Abeam; i, timeStamps(i), 1];
                AandB=[AandB; Abeam(end,:) ,1];
                AandBwithITI=[AandBwithITI; Abeam(end,:) ,1];
            case '1101' %this is arm 0010 = arm 2, A beam
                Abeam = [Abeam; i, timeStamps(i), 2];
                AandB=[AandB; Abeam(end,:) ,1];
                AandBwithITI=[AandBwithITI; Abeam(end,:) ,1];
            case '1100' %this is arm 0011 = arm 3, A beam
                Abeam = [Abeam; i, timeStamps(i), 3];
                AandB=[AandB; Abeam(end,:) ,1];
                AandBwithITI=[AandBwithITI; Abeam(end,:) ,1];
            case '1011' %this is arm 0100= arm 4, A beam
                Abeam = [Abeam; i, timeStamps(i), 4];
                AandB=[AandB; Abeam(end,:) ,1];
                AandBwithITI=[AandBwithITI; Abeam(end,:) ,1];
            case '1010' %this is arm 0101= arm 1, B beam
                Bbeam = [Bbeam; i, timeStamps(i), 1];
                AandB=[AandB; Bbeam(end,:) ,2];
                AandBwithITI=[AandBwithITI; Bbeam(end,:) ,2];
            case '1001' %this is arm 0110= arm 2, B beam
                Bbeam = [Bbeam; i, timeStamps(i), 2];
                AandB=[AandB; Bbeam(end,:) ,2];
                AandBwithITI=[AandBwithITI; Bbeam(end,:) ,2];
            case '1000' %this is arm 0111= arm 3, B beam
                Bbeam = [Bbeam; i, timeStamps(i), 3];
                AandB=[AandB; Bbeam(end,:) ,2];
                AandBwithITI=[AandBwithITI; Bbeam(end,:) ,2];
            case '0111' %this is arm 1000= arm 4, B beam
                Bbeam = [Bbeam; i, timeStamps(i), 4];
                AandB=[AandB; Bbeam(end,:) ,2];
                AandBwithITI=[AandBwithITI; Bbeam(end,:) ,2];
        end
    end
end
Bbeam_entrance = [];
Abeam_entrance = [];
Abeam_exit = [];
Bbeam_exit = [];

%now look for contiuous sequences of A beam, and for B beam sequences of the same
%arm, that are inside those A beam sequences:
% % A=Abeam(:,3)';
% % %//////taken from bruno
% % rep=diff(find(diff([-Inf A Inf])));  %how many times the val appears in its sequence
% % val=A(cumsum(rep));  %the value in each sequence

% AandB structure: eventID | timestamp | arm | A/B(1/2)
%The algorithm:
%==============%
%1. Use the ITI to partition A and B beam recordings to the different trials.
%2. For each trial, classify consequent sensor recordings to clusters, namely, sequence of same sensor recording with respect to the sensor type A/B and the door - not according to times.
%3. Remove clusters which represent flickering in the sensors using the following steps
%   1.If all recordings are from the same door - return
%   2. for each door, if recordings were obtained from a single sensor - filter out all the recordings from this door.
%4. Remove uncompleted trials using the following steps:
%   1.find the patter A(B*)B in the sensor recordings.
%   2.If not found - mark the trial as in-completed.
%5. Select the relevant A B A clusters as follows:
%   1. find the maximal size cluster of B, denote it as B*
%   2. find the closest A cluster before B* - denoted as A1
%   3. find the closest A cluster after B* - denoted as A2
%   4. mark all other clusters as invalid.
%6. Select the earliest recording in B*
%7. Select the earliest recording in A1.
%8. Select the latest recording in A2 

for k=1:length(ITI)
    if k==length(ITI)
        intervalBetweenITIs= find(AandB(:,2)>ITI(k,2));
    else
        intervalBetweenITIs= find(AandB(:,2)>ITI(k,2) & AandB(:,2)<=ITI(k+1,2));
    end
    if ~isempty(intervalBetweenITIs)
        interval=AandB(intervalBetweenITIs(1):intervalBetweenITIs(end),:);
        %turn the pair into one number so we can run bruno's code:
        % The equation is 10*arm+Sensor(A/B)
        interval(:,5)=10.*interval(:,3)+interval(:,4);
        A=interval(:,5)';
        rep=diff(find(diff([-Inf A Inf])));  %how many times the val appears in its sequence
        val=A(cumsum(rep));  %the value in each sequence
        arm = floor(val./10); %get back the arm number
        beam = rem(val,10); %get back the A or B beam code (1/2)
        count_appearances=[arm'  beam'   rep'];
        
        was_in_B = 0; %flag noting whether there was already a visit in Bbeam
        last_Bbeam_arm = 0; %keeps the arm where animal last visited Bbeam
        count_appearances = selectRelevantSensors(count_appearances);
        for i=1:length(count_appearances(:,1))
            if (count_appearances(i,4)==0)
                continue;
            end
            start_index=sum(count_appearances(1:i-1,3)) + 1;
            end_index=sum(count_appearances(1:i,3));
            %if it's Abeam, and flag=0
            if count_appearances(i,2)==1 && was_in_B==0
                Abeam_entrance = [Abeam_entrance; interval(start_index,1:3), k];
                %only if the next step was into Abeam of another arm, mark the end
                %of this Abeam as an exit. otherwise, the exit would be *after*
                %visiting the Bbeam:
                if i~=length(count_appearances(:,1)) && count_appearances(i+1,2)==1 %Abeam
                    Abeam_exit = [Abeam_exit; interval(end_index,1:3), k];
                end
                %if it's B beam
            elseif count_appearances(i,2)==2
                was_in_B = 1;
                Bbeam_entrance = [Bbeam_entrance; interval(start_index,1:3), k];
                Bbeam_exit = [Bbeam_exit; interval(end_index,1:3), k];
                if last_Bbeam_arm == interval(end_index,3)%if the previous visit in B was in this same arm,
                    %then the interval of Abeam between these two Bbeams contains the exit from previous B and entrance to current B
                    Abeam_entrance = [Abeam_entrance; interval(start_index-1,1:3), k];
                end
                last_Bbeam_arm = interval(end_index,3);
                % if it's an A beam that come after relevant B beam (flag=1)
            elseif count_appearances(i,2)==1 && was_in_B==1
                was_in_B = 0;
                % Insert Abeam exit to Abeam_exit array:
                Abeam_exit = [Abeam_exit; interval(start_index,1:3), k];
            end
        end
    end
end
end

function sensorsRecordings = selectRelevantSensors(sensorsRecordings)

% find flikering sensors and mark them as 0;
% find the sensors sequence of 1 2 1 with the longest sensor 2 serial
% give pariority to the first set of 1 2 1 
% mark these sensors as good

len = size(sensorsRecordings,1);
sensorsRecordings = [sensorsRecordings, ones(len,1)];
sensorsRecordings = markFlickeringSensorsRecordings(sensorsRecordings);
sensorsRecordings = markUnCompletedTrials(sensorsRecordings);
sensorsRecordings = identifyLongestSequenceOf121Recording(sensorsRecordings);

end

function sensorsRecordings = markFlickeringSensorsRecordings(sensorsRecordings)

%If all recordings are from the same door mark all recordings as valid then do nothing.
if length(unique(sensorsRecordings))==1
    return
end

%find the door with the flickering 

doors = unique(sensorsRecordings(:,1));
for door=doors'
    %get the sensors recordings for each door.
    door_sensor = unique(sensorsRecordings(sensorsRecordings(:,1)==door, 2));
    % if there is a single sensor recording then it is a flickering in that
    % sensor - so mark all recordings as invalid.
    if length(door_sensor) == 1
        sensorsRecordings(sensorsRecordings(:,1)==door, 4) = 0;
    end
end
end

function sensorsRecordings = identifyLongestSequenceOf121Recording(sensorsRecordings)
    % We assume that we have a completed trials and all recordings are from
    % the same door. 
    % The algorithm:
    % 1. concentrate on the B recordings
    % 2. find the longest B sensor recording
    % 3. Mark all other B recordings as not valid
    % 4. select the first valid sensor A and the last sensor A.
    temp = sensorsRecordings; 
    temp(temp(:,4)==0, :) = 0;
    temp(temp(:,2)==1, :) = 0;
    
    [~,longestBSeqIdx] = max(temp(:,3));  
    
    BrecordingsExceptLongets = setdiff(find(sensorsRecordings(:,4)==1 & sensorsRecordings(:,2)==2), longestBSeqIdx); 
    sensorsRecordings(BrecordingsExceptLongets,4) = 0 ;
    
    %find the last A before selected vB and the first A after selected B
    temp = sensorsRecordings; 
    temp(temp(:,4)==0, :) = 0;
    AbeforeBindx = find(temp(1:longestBSeqIdx,2)==1, 1, 'last');
    AafterBindx = find(temp(longestBSeqIdx+1:end,2)==1, 1, 'first');
    AafterBindx = AafterBindx + longestBSeqIdx;
    
    ArecordingsExceptFound = setdiff(find(sensorsRecordings(:,4)==1 & sensorsRecordings(:,2)==1), [AafterBindx, AbeforeBindx]); 
    sensorsRecordings(ArecordingsExceptFound,4) = 0 ;
end
    
function sensorsRecordings = markUnCompletedTrials(sensorsRecordings)
    
    sensor_seq = sensorsRecordings(sensorsRecordings(:,4)==1, 2);
    rep = diff(find(diff([-Inf sensor_seq' Inf])));
    val=sensor_seq(cumsum(rep));
    if ~isempty(findpattern(val, [1 2 1]))
        return
    end
    
    %mark all recordings as invalid
    sensorsRecordings(:,4)= 0;
    
end