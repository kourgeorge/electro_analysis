function test_snr_T()

close all
test_basic_transfer()
test_c_in_middle()
test_compare_leaning_transfer()
test_SNR_T_reduces_to_SNR_a_b_equal()
test_SNR_T_reduces_to_SNR()

end


function test_basic_transfer()

    cov = [4, 0; 0, 1];
    
    samples_m1 = mvnrnd([0 ,5],cov,2000);
    samples_m2 = mvnrnd([10 ,5],cov,2000);
    samples_m3 = mvnrnd([0 ,0],cov,2000);

    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    scatter(samples_m3(:,1),samples_m3(:,2))
    axis equal;
    hold off;
    
    geom1 = extract_geometry(samples_m1);
    geom2 = extract_geometry(samples_m2); 
    geom3 = extract_geometry(samples_m3);
    
    
    snr_t = SNR_T(geom1, geom2, geom3);
    arrayfun(snr_t.snr, 1:20)
    arrayfun(snr_t.error, 1:20)
    
    assert (snr_t.error(1)<0.05)
    
            
end


function test_c_in_middle()

    cov = [4, 0; 0, 1];
    P=1000;
    centroid1 = [0 ,5];
    centroid2 = [10 ,5];
    centroid3 = [5 ,0];
    samples_m1 = mvnrnd(centroid1,cov,P);
    samples_m2 = mvnrnd(centroid2,cov,P);
    samples_m3 = mvnrnd(centroid3,cov,P);

    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    scatter(samples_m3(:,1),samples_m3(:,2))
    axis equal;
    hold off;
    
    geom1.N = P;
    geom1.centroid = centroid1;
    geom1.Ri = flipud(sqrt(diag(cov)*P));
    geom1.D = sum(geom1.Ri.^2)^2 / sum(geom1.Ri.^4);
    geom1.U = [0,1;1,0]; 
    
    geom2 = geom1;
    geom2.centroid = centroid2;
    geom3 = geom1;
    geom3.centroid = centroid3;
    
    
    snr= SNR_T(geom1, geom2, geom3);
    assert(abs(snr.error(100)-0.5)<0.001)
    
            
end

function test_compare_leaning_transfer()

    cov = [4, 0; 0, 1];
    P=2000;
    
    samples_m1 = mvnrnd([0 ,5],cov,P);
    samples_m2 = mvnrnd([10 ,5],cov,P);
    samples_m2_leaning = mvnrnd([10 ,5],[4,2;2,4],P);
    samples_m3 = mvnrnd([3 ,0],cov,P);

    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2_leaning(:,1),samples_m2_leaning(:,2))
    scatter(samples_m3(:,1),samples_m3(:,2))
    axis equal;
    hold off;
    
    geom1= extract_geometry(samples_m1);
    geom2 = extract_geometry(samples_m2);
    geom2_l = extract_geometry(samples_m2_leaning);
    geom3 = extract_geometry(samples_m3);
    
    
    snr = SNR_T(geom1, geom2, geom3);
    a = arrayfun(snr.error, 1:20);
    snr = SNR_T(geom1, geom2_l, geom3);
    b = arrayfun(snr.error, 1:20);
    
    assert(all(a<b))
    
            
end


function test_SNR_T_reduces_to_SNR_a_b_equal()
    cov = [4, 0; 0, 1];
    P = 1000;
    samples_m1 = mvnrnd([0 ,0],cov,P);
    samples_m2 = mvnrnd([4 ,0],cov,P);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    axis equal;
    hold off;
    
    
    geom1 = extract_geometry(samples_m1);
    geom2 = extract_geometry(samples_m2); 
    
    snr = SNR(geom1, geom2);
    snr_error_res = arrayfun(snr.error, 1:10)
    
    snrT = SNR_T(geom1, geom2, geom1);
    snrT_error_res = arrayfun(snrT.error, 1:10)
    
    assert(all(abs(snr_error_res-snrT_error_res)<0.0001))
    
end

function test_SNR_T_reduces_to_SNR()
    cov1 = [4, 0; 0, 1];
    cov2 = [4, 2; 2, 4];
    P = 1000;
    samples_m1 = mvnrnd([0 ,0],cov1,P);
    samples_m2 = mvnrnd([4 ,0],cov2,P);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    axis equal;
    hold off;
    
    
    geom1 = extract_geometry(samples_m1);
    geom2 = extract_geometry(samples_m2); 
    
    snr = SNR(geom1, geom2);
    snr_error_res = arrayfun(snr.error, 1:10)
    
    snrT = SNR_T(geom1, geom2, geom1);
    snrT_error_res = arrayfun(snrT.error, 1:10)
    
    assert(all(abs(snr_error_res-snrT_error_res)<0.0001))
    
end

