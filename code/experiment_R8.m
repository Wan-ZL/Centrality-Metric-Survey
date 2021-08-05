clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
metric_name_undirected = ["degree","closeness","betweenness","pagerank","eigenvector","local_betweenness","Volume","redundancy","kshell","improved_kshell","neighborhood_coreness","flow_betweenness","katz","diffusion_centrality","subgraph","information_centrality","residual_closeness","semi_local","mixed_degree_decomposition","GDSP_degree","GDSP_closeness","GDSP_betweenness","eccentricity","cumulative_nomination","local_entropy","mapping_entropy","percolation","hybrid_degree","clustering_coef","contribution","weight_neighborhood", "h_index", "dynamic_influence"];
metric_name_directed = ["hubs","authorities","clusterrank","SALSA_authorities","SALSA_hubs","leaderrank"];
font_size = 25;


metric_num_undirected = length(metric_name_undirected);
metric_num_directed = length(metric_name_directed);
metric_num = metric_num_undirected+metric_num_directed;
running_time_list = zeros(metric_num,1);

% read all data from undirected folder
for index = 1:metric_num_undirected
    run_time = readmatrix(strcat('data/R1/undirected/email-Eu/',metric_name_undirected(index),'_runtime'));  % CHANGE
    running_time_list(index) = run_time;
    disp(run_time)
end

% read all data from directed folder
for index = 1:metric_num_directed
    run_time = readmatrix(strcat('data/R1/directed/tech-routers-rf/',metric_name_directed(index),'_runtime'));  % CHANGE
    running_time_list(index+metric_num_undirected) = run_time;
    disp(run_time)
end

% add star(*) for directed graph
metric_name_directed = strcat(metric_name_directed, '*');
disp(metric_name_directed);

% combine two array
metric_name_all = [metric_name_undirected metric_name_directed];

% sort
[sorted_time_list, sort_order] = sort(running_time_list);

metric_name_without_underscore = strrep(metric_name_all(sort_order), '_', ' ');
% disp(metric_name_without_underscore);
if metric_name_without_underscore(26)=="mixed degree decomposition"
    metric_name_without_underscore(26) = "mixed degree dec.";
end
X_order = categorical(metric_name_without_underscore);
X_order = reordercats(X_order,metric_name_without_underscore);


% display
b = bar(X_order, sorted_time_list, 'FaceColor', '#283747');

% t = text(X_order,sorted_time_list, string(sorted_time_list)+" s", 'vert','bottom','horiz','center', 'FontSize', 10*font_size/metric_num);

% title('R8 Result (Point Centrality)','FontSize',font_size);
xlabel('centrality metrics','FontSize',font_size);
ylabel('Running Time per Simulation (s)','FontSize',font_size);
set(gca,'FontSize',font_size,'YScale','log');
