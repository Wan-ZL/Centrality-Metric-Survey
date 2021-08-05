function  [between_centra] = betweenness(G)
%delta_betweenness
%
%   betweenness centrality. This function only work for undirected
%   graph.
% 
%   Author: Zelin Wan
%
%   input:      G,	undirercted graph
%   
%   output:     bc,  betweenness for each node
%
%   Reference:  

% n = 100;
% beta = 0.25;
% A = 1*(beta>=rand(n));
% G = graph(A, 'upper');
% delta=1;


    

N = numnodes(G);

% initialize ...
between_centra = zeros(1,N);
node_id_list = 1:N;
dist_matrix = distances(G);


% loop node pair
for s=1:N
    for t=s:N
        if s==t
            continue
        end
        if isinf(dist_matrix(s,t))
            continue
        end
        numerator = zeros(1,N);
        denominator = zeros(1,N);
        
        paths = allpaths(G,s,t,'MaxPathLength',dist_matrix(s,t));
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
                between_centra(v) = between_centra(v) + numerator(v)/denominator(v);
            end
        end
    end
end

% disp(between_centra);

% handle nodes that are NaNs
% delta_centra(isnan(delta_centra)) = 0;
% dc = dc';

