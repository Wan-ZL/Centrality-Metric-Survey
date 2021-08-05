clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
% node_scale = 1895; % the length of array in file (4039 for facebook) (1895 for CollegeMsg)
metric_name = ["random", "hubs","authorities","SALSA_authorities","SALSA_hubs","clusterrank","leaderrank"]; % directed
% metric_name = ["random", "leaderrank", "leaderrank_new"];
% % 
% metric_name = ["random","degree","closeness","betweenness","pagerank","eigenvector","local_entropy","mapping_entropy"];
% metric_name = ["random","local_betweenness","volume","redundancy","kshell","improved_kshell","percolation","hybrid_degree"];
% metric_name = ["random","neighborhood_coreness","flow_betweenness","katz","diffusion_centrality","subgraph","clustering_coef"];
% metric_name = ["random", "information_centrality","residual_closeness","semi_local","mixed_degree_decomposition","dynamic_influence","weight_neighborhood"];
% metric_name = ["random","GDSP_degree","GDSP_closeness","GDSP_betweenness","eccentricity","cumulative_nomination","h_index","contribution"];

% metric_name = ["random","l_betweenness","random_walk_betweenness","routing_betweenness","loadcentrality","Curvature"]; %TO TEST
marker_shape = ["-ko", "-p", "-*", "-^", "-+", "-.", "-x", "-s", "-v", "-d", "->", "-<", "-h"];
plot_size = 2.5;
font_size = 45;
marker_distance = 100;


% x_k = 1:node_scale;
% x_fraction = x_k/node_scale;

metric_num = length(metric_name);
for index = 1:metric_num
    num_comp = readmatrix(strcat('data/R1/directed/tech-routers-rf/',metric_name(index)));  % CHANGE
    simulation_time = num_comp(end);
    run_time = readmatrix(strcat('data/R1/directed/tech-routers-rf/',metric_name(index),'_runtime'));  % CHANGE
    disp(run_time)
%     metric_name(index) = strcat(metric_name(index), " (", num2str (run_time), "s per simu) (simu ", num2str(simulation_time), " times)");
    if simulation_time == 1
        metric_name(index) = strcat(metric_name(index), "*");
    elseif simulation_time == 100
        metric_name(index) = strcat(metric_name(index));
    else
        disp("show simulate time");
        metric_name(index) = strcat(metric_name(index), " (simu ", num2str(simulation_time), " times)");
    end
    
    num_comp = num_comp(1:end-1);
    
    node_scale = length(num_comp);
    x_k = 1:node_scale;
    x_fraction = x_k/node_scale;
    
    num_comp = num_comp/node_scale; % to fraction
    p = plot(x_fraction, num_comp, marker_shape(index), 'MarkerIndices',1:marker_distance:length(num_comp));
    p.MarkerSize = plot_size*12;
    p.LineWidth = plot_size;
    hold on;
end
hold off;

metric_name_without_underscore = strrep(metric_name, '_', ' ');
% if metric_name_without_underscore(6)=="mixed degree decomposition"
%     metric_name_without_underscore(6) = "mixed degree dec.";
% end
lgd = legend(metric_name_without_underscore);
% set(lgd,'Interpreter', 'none')
lgd.FontSize = font_size*1; % was 1.1
xlabel('fraction of removed nodes', 'FontSize',font_size);
ylabel('size of the giant component', 'FontSize',font_size);
set(gca,'FontSize',font_size)