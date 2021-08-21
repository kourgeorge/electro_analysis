function [snr, error_a] = SNR(geomA, geomB)
%SNR Summary of this function goes here
%   Detailed explanation goes here
x_BA = (geomA.centroid-geomB.centroid);

signal_direction = x_BA/norm(x_BA);
signal = norm(x_BA)^2/(sum(geomA.Ri.^2)/geomA.N);


bias = sum(geomB.Ri .^ 2) / sum(geomA.Ri .^ 2) - 1;

costheta_a = geomA.U*signal_direction';
csa= sum(costheta_a.^2 .* geomA.Ri.^2) / sum(geomA.Ri.^2);

costheta_b = geomB.U*signal_direction';
csb= sum(costheta_b.^2 .* geomB.Ri.^2) / sum(geomA.Ri.^2);

signal_noise_overlapA = (norm((signal_direction*geomA.U) .* geomA.Ri'))^2 / sum(geomA.Ri.^2);
signal_noise_overlapB = (norm((signal_direction*geomB.U) .* geomB.Ri'))^2 / sum(geomA.Ri.^2);

css = @(m) (signal_noise_overlapA+signal_noise_overlapB/m)*signal;


dim = geomA.D ^ -1;

cosphi = geomA.Ri * geomB.Ri';
ss = sum((cosphi .^ 2 * geomA.Ri.^2)' * geomB.Ri.^2) / sum(geomA.Ri.^2)^2;

num_rows = size(geomA.U,1);
Ub = geomB.U .* repmat(geomB.Ri', num_rows,1);
Ua = geomA.U .* repmat(geomA.Ri', num_rows,1);

noise_noise = norm(Ub'*Ua ,'fro')^2/sum(geomA.Ri .^ 2)^2;

snr = @(m) 0.5*(signal+bias/m)/(sqrt(dim/m + css(m)+noise_noise/m));
error_a = @(m) 1-normcdf(snr(m));


end
