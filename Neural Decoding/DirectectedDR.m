function mappedX = DirectectedDR(X, signal, dim)
%DIRECTECTEDDR Summary of this function goes here
%   Detailed explanation goes here

v = signal;
v = v/norm(v);

yz=null(v);

%perform PCA on the null space.
[mappedX, mapping] = pca(X*yz, dim-1);

mappedX = [X*v',mappedX];

end

