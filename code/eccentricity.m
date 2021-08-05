function Ce = eccentricity(A)

%ECCENTRICITY   Eccentricity centrality metric
%               Ce = eccentricity(A), where A is an adjacency matrix,
%               computes eccentricity for each node in A

%               Author: Beom Woo Kang
%               Date: Aug 2, 2019

%               Reference:
%               P. Hage and F. Harary,
%               “Eccentricity and centrality in networks”,
%               Social Networks, vol.17, no.1, pp.57 – 63,1995.

n = length(A);
Ce = zeros(n,1);

%compute distances among networks
G = graph(A);
D = distances(G);

%mark distance between removed node as -1
infi = D == Inf;
D(infi) = -1;

for i = 1:n
    Ce(i) = 1/(max(D(i,:)));
    if Ce(i) == Inf
        Ce(i) = 0;
    end
end