function [centroid, D, V, Ri, N] = extract_geometry(X)
%EXTRACT_GEOMETRY Summary of this function goes here
%   Detailed explanation goes here

[N, dim] = size(X); 

centroid = mean(X);

% [V_cov,lambda,U_cov] = svd(cov(X-centroid));
% [V_data,s,U_data] = svd(X-centroid);
% lambda = diag(lambda);
% s = diag(s);
% lambda_exp = s.^2/N 

[U,S,V] = svd(X-centroid);
[eigvec,eigval] = eig(cov(X-centroid));
eigval_exp = diag(S).^2/N;
%all((diag(eigval)-eigval_exp)<0.001)
%the eigen vectors are in the columns.

Ri = zeros(dim,1);
Ri(1:length(diag(S))) = diag(S);

%lambda_i = Ri.^2/N;


D = sum(Ri.^2)^2 / sum(Ri.^4);
end