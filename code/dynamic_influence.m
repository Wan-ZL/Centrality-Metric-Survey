function DIC = dynamic_influence(graph_matrix)

% Dynamic Influence centrality Metrics
%       Input: G, the graph structure generated by Matlab function 'G=graph()'.
%              graph_matrix, adjacency matrices
% 
%       Output: DIC, Dynamic Influence centrality value for all nodes
% 
% 
% 
% Author: Zelin Wan
% 
% Reference: Lerman, Kristina, Rumi Ghosh, and Jeon Hyung Kang. 
%           "Centrality metric for dynamic networks." 
%           Proceedings of the Eighth Workshop on Mining and Learning with
%           Graphs. ACM, 2010.
% 
% 
% This function is based on Memoryless Formulation of Dynamic Centrality
% Metric.
% 
% For simplicity, initial information transmission probability B^(tk) will
% be variable 'beta', and the probability a^(tk+1)_k will be variable
% 'alpha'.
% 
% Since the topological structure of graph in this test file is static
% state(undynamic), the adjacency matrix is retained adjacency matrix.


g_length = length(graph_matrix);        

n = 1;                         % n is the number of snapshot of dynamic graph. Static means only one snapshot.

e(1:n) = {zeros(g_length)};                % unit vector (n x 1)
e{1} = ones(g_length,1);


% attenuation factors:
beta = 0.4;     % initial information transmission probability 

alpha = 0.2;    % information transmission probability


r(1:n) = {zeros(g_length, 1)};      % r_i

r{1} = beta * graph_matrix * e{1};
DC = r{1};


% Note: Since there is no other snapshot of graph in test file, the for loop won't run
% at all!!!
 for i = 2:n
     e{i-1} = zeros(g_length,1);          % reset e
     e{i} = ones(g_length,1);            % unit vector for current dimension
     
     r{i} = graph_matrix * (beta * e{i} + alpha * r{i-1});
     DC = DC + r{i};
     
 end
 

DIC = DC;
end