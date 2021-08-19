function test_snr()
addpath('/Users/gkour/drive/PhD/events_analysis/Neural Decoding')

%test_basic_transfer()
test_SNT_T_reduces_to_SNR()

%test_congruent();


end


function test_basic_transfer()

    cov = [4, 0; 0, 1];
    
    samples_m1 = mvnrnd([0 ,5],cov,200);
    samples_m2 = mvnrnd([0 ,5],cov,200);
    samples_m3 = mvnrnd([15 ,0],cov,200);

    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    scatter(samples_m3(:,1),samples_m3(:,2))
    axis equal;
    hold off;
    
    [geom1.centroid, geom1.R2, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.R2, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2); 
    [geom3.centroid, geom3.R2, geom3.D, geom3.U, geom3.Ri, geom3.N] = extract_geometry(samples_m3);
    
    
    [~,error_c] = SNR_T(geom1, geom2, geom3);
    arrayfun(error_c, 1:20)
            
end

function test_SNT_T_reduces_to_SNR()
    cov = [4, 0; 0, 1];
    
    samples_m1 = mvnrnd([0 ,0],cov,200);
    samples_m2 = mvnrnd([8 ,0],cov,200);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    hold off;
    
    
    [geom1.centroid, geom1.R2, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.R2, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2); 
    
    [~,error_snr] = SNR(geom1, geom2);
    snr_error_res = arrayfun(error_snr, 1:20);
    
    [~,error_snrT] = SNR_T(geom1, geom2, geom1);
    snrT_error_res = arrayfun(error_snrT, 1:20);
    
    assert(all(snr_error_res==snrT_error_res))
    
end

function test_overlapping_geometries()
    
    cov = [1, 0; 0, 4];
    samples_m1 = mvnrnd([0 ,0],cov,200);
    samples_m2 = mvnrnd([2 ,0],cov,200);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    hold off;
    
    [geom1.centroid, geom1.R2, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.R2, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


    [snr,error_a] = SNR(geom1, geom2);
    arrayfun(error_a, 1:20)
end

function test_biased_geometries()
    
    cov = [1, 0; 0, 4];
    samples_m1 = mvnrnd([0 ,0],cov,200);
    samples_m2 = mvnrnd([4 ,0],2*cov,200);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    hold off;
    
    [geom1.centroid, geom1.R2, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.R2, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


    [snr,error_a] = SNR(geom1, geom2);
    arrayfun(error_a, 1:20)
    
    [snr,error_b] = SNR(geom2, geom1);
    arrayfun(error_b, 1:20)
    
end

