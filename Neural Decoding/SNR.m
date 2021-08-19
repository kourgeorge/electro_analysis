function [snr, error_a] = SNR(geomA, geomB)
%SNR Summary of this function goes here
%   Detailed explanation goes here
delta_x = (geomA.centroid-geomB.centroid)';

signal = norm(delta_x)/sqrt(geomA.R2/geomA.N);

signal_direction = delta_x/norm(delta_x);
bias = geomB.R2 / geomA.R2 - 1;

signal_noise_overlapA = sum((geomA.U* signal_direction) .^ 2 .* geomA.Ri .^ 2) / geomA.R2;
signal_noise_overlapB = sum((geomB.U* signal_direction) .^ 2 .* geomB.Ri .^ 2) / geomA.R2;

dim = geomA.D ^ -1;

snr = @(m) 0.5*(signal^2+bias/m)/(sqrt(dim/m + signal_noise_overlapA+signal_noise_overlapB/m));
error_a = @(m) 1-normcdf(snr(m));
end
