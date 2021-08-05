function  [delta_centra] = delta_betweenness(G, delta)
%delta_betweenness
%
%   Delta-betweenness centrality. This function only work for undirected
%   graph.
% 
%   Author: Zelin Wan
%
%   input:      G,	undirercted graph
%               delta, non-negative integer
%   output:     dc,     delta betweenness for each node
%
%   Reference:  Plutov, A., & Segal, M. (2013, September). 
%   The delta-betweenness centrality. In 2013 IEEE 24th Annual International
%   Symposium on Personal, Indoor, and Mobile Radio Communications (PIMRC) 
%   (pp. 3376-3380). IEEE.

% n = 100;
% beta = 0.25;
% A = 1*(beta>=rand(n));
% G = graph(A, 'upper');
% delta=1;


if (delta < 0)
    disp(delta)
    error("Delta must greater or equal to 0")
end
    

N = numnodes(G);

% initialize ...
delta_centra = zeros(1,N);
node_id_list = 1:N;
dist_matrix = distances(G);


% loop node pair
for s=1:N
    disp({s});
    for t=s:N
        if s==t
            continue
        end
        if isinf(dist_matrix(s,t))
            continue
        end
        numerator = zeros(1,N);
        denominator = zeros(1,N);
        
        paths = allpaths(G,s,t,'MaxPathLength',dist_matrix(s,t)+delta);
%         try
%             paths = allpaths(G,s,t,'MaxPathLength',dist_matrix(s,t)+delta);
%         catch
%             disp(dist_matrix(s,t))
%         end
        for path_id = 1:length(paths)
            path = paths{path_id,1}(2:end-1);
            denominator = denominator+1;
            ele_in_list = ismember(node_id_list, path);
            numerator = numerator + ele_in_list;
        end
        
        % add fraction value to each node
        for v=1:N
            if denominator(v)~=0
                delta_centra(v) = delta_centra(v) + numerator(v)/denominator(v);
            end
        end
    end
end

% disp(delta_centra);

% handle nodes that are NaNs
% delta_centra(isnan(delta_centra)) = 0;
% dc = dc';

