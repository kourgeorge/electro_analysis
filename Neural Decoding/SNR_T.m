function [snr,error_T] = SNR_T(geomA, geomB, geomC)
%SNR_T Summary of this function goes here
%   Detailed explanation goes here
delta_BC = (geomC.centroid-geomB.centroid)';
delta_AC = (geomC.centroid-geomA.centroid)';
delta_BA = (geomB.centroid-geomA.centroid)';

signal = norm(delta_BC)^2 - norm(delta_AC)^2;

bias = geomB.R2-geomA.R2;

noise_B_along_BC = (norm(geomB.U*delta_BC))^2;
noise_A_along_AC = (norm(geomA.U*delta_AC))^2;
noise_C_along_AB = (norm(geomC.U*delta_BA))^2;

snr = @(m) 0.5*(signal+bias/m)/sqrt(noise_B_along_BC/m + noise_A_along_AC/m + noise_C_along_AB);
error_T = @(m) 1-normcdf(snr(m));

end

