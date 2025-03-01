function Q = LinspaceVect(Qi,Qf,NN)

% Qi - start vector
% Qf - end vector
% N - num of samples
Q = zeros(numel(Qi),NN);

for n = 1:numel(Qi)
    Q(n,:) = linspace(Qi(n),Qf(n),NN);
end