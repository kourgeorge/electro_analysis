function test_extract_geometry()
%TEST_EXTRACT_GEOMETRY Summary of this function goes here
%   Detailed explanation goes here
close all
test_exact_lambda_estimated_Ri()
test_estimated_lambda_estimated_Ri()
end


function test_exact_lambda_estimated_Ri()
%compare lambda (extracted from the covariance) and estimated geometry R_i.
%based on the relashionship that Ri^2=lambda.
P = 1000;
repetitions = 20;
dim = 100;
for rep=1:repetitions
    
    temp = rand(dim);
    cov = temp*temp.';
    %cov = [1, 0; 0, 4];
    centroid = rand(1,dim);
    
    samples_m1 = mvnrnd(centroid,cov,P);
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(samples_m1);
    
    lambda = eig(cov);
    Ri = sqrt(lambda);
    
    [geom1.Ri, flipud(Ri), abs(geom1.Ri-flipud(Ri))]
    assert(isclose(geom1.Ri, flipud(Ri)), 'The Ri are not close enough')
    
end
end

function test_estimated_lambda_estimated_Ri()
%compare lambda (extracted from the covariance) and estimated geometry R_i.
%based on the relashionship that Ri^2=lambda.
P = 1000;
repetitions = 20;
dim = 100;
for rep=1:repetitions
    
    temp = rand(dim);
    cov1 = temp*temp.';
    %cov = [1, 0; 0, 4];
    centroid = rand(1,dim);
    
    X = mvnrnd(centroid,cov1,P);
    
    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(X);
    
    lambda = eig(cov(X-centroid));
    Ri = sqrt(lambda);


%     lambda = eig(cov);
%     Ri = sqrt(lambda);
    
    [geom1.Ri, flipud(Ri), abs(geom1.Ri-flipud(Ri))]
    assert(isclose(geom1.Ri, flipud(Ri)), 'The Ri are not close enough')
    
end
end



function res = isclose(a,b)
% is a close to b.
    res = all(abs(a-b)./b<0.2);
end