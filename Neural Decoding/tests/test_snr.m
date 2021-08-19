function test_snr()
addpath('/Users/gkour/drive/PhD/events_analysis/Neural Decoding')

test_distant_geometries_orthogonal_vs_parallel()
%test_overlapping_geometries()
%test_biased_geometries()

end


function test_distant_geometries_orthogonal_vs_parallel()
    
    cov(:,:,1) = [4, 0; 0, 1];
    cov(:,:,2) = [1, 0; 0, 4];
    
    for i=1:2
        samples_m1 = mvnrnd([0 ,0],cov(:,:,i),200);
        samples_m2 = mvnrnd([4 ,0],cov(:,:,i),200);

        figure;
        hold on;
        scatter(samples_m1(:,1),samples_m1(:,2))
        scatter(samples_m2(:,1),samples_m2(:,2))
        axis equal
        hold off;



        [geom1.centroid, geom1.R2, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
        [geom2.centroid, geom2.R2, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


        [snr,error_a] = SNR(geom1, geom2);
        arrayfun(error_a, 1:20)
    end
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

