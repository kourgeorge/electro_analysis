function createRasterFiles(filerLabel, filterValues)
%CREATERASTERFILES Given the single unit data and the behavioural data
% folder, this functions scan all the files to extract raster files and save the to the disk
% with the relevant name and in the relevant folder which represent the event.
% 


electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats';
saveFolder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters2';

%day_files = dir([electro_folder,'\*events_g.mat']); %look for all single units files in the stage
day_files = dir([electro_folder,'\*\*\*\*events_g.mat']); %look for all single units files in the stage

for j = 1:length(day_files)
    day_folder = day_files(j).folder;
    SS_files = dir([day_folder,'\*_SS_*.ntt']); %look for all single units files in the stage
    
    num_neurons = length(SS_files);
    for i = 1:num_neurons
        neuron_filename = SS_files(i).name;
        ss_file = [SS_files(i).folder,'\',neuron_filename];
        
        %Extract data to show neural activity during the day
        idcs   = strfind(ss_file,'\');
        neuron_name = ss_file(idcs(end)+1:end-4);
        stage = ss_file(idcs(end-2)+1:idcs(end-1)-1);
        day = ss_file(idcs(end-1)+1:idcs(end)-1);
        
        
        %Load data and extract meta information
        [behave, st] = load_spikes_and_behavioral_data (ss_file);
        
        [behave_struct.event_times, behave_struct.selected_arms, ...
            behave_struct.rewarded_arm1, behave_struct.rewarded_arm2] = extract_event_times(behave);

        binsize = 50;
        cut_info.ITI = [-1,2];
        cut_info.NP = [-1,2];
        cut_info.Ain = [-1,2];
        cut_info.Bin = [-1,2];
        cut_info.Aout = [-1,2];

        [nspikes ,blmn, blstd, Labels, ITIRaster, AinRaster,AoutRaster, BinRaster, NPRaster, AllRaster] = ...
            makeRasterData(behave_struct, st, binsize, cut_info);
        
         dataCelllArr = [{'ITI'}, {ITIRaster};
                {'NP'}, {NPRaster};
                {'Ain'}, {AinRaster};
                {'Aout'}, {AoutRaster};
                {'Bin'}, {BinRaster}
                %{'All'}, {AllRaster}
                ];
            
            
        if nargin>1
            
            indcs = find(ismember(Labels.(filerLabel),filterValues));
            Labels = filter_all_struct_fields(Labels,indcs);
            for k=1:size(dataCelllArr,1)
                tmp=dataCelllArr{k,2};
                dataCelllArr(k,2)={tmp(indcs,:)};
                
            end
        end
        
        for ev=1:size(dataCelllArr,1)
            eventName = dataCelllArr{ev,1};
            raster_data = dataCelllArr{ev,2};
            raster_labels = Labels;
            
            raster_site_info.event = eventName;
            raster_site_info.date = day;
            raster_site_info.cell = neuron_name;
            raster_site_info.stage = stage;
            raster_site_info.basemean = blmn;
            raster_site_info.basestd = blstd;
            raster_site_info.cut_info = cut_info.(eventName);
            raster_site_info.binsize = binsize;
            saveFile = fullfile(saveFolder,eventName,[stage,'_',day,'_',neuron_name,'.mat']);
            save(saveFile,'raster_data','raster_labels','raster_site_info');
        end
    end
        
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function struct = filter_all_struct_fields(struct, indcs)
fn=fieldnames(struct);
for k=1:numel(fn)
    label = struct.(fn{k});
    struct.(fn{k})= label(indcs);
end

end
