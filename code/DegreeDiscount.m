% function DD_value = DegreeDiscount(G_graph, probability_p)
% %DEGREEDISCOUNT 此处显示有关此函数的摘要
% %   此处显示详细说明
% disp('new start');
% 
% node_number = numnodes(G_graph);
% 
% all_degree = indegree(G_graph) + outdegree(G_graph);
% 
% seed_number = zeros(node_number);
% 
% S = [];
% 
% [max_value_array, max_index] = max(all_degree);
% 
% for i = 1:node_number
%     disp('here');
%     disp(S);
%     disp(all_degree');
%     disp(max_index);
%     disp('here');
%     S = [S, max_index];         % save max, and update it's degree
%     all_degree(max_index) = -1;
% 
%     
%     preds = predecessors(G_graph, max_index); % using old max here
%     succs = successors(G_graph, max_index);
%     
%     for pred_index = preds        %   remove max & update degree_all
% %         all_degree(pred_index) = all_degree(pred_index) - 1;
%         seed_number(pred_index) = seed_number(pred_index) + 1;
%     end
%     
%     
%     for succ_index = succs
% %         all_degree(succ_index) = all_degree(succ_index) - 1;
%         seed_number(succ_index) = seed_number(succ_index) + 1;
%     end
%     
%     S_length = length(S);
%     max_value_array = zeros(S_length);
%     max_index_array = zeros(S_length);
%     parfor seed_index = 1:S_length
%         preds = predecessors(G_graph, S(seed_index)); 
%         succs = successors(G_graph, S(seed_index));
%         
%         for pred_index = 1:length(preds)        %   remove max & update degree_all
%             current_value = (1-probability_p)^seed_number(preds(pred_index)) * (1+(all_degree(i)-seed_number(preds(pred_index)))*probability_p);
%             if current_value > max_value_array(seed_index)
%                 max_index_array(seed_index) = preds(pred_index);
%                 max_value_array(seed_index) = current_value;
%             end
%         end
% 
% 
%         for succ_index = 1:length(succs)
%             current_value = (1-probability_p)^seed_number(succs(succ_index)) * (1+(all_degree(i)-seed_number(succs(succ_index)))*probability_p);
%             if current_value > max_value_array(seed_index)
%                 max_index_array(seed_index) = succs(succ_index);
%                 max_value_array(seed_index) = current_value;
%             end
%         end
%         
%     end
%     [max_value, I] = max(max_value_array);
%     max_index = max(I);
%     
%     
%     %     find new max, max should be neighbor of previous max_index. If
%     %     not find, pick the next max degree node
%     
%     
%     
% 
%     
%     if max_value == -1
%         disp('end');
%         break;
%     end
% %     disp(S');
%     
%     
%     
% end
% 
% [~, DD_value] = size(S);
% end
% 
