clear; clc; clf;

scale = 300;
sanity_check_at = 250;       % sanity check
p_value = 0.02;              % p value

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

undirect_graph_matrix = A.Adj;

% undirected graph to direct graph
% for i = 1:length(A.Adj)
%     for j = 1:length(A.Adj)
%         if A.Adj(i,j) == 1 && A.Adj(j,i) == 1
%             if rand > undirect2direct_prob
%                 A.Adj(i,j) = 0;
%             else
%                 A.Adj(j,i) = 0;
%             end
%         end
%     end
% end
% G = graph(A.Adj);

% figure('Renderer', 'painters', 'Position', [10 10 3360 1998]);
subplot(1,3,1);
plot(G, 'Layout','force');         %initial graph
xlabel('original network');


% G.Edges.Weight = randi(10, numedges(G), 1);


tic
x_k = 1:k_size;   %x-axis plotting index
y_si = zeros(1,k_size);  %y-axis plotting index 1 (for initial calculation)
y_sr = zeros(1,k_size);  %y-axis plotting index 2 (for recalculation)


%D = ct_degree(A.Adj,n);
percolation_value = zeros(length(A.Adj), 1);
% phi = centrality(G,'degree');
Dc = contribution(full(adjacency(G))); %full(adjacency(G)), percolation_value); %GDSP_degree(G, 1.5);;                               %CHANGE

D = [Dc linspace(1,n,n)'];
Dr = D;       %static array for recalculation
Dsorted = sortrows(D, 1, 'descend');  %sort by degree in descending order
    
ri = 1;     %index for where to start new iteration
r_id = zeros(1,k_size);     %result history after each recalculation
r_id(1) = Dsorted(1,2);     %save the first history

disp(r_id(1));
% percolation_value(r_id(1)) = 1;
% for i = successors(G, r_id(1))  % change the percolation_value
%     percolation_value(i) = 1;
% end
% for i = predecessors(G, r_id(1)) % change the percolation_value
%     percolation_value(i) = 1;
% end

existing_node = 1:scale;    % represent that node not delete yet
all_node = 1:scale;

Ai = A.Adj;  %for initial calculation
Gi = graph(Ai);
Ar = A.Adj;  %for recalculation

% % % % 
G_centra_remove_graph = graph(A.Adj, 'upper');
G_rand_remove_graph = graph(A.Adj, 'upper');
G_centra_remove_graph.Nodes.percolation_value = zeros(numnodes(G_centra_remove_graph), 1);
for k = 1:k_size
    [bins_rand,binsizes_rand] = conncomp(G_rand_remove_graph);
    [bins_cent,binsizes_cent] = conncomp(G_centra_remove_graph);
    y_si(k) = max(binsizes_rand);
    y_sr(k) = max(binsizes_cent);
    
    % sanity check
    if k == sanity_check_at
        subplot(1,3,3);
%         temp_graph = graph(G_centra_remove_graph);
%         temp_graph = rmnode(temp_graph,r_id(1:ri));
        
        plot(G_centra_remove_graph, 'Layout','force');         % graph at sanity check points
        xlabel(['network when remove ',int2str(sanity_check_at),' nodes']);
        
    end
    
    % rand remove node
    G_rand_remove_graph = rmnode(G_rand_remove_graph, randi(numnodes(G_rand_remove_graph)));
    centr_values = contribution(full(adjacency(G_centra_remove_graph)));%full(adjacency(G_centra_remove_graph)), percolation_value); %GDSP_degree(G_centra_remove_graph, 1.5);                   %CHANGE
    [max_value, max_index] = max(centr_values);
    
    percolation_neighbor = neighbors(G_centra_remove_graph, max_index);
    if ~isempty(percolation_neighbor)
        G_centra_remove_graph.Nodes.percolation_value(percolation_neighbor) = 1;
    end
    G_centra_remove_graph = rmnode(G_centra_remove_graph, max_index);
    
    disp(['remove ' int2str(max_index)]);
    
    
end

% % % % 
% for k = 1:k_size  %number of node removal
%     
% %     Print existing node at sanity check point
%     if k == sanity_check_at
%         subplot(1,3,3);
%         temp_graph = graph(Ar);
%         temp_graph = rmnode(temp_graph,r_id(1:ri));
%         
%         plot(temp_graph, 'Layout','force');         % graph at sanity check points
%         xlabel(['network when remove ',int2str(sanity_check_at),' nodes']);
%         
%     end
%     
% %     Ai(Dsorted(k,2),:) = zeros(1,n);  %remove connections between node with highest degree
% %     Ai(:,Dsorted(k,2)) = zeros(n,1);
%     remove_num = randi(scale - k+1);
%     
%     Gi = rmnode(Gi, remove_num);
%     
% %     [~,binsize] = conncomp(Gi, 'Type','weak');
%     [~,binsize] = conncomp(Gi);
%     
% 
%     n_Si = max(binsize);    %size of giant component after k removal at once
%     if (scale - k+1) == 1
%         n_Si = 0;
%     end
% %     disp(['max ', int2str(scale - k+1)]);
%     y_si(k) = n_Si;
%     
%     %for recalculation
%     Ar(Dr(r_id(k),2),:) = zeros(1,n);     %use history step by step to remove nodes
%     Ar(:,Dr(r_id(k),2)) = zeros(n,1);
%     
%     if ri > k
%         continue;       %boundary condition
%     end
%     
%      Gr = graph(Ar);
% %     Dc = centrality(Gr, 'degree');       %proceed one latest recalculation
% 
%     Dc = Curvature(Gr, Ar);                  %CHANGE
%     Dr = [Dc linspace(1,n,n)'];
%     [mv,mi] = max(Dr(:,1));     %find the index of the top node
% 
%     % if all nodes have the same value, pick the first existing node
%     all_same = true;
%     for i = 1:length(Dc)
%         if Dc(i) ~= Dc(1)
%             all_same = false;
%             break;
%         end
%     end
%     if(all_same)
% %         disp('all same');
%         mi = existing_node(1);
%     end
%     
%   
%     disp('remove');
%     disp(mi);
%     
%     idx = existing_node==mi; % index of element mi
%     existing_node(idx) = [];
% %     disp(existing_node);
%     
%     percolation_value(mi) = 0; % removed node have zero percolation_value
% %     for i = successors(G, mi)  % change the percolation_value
% %         percolation_value(i) = 1;
% %     end
% %     for i = predecessors(G, mi) % change the percolation_value
% %         percolation_value(i) = 1;
% %     end
%     
%     
%     r_id(ri+1) = mi;            %save the newest index in the history
%     ri = ri + 1;                %to the next step
%     
% %    Sr = largestcomponent(Ar);
% %     [~,binsize] = conncomp(graph(Ar), 'Type','weak');
%     [~,binsize] = conncomp(graph(Ar));
% %    n_Sr = length(Sr);
%     n_Sr = max(binsize);
%     y_sr(k) = n_Sr;
%     
%     
% end
% 
% toc


subplot(1,3,2);
plot(x_k, y_si, '--bo');
hold on;
plot(x_k, y_sr, '--rx');
xlabel('number of removed nodes');
ylabel('size of giant weak component');
hold off;
saveas(gcf,'result.png')