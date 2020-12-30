function [ psth_mean, psth_std, psth_sem ] = binedRasterToPSTH( raster_binned )
%BINEDRASTERTOPSTH calculates the PSTH from the binned raster.
%   Detailed explanation goes here

win = gausswin(3)/sum(gausswin(3));

% psth_mean = filtfilt(win,1,mean(raster_binned,1));
% psth_std = filtfilt(win,1,std(raster_binned, 0, 1));
% psth_sem = psth_std./sqrt(size(raster_binned,1));

psth_mean = filter2(win,mean(raster_binned,1));
psth_std = filter2(win,std(raster_binned, 0, 1));
psth_sem = psth_std./sqrt(size(raster_binned,1));

end

