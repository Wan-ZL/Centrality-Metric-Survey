function GDSPCC = GDSP_closeness(G_graph, alpha)
%Input:  G_graph, the graph structure generated by Matlab function 'G=digraph()'.
%           graph_matrix: adjacency matrix
%           alpha (alpha = 1.5 in test)
% Output: GDSPCC:  Generalized degree and shortest paths centrality
% Author: Zelin Wan
% Reference: T. Opsahl, F. Agneessens, and J. Skvoretz, “Node centrality in
%               weighted networks: Generalizing degree and shortest paths,”
%               Social networks, vol. 32, no. 3, pp. 245–251, 2010.
%            M. E. Newman, “Scientific collaboration networks. ii. shortest
%               paths, weighted networks, and centrality,” Phys- ical Review
%               E, vol. 64, no. 1, p. 016132, 2001.
% 
%            https://www.mathworks.com/help/matlab/ref/graph.centrality.html
% 
% Note: G_graph must have Weight attribute on Edge. Otherwise, error may occur.


GDSPCC = centrality(G_graph,'closeness','Cost',G_graph.Edges.Weight.^alpha);


end

