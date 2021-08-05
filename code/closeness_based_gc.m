function [gc] = closeness_based_gc(G)
% Input:  A, Adjancency Matrix
% Output: gc: Closeness based graph centrality
% Author: Yash Mahajan
% Reference: L. C. Freeman, S. P. Borgatti, and D. R. White,
% “Centrality in valued graphs: A measure of betweennessbased on network flow,”
% Social Networks, vol. 13, no. 2,pp. 141–154, 1991


%Closeness centrality for each node in the graph G
cc = centrality(G, 'closeness');
n = length(cc);

%Normalized centrality scores
cc = cc * (n-1);
max_cc = max(cc);

%Mean difference
cc = max_cc - cc;
gc = sum(cc);

%Normalized closeness based graph centrality
denom = (power(n,2) - 3*n + 2) / (2*n - 3);
gc = gc / denom;
