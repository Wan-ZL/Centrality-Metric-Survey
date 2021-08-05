function DC = Diffusion(A_graph)
%DIFFUSION Diffusion centrality metric
%   Input: A_graph, the conneted graph, network
%   Output: DC, Diffusion Centrality value for all nodes
%   A_grouph is SN
%   
%   
%   Author: Zelin Wan
%   Reference:  https://www.coursera.org/lecture/social-economic-networks/2-5b-application-diffusion-centrality-mHGco
% 
%               Kang, Chanhyun, et al. 
%               "Diffusion centrality in social networks."
%               2012 IEEE/ACM International Conference on Advances in Social Networks Analysis and Mining. IEEE, 2012.
%
%   Since the diffusion probability p is not given in test file. I assume
%   the p value is 0.1 in each period.

g_length = length(A_graph);


DC = zeros(g_length,1);

dif_p = 0.1;        % diffusion probability p
t_per = 50;              % period t_per

% disp('result');
% disp(length(nei_set));

for i = 1:g_length      % for all node in graph
    nei_set = find(A_graph(i,:));       % neighbor set
    nei_number = length(nei_set);       % number of neighbor
    
    dc_for_a_node = 0;            % inital as 0
    for t = 1:t_per     % Riemann sum '(pg)^t * 1'
        dc_for_a_node = dc_for_a_node + ((dif_p*nei_number)^t)*1;   % formula see reference video at 3:17.
        
    end
    
    DC(i) = dc_for_a_node         % save dc value

end
