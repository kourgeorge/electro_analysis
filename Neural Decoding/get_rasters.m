function cells = get_rasters(raster_folder,event,stage)
%GET_RASTERS Summary of this function goes here
%   Detailed explanation goes here

raster_cells_data = dir([fullfile(raster_folder,event), '/*.mat']);

cells = [];

for cell_raster_file = fliplr(raster_cells_data')
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
    
    if strcmp(cell_data.raster_site_info.stage, stage)
        cells = [cells; cell_data];
    end
end

