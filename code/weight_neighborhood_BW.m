function Cwn = weight_neighborhood_BW(A, ct, a)

%WEIGHT_NEIGHBORHOOD
%           Weight neighborhood centrality metric
%           Cwn = weight_neighborhood(A, ct, a), where A is an adjacency matrix,
%           ct is the benchmark centrality(e.g., degree, betweenness, k-shell, etc.), a is a tuning parameter between
%           1 and 0 to compute diffusion importance,
%           computes weight negiborhood centrality for each node in A.
%           ct = 'degree': degree centrality 
%           ct = 'betweenness': betweenness centrality 
%           ct = 'closeness': closeness centrality
%           benchmark centrality becomes degree by default
%           a = [0,1], becomes 1 by default

%           Author: Beom Woo Kang
%           Date: Aug 2, 2019

%           Reference:
%           J. Wang, X. Hou, K. Li, and Y. Ding, 
%           �A novel weightneighborhood centrality algorithm for identifying
%           influential spreaders in complex networks�,
%           Physica A: Statistical Mechanics and its Applications, vol.475, pp.88�105, 2017.

G = graph(A);
if nargin == 1
    B = centrality(G, 'degree');
    a = 1;
elseif nargin == 2 || nargin == 3
    switch ct
        case 'degree'
            B = centrality(G, 'degree');
        case 'betweenness'
            B = centrality(G, 'betweenness');
        case 'closeness'
            B = centrality(G, 'closeness');
        otherwise
            B = centrality(G, 'degree');
    end
    if nargin == 2
        a = 1;
    end
else
    error('Invalid number of arguments');
end

n = length(A);
Cwn = zeros(n,1);

%compute diffusion importance
W = zeros(n,n);
for i = 1:n
    ki = length(find(A(i,:)));      %degree of node i
    for j = 1:n
        kj = length(find(A(j,:)));  %degree of node j
        W(i,j) = (ki*kj)^a;
    end
end
wavg = mean(W, 'all');          %average diffusion importance

%compute weight neighborhood
for v = 1:n
    sum = 0;
    Nv = find(A(v,:));      %set of neighbors of node v
    for u = 1:length(Nv)
        sum = sum + (W(Nv(u),v)/wavg)*B(Nv(u));
    end
    Cwn(v) = B(v) + sum;
end
