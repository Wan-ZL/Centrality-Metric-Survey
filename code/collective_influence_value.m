function CI = collective_influence_value(G,l,node_id, all_degree_input)
% Calculate collective influence value for sinngle node
% 
% Author: Zelin Wan
% 
% Refence: F. Morone and H. A. Makse, “Influence maximization in complex networks
%          through optimal percolation,” Nature, vol. 524, no. 7563, pp. 65–68, 2015.

if nargin > 3
    all_degree = all_degree_input;
else
    all_degree = degree(G);
end

l_hop_adj = nearest(G, node_id, l);

CI = (all_degree(node_id)-1) * sum(all_degree(l_hop_adj)-1);

