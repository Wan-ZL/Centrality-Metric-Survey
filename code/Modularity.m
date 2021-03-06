function M_value = Modularity(G_graph)
% Input:  G_graph, the graph structure generated by Matlab function 'G=digraph()'.
% Output: M_value: Modularity
% Author: Zelin Wan
% Reference: M. Newman, “Mixing patterns in networks,” Physical Review E, 
%               vol. 67, no. 026126, 2003.
%            M. E. J. Newman and M. Girvan, “Finding and evaluat- ing community
%               structure in networks,” Physical Review E, vol. 69, no. 026113, Feb. 2004. 
% delta_value is '1' when two nodes are in the same connected component
node_number = numnodes(G_graph);

edge_number_m = numedges(G_graph);
degree_k = indegree(G_graph) + outdegree(G_graph);

edge_weight_A = adjacency(G_graph, 'weighted');
edge_weight = full(edge_weight_A);
% disp(edge_weight);

weak_bins = conncomp(G_graph,'Type','weak');
M_value = 0;
for index_i = 1:node_number
    for index_j = 1:node_number
        
        if weak_bins(index_i) == weak_bins(index_j)
            delta_value = 1;
            
        else
            delta_value = 0;
        end
        
        M_value = M_value + (edge_weight(index_i, index_j) - degree_k(index_i)*degree_k(index_j)/(2*edge_number_m)) * delta_value;
        
        
    end
    
end

M_value = 1/(2*edge_number_m) * M_value;



end

