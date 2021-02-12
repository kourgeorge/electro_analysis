function createRasterFiles(filerLabel, filterValues)
%CREATERASTERFILES Given the single unit data and the behavioural data
% folder, this functions scan all the files to extract raster files and save the to the disk
% with the relevant name and in the relevant folder which represent the event.
% 


electro_folder = '/Users/gkour/Box/phd/Electro_Rats';
saveFolder = '/Users/gkour/Box/phd/Electro_Rats/Rasters_100_augmented';

%day_files = dir([electro_folder,'\*events_g.mat']); %look for all single units files in the stage
day_files = dir([electro_folder,'/*/*/*/*events_g.mat']); %look for all single units files in the stage

for j = 1:length(day_files)
    day_folder = day_files(j).folder;
    SS_files = dir([day_folder,'/*_SS_*.ntt']); %look for all single units files in the stage
    
    num_neurons = length(SS_files);
    for i = 1:num_neurons
        neuron_filename = SS_files(i).name;
        ss_file = [SS_files(i).folder,'/',neuron_filename];
        
        %Extract data to show neural activity during the day
        idcs   = strfind(ss_file,'/');
        neuron_name = ss_file(idcs(end)+1:end-4);
        stage = ss_file(idcs(end-2)+1:idcs(end-1)-1);
        day = ss_file(idcs(end-1)+1:idcs(end)-1);
        
        
        %Load data and extract meta information
        [behave, st] = load_spikes_and_behavioral_data (ss_file);
        
        [behave_struct.event_times, behave_struct.selected_arms, ...
            behave_struct.rewarded_arm1, behave_struct.rewarded_arm2, behave_struct.selected_np] = extract_event_times(behave);

		% Correction of the ITI - make it a second before.
        % behave_struct.event_times(:,1)=behave_struct.event_times(:,1)-1;

        binsize = 100;
        cut_info.ITI = [-0.2,0.6];
        cut_info.NP = [-0.2,0.6];
        cut_info.Ain = [-0.2,0.6];
        cut_info.Bin = [-0.2,0.6];
        cut_info.Aout = [-0.2,0.6];
        cut_info.All = [-0.2,0.6];

        [nspikes ,blmn, blstd, Labels, ITIRaster, AinRaster,AoutRaster, BinRaster, NPRaster, AllRaster] = ...
            makeRasterData(behave_struct, st, binsize, cut_info);
        
         rep_factor = 10;
         dataCelllArr = [{'ITI'}, {repmat(ITIRaster,rep_factor,1)};
                {'NP'}, {repmat(NPRaster,rep_factor,1)};
                {'Ain'}, {repmat(AinRaster,rep_factor,1)};
                {'Aout'}, {repmat(AoutRaster,rep_factor,1)};
                {'Bin'}, {repmat(BinRaster,rep_factor,1)}
                %{'All'}, {AllRaster}
                ];
           
            for field = fieldnames(Labels)'
                Labels.(field{:}) = repmat(Labels.(field{:}),rep_factor,1);
           end
            
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
