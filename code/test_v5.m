clear; clc; clf;

scale = 300;
sanity_check_at = 150;       % sanity check
sanity_check_at_2 = 250;
p_value = 0.1;              % p value
dist_thres = 7;             % distance threshold

use_direct_graph = true;

undirect2direct_prob = 0.5;      % direct graph to undirect graph probability

k_size = scale;
n = scale;  %inital size of network

not_full_connect = true;
while(not_full_connect)
    disp('new graph');
    A = er2(n, p_value); %generate random graph
    G = graph(A.Adj, 'upper');
    not_full_connect = false;   % assume graph is full connect
    for i = 1:length(A.Adj)     % get fully connected graph
        if isempty(neighbors(G, i)) == true     % no neighbor(no edge)
            not_full_connect = true;   % regenerate graph
        end
    end
end

% undirect_graph_matrix = A.Adj;

if use_direct_graph
    % indirected graph to direct graph
    for i = 1:length(A.Adj)
        for j = 1:length(A.Adj)
            if A.Adj(i,j) == 1 && A.Adj(j,i) == 1
                if rand > undirect2direct_prob
                    A.Adj(i,j) = 0;
                else
                    A.Adj(j,i) = 0;
                end
            end
        end
    end
    G = digraph(A.Adj);
else
    G = graph(A.Adj);
end


subplot(1,3,1);
plot(G, 'Layout','force');         %initial graph
xlabel('original network');

tic
x_k = 1:k_size;   %x-axis plotting index
y_si = zeros(1,k_size);  %y-axis plotting index 1 (for initial calculation)
y_sr = zeros(1,k_size);  %y-axis plotting index 2 (for recalculation)



percolation_value = zeros(length(A.Adj), 1);
Gc = Graph_curvature(G);    %CHANGE

r_id = zeros(1,k_size);     % save the centrality
b_id = zeros(1,k_size);     

Ai = A.Adj;  %for initial calculation
Ar = A.Adj;  %for recalculation
% disp(full(adjacency(G)));
if use_direct_graph
    [~,components] = conncomp(G, 'Type','weak');
else
    [~,components] = conncomp(G);
end
original_giant_size = max(components);
maximum_graph_centrality_observed = Gc;
N = numedges(G); % the worst case for original graph

for k = 1:(scale)
    Gc = Graph_curvature(G); % CHANGE
    disp('get');
    disp(Gc);
    if abs(Gc) > maximum_graph_centrality_observed
        maximum_graph_centrality_observed = abs(Gc);
        
    end
    
    N = numedges(G);
%     disp(['node ' int2str(N)]);
    
    if use_direct_graph
        [~,components] = conncomp(G, 'Type','weak');
    else
        [~,components] = conncomp(G);
    end
    b_id(k) = max(components);
%     disp(max(components));
    
    
    r_id(k) = Gc;
    
%     disp(Gc);

    remove_num = randi(scale - k+1);
    G = rmnode(G, remove_num);
    
    if k == sanity_check_at
        subplot(2,3,3);
        plot(G, 'Layout','force');         %initial graph
        xlabel(['network when remove ',int2str(sanity_check_at),' nodes']);
    end
    
    if k == sanity_check_at_2
        subplot(2,3,6);
        plot(G, 'Layout','force');         %initial graph
        xlabel(['network when remove ',int2str(sanity_check_at_2),' nodes']);
    end

end

r_id = r_id/maximum_graph_centrality_observed;
b_id = b_id/original_giant_size;




toc



subplot(1,3,2);
% plot(x_k, y_si, '--bo');
hold on;
% plot(x_k, y_sr, '--rx');
b = bar(x_k, [r_id; b_id], 'FaceColor','flat');
b(1).FaceColor = '#D95319';
b(2).FaceColor = '#0072BD';
% bar(x_k, b_id);
xlabel('number of removed nodes');
% ylabel('Normalization for size of a giant component and the number of top-k ranked nodes');
ylabel('Normalization for size of a giant component and the graph centrality value');
hold off;
saveas(gcf,'result.png')