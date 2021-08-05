clear; clc; clf;

scale = 300;
sanity_check_at = 150;       % sanity check
sanity_check_at_2 = 230;
p_value = 0.02;              % p value
dist_thres = 7;             % distance threshold

use_direct_graph = false;

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


subplot(1,2,1);
plot(G, 'Layout','force');         %initial graph
xlabel('original network');


r_id = zeros(1,k_size+1);     % save the centrality
r_id(1) = scale;
b_id = zeros(1,k_size+1);
b_id(1) = scale;
group_size = zeros(1,k_size+1);

centra_graph = G;
random_graph = G;


if use_direct_graph
    [~,components] = conncomp(G, 'Type','weak');
else
    [~,components] = conncomp(G);
end
original_giant_size = max(components);
N = numedges(G); % the worst case for original graph

result_size = 0;

for k = 1:(scale)
    Gc = SingleDiscount(centra_graph); % CHANGE
    disp(Gc);
    
    
    group_size(k+1) = length(Gc);
    disp(numnodes(random_graph));
    disp(numnodes(centra_graph));
    
    Randc = randperm(numnodes(random_graph), length(Gc));   % randomly remove same number of node(s)

    centra_graph = rmnode(centra_graph, Gc);
    random_graph = rmnode(random_graph, Randc);
    
    if use_direct_graph
        [~,centra_components] = conncomp(centra_graph, 'Type','weak');
        [~,random_components] = conncomp(random_graph, 'Type','weak');
    else
        [~,centra_components] = conncomp(centra_graph);
        [~,random_components] = conncomp(random_graph);
    end
%     disp(max(centra_components));
    if ~isempty(centra_components)
        r_id(k+1) = max(centra_components);
        result_size = result_size + 1;
    end
    if ~isempty(random_components)
        b_id(k+1) = max(random_components);
        
    end
    

end
centra_result_max = max(r_id);
random_result_max = max(b_id);

r_id = r_id/centra_result_max;
b_id = b_id/random_result_max;

r_id = r_id(1:result_size);
b_id = b_id(1:result_size);
group_size = group_size(1:result_size);

x_k = 1:result_size;   %x-axis plotting index
% toc



subplot(1,2,2);

hold on;

b = bar(x_k, [r_id; b_id], 'FaceColor','flat');
b(1).FaceColor = '#D95319';
b(2).FaceColor = '#0072BD';
text(x_k,b_id,num2str(group_size'),'vert','bottom','horiz','center'); 
% bar(x_k, b_id);
xlabel('number of node group');
% ylabel('Normalization for size of a giant component');
ylabel('Normalization for size of a giant component and the graph centrality value');
hold off;
saveas(gcf,'result.png')