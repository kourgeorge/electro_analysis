function [snr,error_T] = SNR_T(geomA, geomB, geomC)
%SNR_T Summary of this function goes here
%   Detailed explanation goes here
delta_BC = (geomC.centroid-geomB.centroid);
delta_AC = (geomC.centroid-geomA.centroid);
delta_BA = (geomB.centroid-geomA.centroid);

signal = (norm(delta_BC)^2 - norm(delta_AC)^2)/(sum(geomA.Ri .^ 2)/geomA.N);

bias = sum(geomB.Ri .^ 2) / sum(geomA.Ri .^ 2) - 1;

%(norm((signal_direction*geomA.U) .* geomA.Ri'))^2
noise_B_along_BC = (norm((delta_BC/norm(delta_BC)*geomB.U).*geomB.Ri'))^2/ sum(geomA.Ri .^ 2);
noise_A_along_AC = (norm((delta_AC/norm(delta_AC)*geomA.U).*geomA.Ri'))^2/ sum(geomA.Ri .^ 2);
noise_C_along_AB = (norm((delta_BA/norm(delta_BA)*geomC.U).*geomC.Ri'))^2/ sum(geomA.Ri .^ 2);

if isnan(noise_A_along_AC)
    noise_A_along_AC = 0;
end

css = @(m) (sum(geomA.Ri .^ 2)/geomA.N)^-1*(noise_B_along_BC*norm(delta_BC)^2/m + noise_A_along_AC*norm(delta_AC)^2/m+ noise_C_along_AB * norm(delta_BA)^2);

num_rows = size(geomC.U,1);
Uc = geomC.U .* repmat(geomC.Ri', num_rows,1);
Ub = geomB.U .* repmat(geomB.Ri', num_rows,1);
Ua = geomA.U .* repmat(geomA.Ri', num_rows,1);

% noise_noise_cb reduces to noise_noise and noise_noise_ca reduces to D(A)^-1 in snr
noise_noise_cb = norm(Uc'*Ub ,'fro')^2/sum(geomA.Ri .^ 2)^2;
noise_noise_ca = norm(Uc'*Ua ,'fro')^2/sum(geomA.Ri .^ 2)^2;


snr = @(m) 0.5*(signal+bias/m)/sqrt(css(m) +noise_noise_cb/m + noise_noise_ca/m);
error_T = @(m) 1-normcdf(snr(m));

end


