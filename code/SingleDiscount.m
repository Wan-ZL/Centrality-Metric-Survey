function SD_value = SingleDiscount(G_graph)
% Input: G_graph: graph
% Output: SD_value: SingleDiscount value(S node number)
% 
% Author: Zelin Wan
% Reference: W. Chen, Y. Wang, and S. Yang, “Efficient influence maximization
%           in social networks,” pp. 199–208, 2009.

disp('new start');

node_number = numnodes(G_graph);

% all_degree = indegree(G_graph) + outdegree(G_graph);
all_degree = degree(G_graph);

S = [];

[max_value, max_index] = max(all_degree);

for i = 1:node_number
%     disp('here');
%     disp(S);
%     disp(all_degree');
%     disp(max_index);
%     disp('here');
    S = [S, max_index];         % save max, and update it's degree
    all_degree(max_index) = -1;

    
    neighbs = neighbors(G_graph, max_index); % using old max here


    for neigh_index = neighbs       %   remove max & update degree_all
        all_degree(neigh_index) = all_degree(neigh_index) - 1;
    end


    neighbs = neighbors(G_graph, max_index);
    %     find new max, max should be neighbor of previous max_index. If
    %     not find, pick the next max degree node
    [max_value, max_index] = max(all_degree);
    max_value = -1;
    
    for neigh_index = 1:length(neighbs)             %   remove max & update degree_all
        if all_degree(neighbs(neigh_index)) > max_value
            max_index = neighbs(neigh_index);
            max_value = all_degree(neighbs(neigh_index));
        end
    end
    
    if max_value == -1
        disp('end');
        break;
    end

    if length(S) >= 10  % set the max S size
        break;
    end
    
end

SD_value = S;

end

