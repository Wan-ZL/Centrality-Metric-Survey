function [red] = redundancy(A)

% Input: Adjacent Metrix object
% Output: redundancy centrality
% Reference: R. S. Burt, Structural holes: the social structure of competition. Harvard University Press, Aug. 1995.

G = graph(A, 'upper');
N = numnodes(G);
red = zeros(1,N);
% Simplified version for undirected graph where Redundancy = 2*t/degrees(v)
for i=1:N
    neigh = neighbors(G, i);
    ego = [neigh; i];
    ego_net = subgraph(G, ego);
    n = numnodes(ego_net)-1; % Since the numnodes will consider the node i also 
    t = numedges(ego_net);
    red(i) = (2*t)/n;
end
red = red';