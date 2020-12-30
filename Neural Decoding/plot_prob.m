n=10;
r=1;
x = 0:0.001:1;
y = [];
for p=x
    y=[y,caculate_bernouli_runs_prob(p, n, r)];
end

plot(x,y)