clear; clc; clf;

% CHANGE parameter here
% metric_name_undirected = ["degree","closeness","betweenness","pagerank","eigenvector","local_betweenness","Volume","redundancy","kshell","improved_kshell","neighborhood_coreness","flow_betweenness","katz","diffusion_centrality","subgraph","information_centrality","residual_closeness","semi_local","mixed_degree_decomposition","GDSP_degree","GDSP_closeness","GDSP_betweenness","eccentricity","cumulative_nomination","local_entropy","mapping_entropy","percolation","hybrid_degree","clustering_coef","contribution","weight_neighborhood", "h_index", "dynamic_influence"];
% metric_name_directed = ["hubs","authorities","clusterrank","SALSA_authorities","SALSA_hubs","leaderrank"];

% =========== above is old group, below is new group ===========
% (show separately for local, iterative, and global Point Centrality metrics)
% Local: 
% metric_name_undirected = ["degree","semi_local","hybrid_degree","volume","clustering_coef","redundancy","local_entropy","mapping_entropy","h_index"];  % no data: Curvature
% metric_name_directed = ["clusterrank"];
% Iterative:
metric_name_undirected = ["kshell","mixed_degree_decomposition","neighborhood_coreness","eigenvector","katz","pagerank","contribution","diffusion_centrality","subgraph","dynamic_influence","cumulative_nomination"];
metric_name_directed = ["hubs","authorities","leaderrank","SALSA_authorities","SALSA_hubs"];
% Global:
% metric_name_undirected = ["improved_kshell","betweenness","flow_betweenness","closeness","residual_closeness","GDSP_degree","GDSP_closeness","GDSP_betweenness","information_centrality","weight_neighborhood","percolation","eccentricity"];
% metric_name_directed = [];
% no data: metric_name = ["random","l_betweenness","random_walk_betweenness","loadcentrality","routing_betweenness"]; % Current-flow, Spatial, AHP



font_size = 40;

metric_num_undirected = length(metric_name_undirected);
metric_num_directed = length(metric_name_directed);
metric_num = metric_num_undirected+metric_num_directed;
running_time_list = zeros(metric_num,1);

% read all data from undirected folder
% tech-routers-rf is Rocketfuel Network (directed)
% CollegeMsg is UCI Social Network (directed)
% email-Eu is EU Email Network (undirected)
% ia-email-univ is URV Email Network (undirected)
for index = 1:metric_num_undirected
    run_time = readmatrix(strcat('data/R1/undirected/ia-email-univ/',metric_name_undirected(index),'_runtime'));  % CHANGE
    running_time_list(index) = run_time;
    disp(run_time)
end

% read all data from directed folder
for index = 1:metric_num_directed
    run_time = readmatrix(strcat('data/R1/directed/CollegeMsg/',metric_name_directed(index),'_runtime'));  % CHANGE
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
% if have "mixed_degree_decomposition", uncomment below
if length(metric_name_without_underscore) >= 8
    if metric_name_without_underscore(8)=="mixed degree decomposition"
        metric_name_without_underscore(8) = "mixed degree dec.";
    end
end
X_order = categorical(metric_name_without_underscore);
X_order = reordercats(X_order,metric_name_without_underscore);


% display
b = bar(X_order, sorted_time_list, 'FaceColor', 'k');

% t = text(X_order,sorted_time_list, string(sorted_time_list)+" s", 'vert','bottom','horiz','center', 'FontSize', 10*font_size/metric_num);

% title('R8 Result (Point Centrality)','FontSize',font_size);
xlabel('centrality metrics','FontSize',font_size);
ylabel('Running Time per Simulation (s)','FontSize',font_size);
ylim([10^(-2) 10^3])

xtickangle(xtickangle)
disp(xtickangle);
set(gca,'FontSize',font_size,'YScale','log');
