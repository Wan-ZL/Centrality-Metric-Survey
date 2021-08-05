function Cci = collective_influence_old(A, l)

%COLLECTIVE_INFLUENCE
%           Collective influence algorithm
%           Cci = collective_influence(A), where A is an adjacency matrix,
%           l is a parameter to determine the range of group from each node,
%           computes CI value for each node in A
%           (l = 5 in test)

%           Author: Beom Woo Kang
%           Date: Aug 2, 2019

%           Reference:
%           F. Morone and H. A. Makse,
%           Influence maximization incomplex networks through optimal percolation,
%           Nature,vol. 524, no. 7563, pp. 65�68, 2015.

n = length(A);
Cci = zeros(n,1);

%find distances between each node
G = graph(A);
D = distances(G);

parfor i = 1:n
    ki = length(find(A(i,:)));      %degree of node i
    sum = 0;
    Bi = find(D(i,:) <= l);       %nodes within distance of l from node i
    for j = 1:length(Bi)
        kj = length(find(A(Bi(j),:)));
        sum = sum + kj - 1;
    end
    Cci(i) = (ki-1)*sum;    
end

% cmax = max(Cci);
% Cci = Cci./cmax;