function s=calculate_prob(p, n, m)
% Calculate the probability of at least one run with m cosecutive successes
% in n trials.
s=0;
for j=1:floor((n+1)/(m+1))
    q=1-p;
    a=p*nchoosek(n-j*m,j-1)+nchoosek(n-j*m+1,j)*q;
    b=nchoosek(n-j*m,j-1);
    
    s=s+(-1)^(j+1)*a*b*p^(j*m)*q^(j-1);
end
end



