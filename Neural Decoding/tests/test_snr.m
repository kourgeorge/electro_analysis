function test_snr()
addpath('/Users/gkour/drive/PhD/events_analysis/Neural Decoding')
close all

test_theory_empirical_results_given_geometry(5)
test_theory_empirical_results_estimated_geometry(3)
test_distant_geometries_orthogonal_vs_parallel()
test_overlapping_geometries()
test_biased_geometries()

end


function test_theory_empirical_results_given_geometry(m)
repetitions = 2000;
P = 1000;

% define the covariance matrices
    cov = [1, 0; 0, 4];
    centroid1 = [0 ,0];
    centroid2 = [4 ,0];

% sample from the distribution
    samples_m1 = mvnrnd(centroid1,cov,P);
    samples_m2 = mvnrnd(centroid2,cov,P);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    axis equal
    hold off;

        
% estimate the theory error rate for given m

    %assume geometry is given.
    geom1.N = P;
    geom1.centroid = centroid1;
    [geom1.U,geom1.Ri] = eig(cov);
    geom1.Ri = sqrt(diag(geom1.Ri));
    geom1.D = sum(geom1.Ri.^2)^2 / sum(geom1.Ri.^4);
    
    geom2 = geom1;
    geom2.centroid = centroid2;
    
    [~,eps] = SNR(geom1, geom2);
    err_theory = eps(m)
     
% perform emprical estimation
    

% Monte carlo over repetitions
    % sample m samples for training a prototype classifier
    % calculate the error rate on a test set of the prototype.
    for rep=1:repetitions
        
        s1 = shuffle(samples_m1);
        s1 = s1(1:m,:);
        s2 = shuffle(samples_m2);
        s2 = s2(1:m,:);
        
        s1_test_samples = mvnrnd([0 ,0],cov,1000);
        classification = prototype_classifier(s1, s2, s1_test_samples);
        
        error_a(rep) = mean(classification==2);
        
    end
    err_emp = mean(error_a)
    deviation = abs(err_emp-err_theory)/err_emp
    assert(deviation<0.2)
end


function test_theory_empirical_results_estimated_geometry(m)
repetitions = 200;
P = 1000;

% define the covariance matrices
    cov = [1, 0; 0, 4];
    centroid1 = [0 ,0];
    centroid2 = [4 ,0];

% sample from the distribution
    samples_m1 = mvnrnd(centroid1,cov,P);
    samples_m2 = mvnrnd(centroid2,cov,P);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    axis equal
    hold off;

        
% estimate the theory error rate for given m

    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);
    
    
    [~,eps] = SNR(geom1, geom2);
    err_theory = eps(m)
     
% perform emprical estimation
    

% Monte carlo over repetitions
    % sample m samples
    % calculate the error rate on a test set of the prototype.
    for rep=1:repetitions
        
        s1 = shuffle(samples_m1);
        s1 = s1(1:m,:);
        s2 = shuffle(samples_m2);
        s2 = s2(1:m,:);
        
        s1_test_samples = mvnrnd([0 ,0],cov,1000);
        classification = prototype_classifier(s1, s2, s1_test_samples);
        
        error_a(rep) = mean(classification==2);
        
    end
    err_emp = mean(error_a)
    deviation = abs(err_emp-err_theory)/err_emp
    assert(deviation<0.2) %The assestion will seldomly fail.
end


function test_distant_geometries_orthogonal_vs_parallel()
    %%% Test that overlapping geometry has high error than non-overlapping.
    %%% Test 3 configuration with gradual overlapping.
    
    P=1000;
    
    cov1(:,:,1) = [1, 0; 0, 4];
    cov1(:,:,2) = [1, 0; 0, 4];
    cov1(:,:,3) = [4, 0; 0, 1];
    
    cov2 = cov1;
    cov2(:,:,2) = [4, 0; 0, 1];
    
    for i=1:3
        samples_m1 = mvnrnd([0 ,0],cov1(:,:,i),P);
        samples_m2 = mvnrnd([4 ,0],cov2(:,:,i),P);

        figure;
        hold on;
        scatter(samples_m1(:,1),samples_m1(:,2))
        scatter(samples_m2(:,1),samples_m2(:,2))
        axis equal
        hold off;



        [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
        [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


        [snr,error_a] = SNR(geom1, geom2);
        err(i,:) = arrayfun(error_a, 1:20);
        
    end
    assert (all(err(1,:)<err(2,:))& all(err(2,:)<err(3,:)))
end


function test_identical_geometries()
    
    cov = [1, 0; 0, 4];
    samples_m1 = mvnrnd([0 ,0],cov,200);
    samples_m2 = mvnrnd([0 ,0],cov,200);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    hold off;
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


    [snr,error_a] = SNR(geom1, geom2);
    arrayfun(error_a, 1:20)
    
    % assert that the error equals to 0.5 even for very large m.
    assert(abs(error_a(100)-0.5)<0.01)
end

function test_overlapping_geometries()
    
    cov = [1, 0; 0, 4];
    samples_m1 = mvnrnd([0 ,0],cov,2000);
    samples_m2 = mvnrnd([1 ,0],cov,2000);
    
    figure;
    hold on;
    scatter(samples_m1(:,1),samples_m1(:,2))
    scatter(samples_m2(:,1),samples_m2(:,2))
    hold off;
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


    [snr,error_a] = SNR(geom1, geom2);
    arrayfun(error_a, 1:20)
    
    % assert that the error >  0.5 even for very large m.
    assert(error_a(10000)>0.3)
end

function test_biased_geometries()
    %%% Test that the bias has an effect, i.e. the smaller the radii the smaller is the error.
    %%% from the paper: when manifold a is larger than manifold b, the bias term is negative, predicting a lower SNR for manifold a.%%%
    cov = [1, 0; 0, 4];
    samples_m1 = mvnrnd([0 ,0],cov,200);
    samples_m2 = mvnrnd([4 ,0],2*cov,200);
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(samples_m2);


    [snr,eps] = SNR(geom1, geom2);
    err_a=arrayfun(eps, 1:20);
    
    [snr,eps] = SNR(geom2, geom1);
    err_b=arrayfun(eps, 1:20);
    
    assert(all(err_a<err_b))
    
end


function test_eq_si34()

    cov = [1, 0; 0, 4];
    centroid1 = [0,4];
    centroid2 = [0,0];
    Ri_c = flipud(sqrt(diag(cov)*P));
    geom1.U = [0,1;1,0]; 
    
    
end

%HELPER FUNCIONS

function shuffled = shuffle(arr)

    shuffled = arr(randperm(length(arr)),:);

end

function classification = prototype_classifier(samples1, samples2, test)

    prot1= mean(samples1);
    prot2 = mean(samples2);
    
    for i=1:size(test,1)
        dist_prot1 = norm(test(i,:)-prot1);
        dist_prot2 = norm(test(i,:)-prot2);
        classification(i)=(dist_prot1>dist_prot2) + 1;
    end
    
end

