function CIGS = collective_influence(G,l)
% Find set of node with Collective Influence Metric.
% 
% Author: Zelin Wan
% 
% Refence: F. Morone and H. A. Makse, “Influence maximization in complex networks
%          through optimal percolation,” Nature, vol. 524, no. 7563, pp. 65–68, 2015.
% 
% Note: l = 5 in test


max_select = 10;
CIGS = [];
node_number = numnodes(G);

G.Nodes.ID = (1:node_number)';
G.Nodes.Value = zeros(node_number,1);


% initial calc
all_degree = degree(G);
for index = 1:node_number
    G.Nodes.Value(index) = collective_influence_value(G, l, index, all_degree);
end

for GIGS_index = 1:max_select
    [M, I] = max(G.Nodes.Value);
    % save node id
    CIGS = [CIGS, G.Nodes.ID(I)];
    % only renew l hop adj
    if numnodes(G)<=1
        break;
    end
    renewal_list = nearest(G, I, l+1);
%     disp([M, I, numnodes(G)]);
    origin_id_list = G.Nodes.ID(renewal_list);
    G = rmnode(G, I);
    all_degree = degree(G);
    value = zeros(numnodes(G),1);
    for node_index = 1:numnodes(G)
        if ismember(G.Nodes.ID(node_index), origin_id_list)
%             G.Nodes.Value(node_index) = collective_influence_value(G, l, node_index, all_degree);
            value(node_index) = collective_influence_value(G, l, node_index, all_degree);
        end
    end
    G.Nodes.Value = value;
end
% disp(any(G.Nodes.Value));
% if ~any(G.Nodes.Value)
%     disp(adjacency(G));
% end
    
    
