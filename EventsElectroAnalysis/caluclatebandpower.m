function band_power = caluclatebandpower( S_event,band_min_index, band_max_index)
%CALUCLATEBANDPOWER Summary of this function goes here
%   Detailed explanation goes here

band_power =  sum(sum(S_event(:, band_min_index:band_max_index)));

end

