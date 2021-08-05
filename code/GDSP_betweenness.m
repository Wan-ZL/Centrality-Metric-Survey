function GDSPBC = GDSP_betweenness(G_graph, alpha)
% Generalized degree and shortest paths betweenness
% Input: G_graph, the graph structure generated by Matlab function 'G=graph()'.
%        graph_matrix: adjacency matrix
%        alpha (alpha = 1.5 in test)
% Output: GDSPBC: Generalized degree and shortest paths betweenness
%   
% Author: Zelin Wan
% 
% Reference: T. Opsahl, F. Agneessens, and J. Skvoretz, “Node centrality in
%               weighted networks: Generalizing degree and shortest paths,”
%               Social networks, vol. 32, no. 3, pp. 245–251, 2010.
% 
%            https://www.mathworks.com/help/matlab/ref/graph.centrality.html
% 
% Note: G_graph must have Weight attribute on Edge. Otherwise, error may occur.


GDSPBC = centrality(G_graph,'betweenness','Cost',G_graph.Edges.Weight.^alpha);




% node_number = length(graph_matrix);
% skip_graph = graph_matrix * ones(node_number,1) + graph_matrix' * ones(node_number,1);
% GDSPBC = zeros(node_number,1);
% 
% graph_matrix = graph_matrix * alpha;  % tunning value
% % disp(['number of worker: ' int2str(numlabs)]);
% 
% % convert 0 to Inf
% parfor i = 1:node_number
%     for j = 1:node_number
%         if graph_matrix(i,j)==0
%             graph_matrix(i,j)=Inf;      
%         end
%     end
% end
% 
% % pre-calculate
% all_shortest_paths = {};
% parfor i = 1:node_number
%     if skip_graph(i) == 0        % skip deleted node for save time
%         continue;
%     end 
%     text = ['GDSP on ', num2str(i)];
%     disp(text);
%     for j = 1:node_number
%         if skip_graph(j) == 0        % skip deleted node for save time
%             continue;
%         end
%         path = shortestpath(G_graph,i,j);
%         all_shortest_paths{i,j} = path;
%     end
% end
% disp('pre-calc end');
% 
% 
% parfor node_index_i = 1:node_number
%     if skip_graph(node_index_i) == 0        % skip deleted node for save time
%         continue;
%     end
%     for node_index_j = 1:node_number
%         if skip_graph(node_index_j) == 0        % skip deleted node for save time
%             continue;
%         end
%         for node_index_k = 1:node_number
%             if skip_graph(node_index_k) == 0        % skip deleted node for save time
%                 continue;
%             end
%             path= all_shortest_paths{node_index_j, node_index_k};
%             
%             if isempty(path) % no path
%                 continue;
%             end
%             
%             g_jk = length(path);
% 
%             g_jk_i = ismember([node_index_i], path);
% %             for i = 1:length(path)
% %                 exist_arr = ismember((node_index_i), path{i});
% %                 disp(exist_arr);
% %                 if exist_arr(1) == 1
% %                     g_jk_i = g_jk_i+1;
% %                 end
% %             end
%             
%             GDSPBC(node_index_i) = GDSPBC(node_index_i) + (g_jk_i/g_jk);
%             
%             
%         end
%     end
%     
%     
% end
% % disp(GDSPBC');

end

