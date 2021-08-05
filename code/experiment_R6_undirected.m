clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% set workers
% delete(gcp('nocreate'));
% parpool(32); % this value can get from displayed infomation
disp(evalc('feature(''numcores'')'));



metric_name = 'betweenness'; % CHANGE
simulation_time = 1;
remove_percentage = [0, 30, 70];

% % My graph ================
% fileID = fopen('data/ia-email-univ.txt','r');
% formatSpec = '%i %i';
% sizeA = [2 Inf];
% file_data = fscanf(fileID,formatSpec,sizeA);
% 
% file_data = file_data +1;
% 
% % generate graph
% G = graph(file_data(1,:), file_data(2,:));
% 
% [bin,binsize] = conncomp(G);
% idx = binsize(bin) == max(binsize);
% G = subgraph(G, idx);
% % =========================

% Yash graph ==============
% data = load('data/email-Eu.mat');
% G = graph(data.Problem.A, 'upper');
% 
% 
% [bin,binsize] = conncomp(G);
% idx = binsize(bin) == max(binsize);
% G = subgraph(G, idx);
% =========================
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
% disp(G)
plot(G); %, 'Layout','force');         %initial graph
xlabel('original network');

% get largest component
[bin,binsize] = conncomp(G);
idx = binsize(bin) == max(binsize);
sub_G = subgraph(G, idx);

node_scale = sum(idx);%length(idx);

nodes_num = sub_G.numnodes;

% disp(random_id(1:int64(nodes_num*30/100)));
percent_set_length = length(remove_percentage);
SGC = zeros(simulation_time, percent_set_length);
GC = zeros(simulation_time, percent_set_length);

% simulation times
tStart = tic;
for iteration = 1:simulation_time
    disp(['working: ' int2str(iteration)]);
    % Try original, 30% remove, 70% remove
    random_id = randperm(nodes_num,nodes_num); % remove random id
    for i = 1:percent_set_length
        remove_id = random_id(1:int64(nodes_num*remove_percentage(i)/100));
        new_G = rmnode(sub_G, remove_id);

        % Giant component
        [~,components] = conncomp(new_G);
        SGC(iteration, i) = max(components);

        % CHANGE HERE
%         GC(iteration, i) = k_core(new_G);
%         brandes_betweenness(full(adjacency(sub_G)));
        betweenness(new_G);
%         centrality(sub_G,'betweenness');
    end
end
tEnd = toc(tStart);
% disp(tEnd);
run_time = tEnd/simulation_time;

average_SGC = (sum(SGC,1)/simulation_time)/nodes_num;  % normalize SGC
average_GC = sum(GC, 1)/simulation_time;

% disp(SGC);
% disp(average_SGC);
% disp("====");
% disp(GC);
% disp(average_GC);

% SGC 0% 30% 70% GC 0% 30% 70%
SGC_GC = [average_SGC average_GC];
% disp(average_SGC);
% disp(average_GC);


% last number is  "simulation time"
SGC_GC(end+1) = simulation_time;


% write result to file 
% writematrix(num_comp,strcat('data/',metric_name)); % this only for matlab 2019a
fileID_metric = fopen(strcat('data/R6/undirected/ER_network/',metric_name,'.txt'),'w');
if fileID_metric == -1
  error('Author:Function:OpenFile', 'Cannot open file');
end
fprintf(fileID_metric, '%d,', SGC_GC(1:end-1));
fprintf(fileID_metric, '%d', SGC_GC(end));


% write runtime to file
disp(run_time)
fileID_metric_runtime = fopen(strcat('data/R6/undirected/ER_network/',metric_name,'_runtime.txt'),'w');
if fileID_metric_runtime == -1
  error('Author:Function:OpenFile', 'Cannot open file');
end
fprintf(fileID_metric_runtime, '%d', run_time);

fclose(fileID_metric);
fclose(fileID_metric_runtime);


