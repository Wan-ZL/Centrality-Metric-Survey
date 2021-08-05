function GC_value = Graph_curvature_calc_with_i_j_k(G_graph, i, j, k)
% This is function calculate Delta when i j k is given

D_array = [];
all_short_distance = distances(G_graph);
node_number = numnodes(G_graph);

% disp('here');
% get shortest geodesic distance for all nodes
short_path_i_j = shortestpath(G_graph, i, j); % get all nodes on i j geodesic
short_path_i_k = shortestpath(G_graph, i, k); % get all nodes on i k geodesic
short_path_j_k = shortestpath(G_graph, j, k); % get all nodes on j k geodesic
for node_index = 1:node_number
    % m to i j geodesic
%     short_path_i_j = shortestpath(G_graph, i, j); % get all nodes on i j geodesic
    m_to_i_j_dist = Inf;
    for geo_node = short_path_i_j   % try all node on geodesic
        temp_i_j_dist = all_short_distance(node_index, geo_node);
        if temp_i_j_dist < m_to_i_j_dist    % if find smaller distance, replace
            m_to_i_j_dist = temp_i_j_dist;
        end
    end
        
    % m to i k geodesic
%     short_path_i_k = shortestpath(G_graph, i, k); % get all nodes on i k geodesic
    m_to_i_k_dist = Inf;
    for geo_node = short_path_i_k
        temp_i_k_dist = all_short_distance(node_index, geo_node);
        if temp_i_k_dist < m_to_i_k_dist
            m_to_i_k_dist = temp_i_k_dist;
        end
    end
    
    % m to j k geodesic
%     short_path_j_k = shortestpath(G_graph, j, k); % get all nodes on j k geodesic
    m_to_j_k_dist = Inf;
    for geo_node = short_path_j_k
        temp_j_k_dist = all_short_distance(node_index, geo_node);
        if temp_j_k_dist < m_to_j_k_dist
            m_to_j_k_dist = temp_j_k_dist;
        end
    end
    
    D_array(node_index) = max([m_to_i_j_dist m_to_i_k_dist m_to_j_k_dist]);
    
end

% disp(D_array);

GC_value = min(D_array);

if GC_value == inf
    GC_value = 0;
end

end

