function [gc] = betweenness_based_gc(G)
% Input:  A, Adjancency Matrix
% Output: gc: Betweenness based graph centrality
% Author: Yash Mahajan
% Reference: L. C. Freeman, “Centrality  in  social  networks concep-tual clarification,”
% Social Networks, vol. 1, pp. 215–239,1978

%Betweenness centrality for each nodes 

betweenness = centrality(G, 'betweenness');
n = length(betweenness);

%Maximum betweenness centrality
max_bet = max(betweenness);
%Mean difference 
betweenness = max_bet - betweenness;
gc = sum(betweenness);

%Normalized 
gc = gc ./ (power(n,3) - 4*power(n,2) + 5*n - 2);
