function drawAllCellResponse(raster_folder, event, combination_labels)
%DRAWCELLRESPONSE This script draws PSTH and rasters of neural activity
% given the raster data provided by the create raster function. It goas over
% all cells and draws the rasters and psth for a given time event and given
% filters it shows this information for each label value (or combination of labels.)
% Usage: 
%  No Fiter:    drawCellResponse('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters2', 'NP', [])
%  With Filter: drawCellResponse('C:\Users\GEORGEKOUR\Desktop\Electro_Rats\Rasters2', 'NP', [{'ArmType'},{'Rewarded'}])


raster_cells_data = dir([fullfile(raster_folder, event), '\*.mat']);


for cell_raster_file = fliplr(raster_cells_data')
    if ~contains( cell_raster_file.name , 'odor1_WR_rat10_mpfc_14.10_TT1_SS_1.mat')
        continue
    end
        
    cell_data = load(fullfile(cell_raster_file.folder,cell_raster_file.name));
    
    drawCellResponse(cell_data, combination_labels)
    
    if sum(sum(cell_data.raster_data.Raster))<500
        continue;
    end
    

end
end