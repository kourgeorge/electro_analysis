function test_snr()
addpath('/Users/gkour/drive/PhD/events_analysis/Neural Decoding')

close all
test_basic_transfer()
test_compare_leaning_transfer()
test_SNR_T_reduces_to_SNR()

end


function test_basic_transfer()

    cov = [4, 0; 0, 1];
    
    samples_m1 = mvnrnd([0 ,5],cov,200);
    samples_m2 = mvnrnd([10 ,5],cov,200);
    samples_m3 = mvnrnd([3 ,0],cov,200);

    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    scatter(samples_m3(:,1),samples_m3(:,2))
    axis equal;
    hold off;
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2); 
    [geom3.centroid, geom3.D, geom3.U, geom3.Ri, geom3.N] = extract_geometry(samples_m3);
    
    
    [~,error_c] = SNR_T(geom1, geom2, geom3);
    arrayfun(error_c, 1:20)
            
end

function test_compare_leaning_transfer()

    cov = [4, 0; 0, 1];
    
    samples_m1 = mvnrnd([0 ,5],cov,200);
    samples_m2 = mvnrnd([10 ,5],cov,200);
    samples_m2_leaning = mvnrnd([10 ,5],[4,2;2,4],200);
    samples_m3 = mvnrnd([3 ,0],cov,200);

    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2_leaning(:,1),samples_m2_leaning(:,2))
    scatter(samples_m3(:,1),samples_m3(:,2))
    axis equal;
    hold off;
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);
    [geom2_l.centroid, geom2_l.D, geom2_l.U, geom2_l.Ri, geom2_l.N] = extract_geometry(samples_m2_leaning);
    [geom3.centroid, geom3.D, geom3.U, geom3.Ri, geom3.N] = extract_geometry(samples_m3);
    
    
    [~,error_c] = SNR_T(geom1, geom2, geom3);
    a = arrayfun(error_c, 1:20);
    [~,error_c] = SNR_T(geom1, geom2_l, geom3);
    b = arrayfun(error_c, 1:20);
    
    assert(all(a<b))
    
            
end


function test_SNR_T_reduces_to_SNR()
    cov = [4, 0; 0, 1];
    
    samples_m1 = mvnrnd([0 ,0],cov,200);
    samples_m2 = mvnrnd([4 ,0],cov,200);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    axis equal;
    hold off;
    
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2); 
    
    [~,error_snr] = SNR(geom1, geom2);
    snr_error_res = arrayfun(error_snr, 1:20)
    
    [~,error_snrT] = SNR_T(geom1, geom2, geom1);
    snrT_error_res = arrayfun(error_snrT, 1:20)
    
    assert(all(abs(snr_error_res-snrT_error_res)<0.0001))
    
end

