function KC = katz(G_graph, a, b)
% Katz centrality metric
% 
% Inputer: G_graph, undirected graph
%           a: alpha (choose 0.2 in test)
%           b: beta: extra credit to all edges (choose 1 in test)
% Output: Katz centrality value for each nodes
% Author: Zelin Wan
% Reference: L. Katz, “A new status index derived from sociometric analysis,” Psychometrika, vol. 18, no. 1, pp. 39–43, Mar. 1953.
%           Networks: An Introduction. New York, NY, USA: Oxford University Press, Inc., 2010.

graph_matrix = full(adjacency(G_graph));

graph_matrix_A = graph_matrix.*a + b;
% disp(graph_matrix);
% disp(graph_matrix_A);
G_graph_A = graph(graph_matrix_A);

KC = centrality(G_graph_A, 'eigenvector', 'Importance',G_graph_A.Edges.Weight);

end