function LSC = local_structure(G_graph,graph_matrix)
%L
% 
%   Author: Zelin Wan
% 
%   Reference:
%               Gao, Shuai, et al. 
%               "Ranking the spreading ability of nodes in complex networks based on local structure." 
%               Physica A: Statistical Mechanics and its Applications 403 (2014): 130-147.



node_number = length(graph_matrix);
LSC = zeros(node_number,1);
alpha = 0.5;                    % alpha is tunable balance parameter between 0 and 1

for node_index = 1:node_number          % loop all nodes
    node_neigh = neighbors(G_graph, node_index);        % get neighbor nodes

    % Gamma_1(v)
    gamma_1_sum = 0;
    for neigh_index = 1:length(node_neigh)          
        
        mu_of_N = length(nearest(G_graph, node_neigh(neigh_index), 2));
        
        
        % Gamma_2(u)
        gamma_2_sum = 0;
        gamma_2_nearest_neighbor = neighbors(G_graph, node_neigh(neigh_index));
        gamma_2_next_nearest_neighbor = [];
        for nearest_neigh_index = 1:length(gamma_2_nearest_neighbor)       % get next nearest neighbor
            gamma_2_temp_neighbor = neighbors(G_graph, gamma_2_nearest_neighbor(nearest_neigh_index));
            
            gamma_2_next_nearest_neighbor = [gamma_2_next_nearest_neighbor; gamma_2_temp_neighbor];
            
        end
        
        % calculate local clustering coeeficient
        sub_matrix = graph_matrix(gamma_2_next_nearest_neighbor,gamma_2_next_nearest_neighbor); % get local matrix
        gamma_2_sum = sum(clustering_coef_wd(sub_matrix), 'all');                   % riemann sum
        
        gamma_1_sum = gamma_1_sum + (alpha * mu_of_N + (1-alpha) * gamma_2_sum);    % riemann sum   
    end
    LSC(node_index) = gamma_1_sum;
    
    
    
end
disp(LSC)

end

