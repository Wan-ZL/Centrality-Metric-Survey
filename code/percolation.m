function PC = percolation(graph, percolation_value)
%   Input:  graph: undirected graph
%           percolation_value: percolation for each node （original value 
%           for all nodes are zero, if one node remove, the neighbor of this
%           node (both in-neighbor and out-neighbor) become one
% 
%   Output: PC: Percolation centrality
%   
%   Author: Zelin Wan
% 
%   Reference:  M. Piraveenan, M. Prokopenko, and L. Hossain, 
%               “Per- colation centrality: Quantifying graph-theoretic 
%               impact of nodes during percolation in networks,” PLOS ONE, vol. 8, no. 1, 2013.
%               
%   change parfor to for if don't want to use parallel

nodes_number = numnodes(graph);
PC_matrix = zeros(nodes_number,nodes_number);

parfor index_s = 1:nodes_number
    if percolation_value(index_s) == 0
        continue;
    end

    TR = shortestpathtree(graph, index_s);
    
    for index_v = 1:nodes_number
        if index_s == index_v
            continue;
        end
        
        PC_matrix(index_v,index_s) = PC_matrix(index_v,index_s) + find_all_succ(TR, successors(TR, index_v));
    end

end
    
PC = sum(PC_matrix, 2);


end

function all_succ_number = find_all_succ(G, succ_array)
all_succ_number = 0;

if isempty(succ_array)
%     disp('empty');
    return;
end


for index=1:length(succ_array)
    all_succ_number = all_succ_number + find_all_succ(G, successors(G, succ_array(index))) + 1;
end
% disp(all_succ_number);
return;

end