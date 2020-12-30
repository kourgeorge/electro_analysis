function checkRatersSpikeNums()

global PROJECTS_DIR

stages = {'odor1','odor2_WR','odor2_XFR'};
events = {'ITI','NP','Ain','Bin','Aout'};
raster_folder = fullfile(PROJECTS_DIR, 'plusMazeMotivationExpt','Rasters');
for s = 1:length(stages)
    stage = stages{s};
    for e = 1:length(events)
        num_spikes = [];
        raster_cells_data = dir([fullfile(raster_folder, events{e}), filesep,'*.mat']);
        for cell_raster_file = fliplr(raster_cells_data')
            if ~contains(cell_raster_file.name,stage)
                continue
            end
            cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
            num_spikes = [num_spikes sum(sum(cell_data.raster_data.Raster))];
            clear cell_data
        end
        figure;
        histogram(num_spikes,linspace(0,1000,100),'normalization','cdf','DisplayStyle','stairs');
        title([stages{s},' ',events{e}]);
    end
end
end
