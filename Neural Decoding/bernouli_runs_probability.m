function prob = bernouli_runs_probability(p, n, r)
%Calculates the probability of at least one run with m cosecutive successes
%in n bernouli trials with sucess probability p.
%   Following the paper: 
z_n = beta (n,r,p)-p^r*beta (n-r,r,p);
prob=1-z_n;
end


function b = beta (n,r,p)
q=1-p;
b=0;
for l=0:floor(n/(r+1))
    b=b + (-1)^l*nchoosek(n-l*r,l)*(q*p^r)^l;
end
end