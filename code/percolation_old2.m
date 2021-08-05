function PC = percolation_old2(graph_matrix, percolation_value)
% 
%   Input:  graph_matrix: adjacency matrix
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
%               (K shortest path) https://blog.csdn.net/Canhui_WANG/article/details/51507914

% use pre-calculation and parallel calcuation to save time

node_number = length(graph_matrix);
PC = zeros(node_number, 1);
% percolation_value = ones(node_number, 1);
percolation_total = sum(percolation_value);

disp('start');




skip_graph = graph_matrix * ones(node_number,1) + graph_matrix' * ones(node_number,1);
% disp(percolation_value');
% disp(percolation_value(1));

% convert 0 to Inf
parfor i = 1:node_number
    for j = 1:node_number
        if graph_matrix(i,j)==0
            graph_matrix(i,j)=Inf;      
        end
    end
end

% short_path_number_bfs(G_graph, graph_matrix, 1, 2)

% pre-calculate
all_shortest_paths = {};
for i = 1:node_number
    if skip_graph(i) == 0        % skip deleted node for save time
        continue;
    end
    if percolation_value(i) == 0     % skip the x^t_s = 0 situation.
        continue;
    end
    text = ['working on ', num2str(i)];
%     disp(text);
    for j = 1:node_number
        if skip_graph(j) == 0        % skip deleted node for save time
            continue;
        end
        [path, cost] = kShortestPath(graph_matrix,i,j);
        all_shortest_paths{i,j} = path;
        
        
    end
end

disp('pre-calc end');

% celldisp(all_shortest_paths{1,2});

% disp(all_shortest_paths);


parfor node_index_v = 1:node_number
    if skip_graph(node_index_v) == 0        % skip deleted node for save time
        continue;
    end
    for node_index_s = 1:node_number
        if skip_graph(node_index_s) == 0    % skip deleted node for save time
            continue;
        end

        if percolation_value(node_index_s) == 0     % skip the x^t_s = 0 situation.
%             disp('perco skip');
            continue;
        end
        
%             disp([node_index_v, node_index_s]);
        
        for node_index_r = 1:node_number
            if skip_graph(node_index_r) == 0    % skip deleted node for save time
                continue;
            end
%             disp([node_index_v, node_index_s, node_index_r]);
            
            if node_index_v ~= node_index_s && node_index_v ~= node_index_r && node_index_s ~= node_index_r
                path= all_shortest_paths{node_index_s, node_index_r};% kShortestPath(graph_matrix,node_index_s,node_index_r);
%                 disp([node_index_s,node_index_r]);
%                 disp(cost);
                if isempty(path) % no path
                    continue;
                end
                
                Sigma_sr = length(path);
                Sigma_srv = 0;
                for i = 1:length(path)
                    exist_arr = ismember((node_index_v), path{i});
                    
                    if exist_arr(1) == 1
                        Sigma_srv = Sigma_srv+1;
                    end
                end
                
                
                Sigma_divide = Sigma_srv/Sigma_sr;
                if isnan(Sigma_divide)
                    Sigma_divide = 0;
                end
                
                PC(node_index_v) = PC(node_index_v) + Sigma_divide * (percolation_value(node_index_s)/(percolation_total-percolation_value(node_index_v)));
                
                
            end
        end
    end
end

% disp('pc');
% disp(PC');
% disp('max node');
% [mv,mi] = max(PC);
% disp(mi);


end