rng('default') % for reproducibility
X = randn(100,20);
mu = exp(X(:,[5 10 15])*[.4;.2;.3] + 1);
y = poissrnd(mu);


[B,FitInfo] = lassoglm(X,y,'poisson','CV',10);

lassoPlot(B,FitInfo,'plottype','CV');    
legend('show') % show legend