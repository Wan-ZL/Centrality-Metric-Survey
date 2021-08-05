function CCC = clustering_coef(G_graph)
% Input: G_graph: Undirected graph
% 
% Output: CCC: clustering coefficient centrality for all nodes
% 
% Author: Zelin Wan
% Reference: Watts, D. J., & Strogatz, S. H. (1998). Collective dynamics of ‘small-world’networks. nature, 393(6684), 440.
%            https://www.geeksforgeeks.org/clustering-coefficient-graph-theory/

graph_matrix = full(adjacency(G_graph));
% ignore weight
graph_matrix(graph_matrix>1) = 1;

node_size = numnodes(G_graph);

for i = 1:node_size
    i_line = graph_matrix(i,:);
    i_neigh = find(i_line);

    lambda_sum = 0;
    for neigh_id = i_neigh
        lambda_sum = lambda_sum+sum(graph_matrix(neigh_id,:).*i_line);
    end
    lambda_sum = lambda_sum/2;
    k_i = sum(graph_matrix(i,:));
    T_i = k_i*(k_i-1)/2;
    CCC(i) = lambda_sum/T_i;
end

% disp(graph_matrix(1,:));
% disp(graph_matrix.*graph_matrix);






end