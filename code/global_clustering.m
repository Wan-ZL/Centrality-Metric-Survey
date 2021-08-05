function [gcc] = global_clustering(G)
% Input:  A, Adjancency Matrix
% Output: gcc: Global clustering coefficient 
% Author: Yash Mahajan
% Reference: D.  J.  Watts  and  S.  Strogatz,  
% �Collective  dynamics  of�small-world� networks,�
% Nature, vol. 393, no. 6684, pp.440�442, June 1998.

%converting the graph to adjancency matrix
% A = adjacency(G);

%getting the local clustering coefficient of all nodes
gcc = clustering_coef(G);
n = length(gcc);
gcc(isnan(gcc)) = 0;
%normalised sum of lcc of all nodes 
gcc = sum(gcc);
gcc = gcc / n;