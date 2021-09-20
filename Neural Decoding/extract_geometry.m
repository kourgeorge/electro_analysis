function geom = extract_geometry(X)
%EXTRACT_GEOMETRY Summary of this function goes here
%   Detailed explanation goes here

[N, dim] = size(X);

centroid = mean(X);

%[V_cov,lambda,U_cov] = svd(cov(X-centroid));
%[V_data,s,U_data] = svd(X-centroid);
%lambda = diag(lambda);
%s = diag(s);
% lambda_exp = s.^2/N 

[~,S,V] = svd(X-centroid);
[eigvec,eigval] = eig(cov(X-centroid));
eigval_exp = diag(S).^2/N;


%test
% C = 1/N * X'*X -  centroid*centroid';
% [myU,myS,myV] = svd(C);

%assert(all((diag(eigval)-flipud(eigval_exp))<0.01))
%This assersion should work for large N, but for small N it seems that the
%eig(cov(X-centroid)) becomes less accurate that the SVD and thus deviate
%from it.
%the eigen vectors are in the columns.

Ri = zeros(dim,1);
Ri(1:length(diag(S))) = diag(S)/sqrt(N);

%lambda_i = Ri.^2/N;


D = sum(Ri.^2)^2 / sum(Ri.^4);

geom.centroid=centroid;
geom.D=D;
geom.U = V;
geom.Ri = Ri;
geom.N=N;

end