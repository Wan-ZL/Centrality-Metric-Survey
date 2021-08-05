function information = information_centrality(A)

% This function calculates information centrality on an unweighted/weighted
% network.
%
% Inputs:                            A = an unweighted/weighted
%                                           adjacency matrix
% Output:                            information = a vector of each nodes
%                                           information centrality

n = length(A);
D = diag(sum(A,2));

L = D-A;
J = ones(n);

C = inv(L + J + eye(n)*1e-3);
Cdiag = diag(C);
T = sum(Cdiag);
RR = sum(C,2);
information = (Cdiag(1:n) + (T - 2*RR(1:n))./n).^-1;

end