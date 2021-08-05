clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% set workers
% delete(gcp('nocreate'));
% parpool(32); % this value can get from displayed infomation
disp(evalc('feature(''numcores'')'));


metric_name = 'betweenness'; % CHANGE
simulation_time = 100;
tic;

% My graph ================
% fileID = fopen('data/ia-email-univ.txt','r');
% formatSpec = '%i %i';
% sizeA = [2 Inf];
% file_data = fscanf(fileID,formatSpec,sizeA);
% 
% file_data = file_data +1;
% 
% % generate graph
% G = graph(file_data(1,:), file_data(2,:));
% =========================

% % Yash graph ==============
% data = load('data/email-Eu.mat');
% G = graph(data.Problem.A, 'upper');
% 
% 
% [bin,binsize] = conncomp(G);
% idx = binsize(bin) == max(binsize);
% G = subgraph(G, idx);
% % =========================
n = 100;
beta = 0.05;
A = 1*(beta>=rand(n));
G = graph(A, 'upper');
delta=1;
disp("Number of Edge:"+size(G.Edges))

% add weight property (1 if not given)
G.Edges.Weight = ones(numedges(G),1);

% add percolation
G.Nodes.percolation_value = zeros(numnodes(G), 1);


% original_graph_size = numnodes(G);
disp(G)
plot(G); %, 'Layout','force');         %initial graph
xlabel('original network');

% get largest component
[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);

node_scale = sum(idx);%length(idx);


num_comp_matrix = zeros(simulation_time,node_scale+1);
% simulation times
tStart = tic;
parfor iteration = 1:simulation_time
    disp(['working: ' int2str(iteration)]);


    % get largest component
    sub_G = subgraph(G, idx);
    
    for k = 1:node_scale
        disp(['on: ' int2str(k)]);
        
        % geodesic distance
%         d = distances(sub_G);
%         geodis = max(max(d));
        
        [~,components] = conncomp(sub_G);
%         if isempty(components)
%             disp('empty component');
%             continue;
%         end
        num_comp_matrix(iteration,k) = num_comp_matrix(iteration,k) + max(components); % get sum result

        % remove node                                   (CHANGE HERE)
%         remove_node = randi(node_scale - k+1); % remove random id
%         Dc = flow_betweenness(full(adjacency(sub_G)));
        Dc = betweenness(sub_G);
%         Dc = centrality(sub_G,'betweenness');

        % avoid NaN Error
        
        Dc(isnan(Dc)) = 0;
        
        % randomly pick max if have more than one max value
        max_value = max(Dc);
        max_results = find(Dc == max_value);
        rand_index = randperm(length(max_results),1);
        remove_node = max_results(rand_index);

        percolation_neighbor = neighbors(sub_G, remove_node);
        if ~isempty(percolation_neighbor)
            sub_G.Nodes.percolation_value(percolation_neighbor) = 1;
        end
        sub_G = rmnode(sub_G, remove_node);
        
    end
    
end
tEnd = toc(tStart);
disp(tEnd);

num_comp = sum(num_comp_matrix, 1); % matrix to array
% get average result
num_comp = int64(num_comp/simulation_time); % round double to integer
% last number is  "simulation time"
num_comp(end) = simulation_time;


% write to file 
% writematrix(num_comp,strcat('data/',metric_name)); % this only for matlab 2019a
fileID_metric = fopen(strcat('data/R1/undirected/ER_network/',metric_name,'.txt'),'w');
if fileID_metric == -1
  error('Author:Function:OpenFile', 'Cannot open file');
end
fprintf(fileID_metric, '%d,', num_comp(1:end-1));
fprintf(fileID_metric, '%d', num_comp(end));


% write run time to file
run_time = tEnd/simulation_time;
disp(length(num_comp));

fileID_metric_runtime = fopen(strcat('data/R1/undirected/ER_network/',metric_name,'_runtime.txt'),'w');
if fileID_metric_runtime == -1
  error('Author:Function:OpenFile', 'Cannot open file');
end
fprintf(fileID_metric_runtime, '%d', run_time);

fclose(fileID_metric);
fclose(fileID_metric_runtime);
% fclose(fileID);
disp("runtime:"+toc)
