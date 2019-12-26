function createRasterFiles()
%CREATERASTERFILES Summary of this function goes here
%   Detailed explanation goes here

electro_folder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats';
saveFolder = 'C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Decoding';

%day_files = dir([electro_folder,'\*events_g.mat']); %look for all single units files in the stage
day_files = dir([electro_folder,'\*\*\*\*events_g.mat']); %look for all single units files in the stage

for j = 1:length(day_files)
    day_folder = day_files(j).folder;
    SS_files = dir([day_folder,'\*_SS_*.ntt']); %look for all single units files in the stage
    
    num_neurons = length(SS_files);
    for i = 1:num_neurons
        neuron_filename = SS_files(i).name;
        ss_file = [SS_files(i).folder,'\',neuron_filename];
        
        %extract data to show neural activity during the day
        idcs   = strfind(ss_file,'\');
        neuron_name = ss_file(idcs(end)+1:end-4);
        stage = ss_file(idcs(end-2)+1:idcs(end-1)-1);
        day = ss_file(idcs(end-1)+1:idcs(end)-1);
        
        
        %Load data and extract meta information
        [behave, st] = load_spikes_and_behavioral_data (ss_file);
        
        binsize = 1;
        cutLength = [-1,2];
        [nspikes,blmn,blstd,AinRaster,AinLabels,AoutRaster,AoutLabels,BinRaster,BinLabels] = makeRasterFile(behave,st, binsize,cutLength);
        
        raster_data = AinRaster;
        raster_labels = AinLabels;
        raster_site_info.event = 'Ain';
        raster_site_info.date = day;
        raster_site_info.cell = neuron_name;
        raster_site_info.stage = stage;
        raster_site_info.basemean = blmn;
        raster_site_info.basestd = blstd;
        saveFile = fullfile(saveFolder,'Ain',[stage,'_',day,'_',neuron_name,'.mat']);
        save(saveFile,'raster_data','raster_labels','raster_site_info');

        raster_data = AoutRaster;
        raster_labels = AoutLabels;
        raster_site_info.event = 'Aout';
        raster_site_info.date = day;
        raster_site_info.cell = neuron_name;
        raster_site_info.stage = stage;
        raster_site_info.basemean = blmn;
        raster_site_info.basestd = blstd;
        saveFile = fullfile(saveFolder,'Aout',[stage,'_',day,'_',neuron_name,'.mat']);
        save(saveFile,'raster_data','raster_labels','raster_site_info');
        
        raster_data = BinRaster;
        raster_labels = BinLabels;
        raster_site_info.event = 'Bin';
        raster_site_info.date = day;
        raster_site_info.cell = neuron_name;
        raster_site_info.stage = stage;
        raster_site_info.basemean = blmn;
        raster_site_info.basestd = blstd;
        saveFile = fullfile(saveFolder,'Bin',[stage,'_',day,'_',neuron_name,'.mat']);
        save(saveFile,'raster_data','raster_labels','raster_site_info');
                        
    end
        
end

