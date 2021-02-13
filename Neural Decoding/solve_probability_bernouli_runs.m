function s = solve_probability_bernouli_runs(r,n,q_n)
%Q_SOLVER calculating the sucess probability in a single trial when
% the probability of no sequence with r consecutive success in n trials is q_n. 
% s = solve_probability_bernouli_runs(2,6,0.05)

syms p

eqn = bernouli_runs_probability(p, n, r)==q_n;
s = vpasolve(eqn,p, [0 1]);

% fplot([lhs(eqn) rhs(eqn)], [0 1])

end

