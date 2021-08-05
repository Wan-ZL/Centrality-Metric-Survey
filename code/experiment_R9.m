clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
% metric_name_undirected = ["distance_based_GC", "degree_based_GC","betweenness_based_GC","flow_betweenness_GC", "closeness_based_GC","k_component","degree_assortativity","local_assortativity","graph_curvature" ,"global_clustering","k_core","k_plex","k_clique"];
% metric_name_undirected = ["distance_based_GC", "degree_based_GC","betweenness_based_GC","flow_betweenness_GC", "closeness_based_GC","k_component","degree_assortativity","local_assortativity","graph_curvature" ,"ACC","k_core","k_plex","k_clique"];  % renamed global_clustering to ACC
metric_name_undirected = ["faster_betweenness", "delta_centrality", "flow_betweenness","betweenness"];
font_size = 30;

metric_num_undirected = length(metric_name_undirected);

GC_SGC_result_list = zeros(metric_num_undirected,6);
% read all runtime data from undirected folder
running_time_list = zeros(metric_num_undirected,1);
for index = 1:metric_num_undirected
    running_time_list(index) = readmatrix(strcat('data/R6/undirected/ER_network/',metric_name_undirected(index),'_runtime'));  % CHANGE
end

% sort
[sorted_time_list, sort_order] = sort(running_time_list);
disp(sorted_time_list);
metric_name_without_underscore = strrep(metric_name_undirected(sort_order), '_', ' ');
X_order = categorical(metric_name_without_underscore);
X_order = reordercats(X_order,metric_name_without_underscore);

% display
b = bar(X_order, sorted_time_list, 'FaceColor', 'k');

% xlabel('graph centrality metrics','FontSize',font_size);
ylabel('Running Time per Simulation (sec. in log)','FontSize',font_size);
set(gca,'FontSize',font_size,'YScale','log');
ylim([0.001 2.1]);
% % figure size
x0=10;
y0=80;
width=670;
height=850;
set(gcf,'position',[x0,y0,width,height])