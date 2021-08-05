clear; clc; clf;

% Uncomment code for specific dataset and metric. To use metric, edit function name wih label "CHANGE HERE". 

% CHANGE parameter here
% node_scale = 1895; % the length of array in file (4039 for facebook) (1895 for CollegeMsg)
metric_name = ["random", "hubs","authorities","SALSA_authorities","SALSA_hubs","clusterrank","leaderrank"]; % directed

% metric_name = ["random","degree","closeness","betweenness","pagerank","eigenvector","local_entropy","mapping_entropy"];
% metric_name = ["random","local_betweenness","volume","redundancy","kshell","improved_kshell","percolation","hybrid_degree"];
% metric_name = ["random","neighborhood_coreness","flow_betweenness","katz","diffusion_centrality","subgraph","clustering_coef"];
% metric_name = ["random","information_centrality","residual_closeness","semi_local","mixed_degree_decomposition","dynamic_influence","weight_neighborhood"];
% metric_name = ["random","GDSP_degree","GDSP_closeness","GDSP_betweenness","eccentricity","cumulative_nomination","h_index","l_betweenness","contribution"];
% metric_name = ["random",];

% metric_name = ["random","degree", "volume", "Volume_test_h=0","Volume_test_h=1","Volume_test_h=2","Volume_test_h=3","Volume_test_h=4","Volume_test_h=100","Volume_test_h=1000"]; %TO TEST

marker_shape = ["-ko", "-p", "-*", "-^", "-+", "-.", "-x", "-s", "-v", "-d", "->", "-<", "-h"];
plot_size = 2.5;
font_size = 45;
marker_distance = 1;
original_graph_size = 930;



% x_k = 1:node_scale;
% x_fraction = x_k/node_scale;

metric_num = length(metric_name);
for index = 1:metric_num
    num_comp = readmatrix(strcat('data/R3/directed/tech-routers-rf/',metric_name(index)));  % CHANGE
    simulation_time = num_comp(end);
    run_time = readmatrix(strcat('data/R3/directed/tech-routers-rf/',metric_name(index),'_runtime'));  % CHANGE
    
    disp(metric_name(index));
    disp(run_time);
    run_time_sum = sum(run_time);
    
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
    x_fraction = x_k/100;
    
    num_comp = num_comp/original_graph_size;% *100; % to fraction
    p = plot(x_fraction, num_comp, marker_shape(index), 'MarkerIndices',1:marker_distance:length(num_comp));
%     xtickformat('percentage');
%     ytickformat('percentage');
    
    p.MarkerSize = plot_size*12;
    p.LineWidth = plot_size;
%     text(x_fraction, num_comp+0.002,string(run_time),'HorizontalAlignment','center');
    hold on;
end
hold off;

metric_name_without_underscore = strrep(metric_name, '_', ' ');
% if metric_name_without_underscore(6)=="mixed degree decomposition"
%     metric_name_without_underscore(6) = "mixed degree dec.";
% end
lgd = legend(metric_name_without_underscore);
% set(lgd,'Interpreter', 'none')
lgd.FontSize = font_size;
xlabel('fraction of initial attackers', 'FontSize',font_size);
ylabel('Size of the giant component', 'FontSize',font_size);
set(gca,'FontSize',font_size);
set(gca,'XLim',[0.01 0.1]);  % set windows area
disp(get(gca,'colororder'));
% ylim([1.2 2]);
% ylim([0.7 0.99]);