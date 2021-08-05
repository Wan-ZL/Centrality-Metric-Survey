function [gc] = flow_betweenness_gc(G)
% Input:  G, Graph
% Output: gc: Betweenness based graph centrality
% Author: Yash Mahajan
% Reference: L. C. Freeman, “Centrality  in  social  networks concep-tual clarification,”
% Social Networks, vol. 1, pp. 215–239,1978

A = adjacency(G);
flow_bet = flow_betweenness(A);
N = length(flow_bet);
norm_flow_bet = max(flow_bet) - flow_bet;
gc = sum(norm_flow_bet)/(N-1);
