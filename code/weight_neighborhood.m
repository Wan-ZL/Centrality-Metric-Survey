function WNC = weight_neighborhood(G_graph, phi, alpha)
% Input: G_graph: undirected graph. (if is directed graph, change degree()
% to indegree()+outdegree())
%       phi: benchmark centrality(e.g., degree, betweenness, k-shell,
%       etc.)(use degree centrality in test)
%       alpha: tuning parameter between 1 and 0. (use 1 in test)
% 
% Output: Weight neighborhood centrality
% 
% Author: Zelin Wan
% 
% Reference: J. Wang, X. Hou, K. Li, and Y. Ding, “A novel weight neighborhood
% centrality algorithm for identifying in- fluential spreaders in complex networks,”
% Physica A: Statistical Mechanics and its Applications, vol. 475, pp. 88–105, 2017.

node_number = numnodes(G_graph);
all_degree = degree(G_graph);
all_diffu = (all_degree * (all_degree')).^alpha;
aver_diffu = sum(sum(all_diffu))/length(all_degree);

WNC = phi;

for v = 1:node_number
    neigh = neighbors(G_graph, v);
    for u = 1:length(neigh)
        WNC(v) = WNC(v) + (all_diffu(u,v)/aver_diffu) * phi(u);
        
    end

end



end