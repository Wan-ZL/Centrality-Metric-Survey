function  [delta_centra] = delta_centrality(G)
%delta_betweenness
%
%   Delta centrality. This function only work for undirected
%   graph.
% 
%   Author: Zelin Wan
%
%   input:      G,	undirercted graph
%   
%   output:     dc,     delta centrality for each node
%
%   Reference:  Latora, V., & Marchiori, M. (2007). A measure of centrality
%   based on network efficiency. New Journal of Physics, 9(6), 188.
% 
%   Note: this is the version that P[G]=K, K is the number of edge in
%   network.


% n = 100;
% beta = 0.25;
% A = 1*(beta>=rand(n));
% G = graph(A, 'upper');
% delta=1;


    

N = numnodes(G);

% initialize ...
delta_centra = zeros(1,N);
totalEdgeNumber = numedges(G);
if totalEdgeNumber == 0
    return
end

for v=1:N
    delta_centra(v) = (length(outedges(G,v)))/totalEdgeNumber;
%     disp(delta_centra(v))
%     disp(length(outedges(G,v)))
end
% disp(sum(delta_centra))






% disp(delta_centra);

% handle nodes that are NaNs
% delta_centra(isnan(delta_centra)) = 0;
% dc = dc';

