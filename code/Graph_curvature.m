function GC_value = Graph_curvature(G_graph)
% Each function call, new i,j,k pick randomly
% nodes i j k must in the same connected component
% 
% Input: G_graph: undirected graph
% Output: GC_value: Graph curvature
% Author: Zelin Wan
% Reference: O. Narayan and I. Saniee, “Large-scale curvature of networks,”
%               Physical Review E, vol. 84, no. 6, p. 066108, 2011

node_number = numnodes(G_graph);
disp(['node number', int2str(node_number)]);

if node_number <= 3
    GC_value = 0;
    return;
end

% get largest connected component
[bin, binsize] = conncomp(G_graph);
idx = binsize(bin) == max(binsize);
G_largest_component = subgraph(G_graph, idx);

larg_comp_node_number = numnodes(G_largest_component);
max_i = 1;
max_j = 1;
max_k = 1;

loop_time = fix(larg_comp_node_number * 3.3);
disp("loop time:",int2str(loop_time));
% loop_time = 10;
disp(loop_time);
max_delta = 0;
temp_delta = zeros(loop_time,1);
i = zeros(loop_time,1);
j = zeros(loop_time,1);
k = zeros(loop_time,1);
parfor loop_index = 1:loop_time
%     disp(loop_index);
    i(loop_index) = randi([1 larg_comp_node_number],1,1);
	j(loop_index) = randi([1 larg_comp_node_number],1,1);
    k(loop_index) = randi([1 larg_comp_node_number],1,1);
    temp_delta(loop_index) = Graph_curvature_calc_with_i_j_k(G_largest_component, i(loop_index), j(loop_index), k(loop_index));
end

same_i_j_k = true;
while(same_i_j_k)
    [Max_value, Index] = max(temp_delta);
    if i(Index)~=j(Index) && i(Index)~=k(Index) && j(Index)~=k(Index)
        max_delta = Max_value;
        max_i = i(Index);
        max_j = j(Index);
        max_k = k(Index);
        same_i_j_k = false;
    else
        disp("i or j or k have duplicate node ID");
        temp_delta(Index)=[]; % looking for next max value
    end
end
    
disp([max_i max_j max_k]);

disp(max_delta);
all_distance = distances(G_largest_component);
large_l = min([all_distance(max_i, max_j), all_distance(max_i, max_k), all_distance(max_j, max_k)]);

GC_value = max_delta/large_l; % /max_triangle;

end

